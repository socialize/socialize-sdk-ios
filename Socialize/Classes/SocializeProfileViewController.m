//
//  ProfileViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/26/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeProfileViewController.h"
#import "ImagesCache.h"
#import "UINavigationBarBackground.h"
#import "UIButton+Socialize.h"
#import "UINavigationController+Socialize.h"
#import "SocializeActivityViewController.h"

@interface SocializeProfileViewController ()
-(void)configureViews;
- (void)addActivityControllerToView;
@end

@implementation SocializeProfileViewController
@synthesize delegate = delegate_;
@synthesize user = user_;
@synthesize fullUser = fullUser_;
@synthesize userNameLabel = userNameLabel_;
@synthesize userDescriptionLabel = userDescriptionLabel_;
@synthesize userLocationLabel = userLocationLabel_;
@synthesize profileImageView = profileImageView_;
@synthesize profileImageActivityIndicator = profileImageActivityIndicator_;
@synthesize imagesCache = imagesCache_;
@synthesize defaultProfileImage = defaultProfileImage_;
@synthesize alertView = alertView_;
@synthesize activityViewController = activityViewController_;
@synthesize activityLoadingActivityIndicator = activityLoadingActivityIndicator_;

- (void)dealloc {
    self.user = nil;
    self.fullUser = nil;
    self.userNameLabel = nil;
    self.userDescriptionLabel = nil;
    self.userLocationLabel = nil;
    self.profileImageView = nil;
    self.profileImageActivityIndicator = nil;
    self.profileEditViewController.delegate = nil;
    self.profileEditViewController = nil;
    self.navigationControllerForEdit.delegate = nil;
    self.navigationControllerForEdit = nil;
    self.imagesCache = nil;
    self.defaultProfileImage = nil;
    self.alertView = nil;
    [activityViewController_ setDelegate:nil];
    self.activityViewController = nil;
    self.activityLoadingActivityIndicator = nil;
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.userNameLabel = nil;
    self.userDescriptionLabel = nil;
    self.userLocationLabel = nil;
    self.profileImageView = nil;
    self.navigationControllerForEdit = nil;
    self.defaultProfileImage = nil;
    self.activityViewController = nil;
}

+ (UINavigationController*)socializeProfileViewControllerForUser:(id<SocializeUser>)user delegate:(id<SocializeBaseViewControllerDelegate>)delegate {
    SocializeProfileViewController *profile = [[[SocializeProfileViewController alloc] initWithUser:user delegate:delegate] autorelease];
    UIImage *navImage = [UIImage imageNamed:@"socialize-navbar-bg.png"];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:profile] autorelease];
    [nav.navigationBar setBackgroundImage:navImage];
    return nav;
}

+ (UINavigationController*)socializeProfileViewControllerWithDelegate:(id<SocializeBaseViewControllerDelegate>)delegate {
    return [SocializeProfileViewController socializeProfileViewControllerForUser:nil delegate:delegate];
}

+ (UINavigationController*)currentUserProfileWithDelegate:(id<SocializeBaseViewControllerDelegate>)delegate {
    return [SocializeProfileViewController socializeProfileViewControllerWithDelegate:delegate];
}

- (id)initWithUser:(id<SocializeUser>)user delegate:(id<SocializeBaseViewControllerDelegate>)delegate {
    if( self = [self init] ) {
        self.delegate = delegate;
        self.user = user;
    }
    return self;
}
- (id)init {
    return [super initWithNibName:@"SocializeProfileViewController" bundle:nil];
}

- (void)afterLoginAction:(BOOL)userChanged {
    if (self.fullUser != nil) {
        // Already have a full user
        [self configureViews];
    } else if (self.user != nil) {
        // Have a partial user object, fetch the whole thing
        [self startLoading];
        [self.socialize getUserWithId:self.user.objectID];
    } else {
        // no full user or partial user, load for current user
        [self getCurrentUser];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Profile";
    
    //we will show a done button here if there is not left barbutton item already showing
    if (!self.navigationItem.leftBarButtonItem)
        self.navigationItem.leftBarButtonItem = self.doneButton;

    [self setProfileImageFromImage:[self defaultProfileImage]];
    
    [self addActivityControllerToView];
}

#pragma mark - View lifecycle

- (UIImage*)defaultProfileImage {
    if (defaultProfileImage_ == nil) {
        defaultProfileImage_ = [[UIImage imageNamed:@"socialize-profileimage-large-default.png"] retain];
    }
    
    return defaultProfileImage_;
}

- (void)setProfileImageFromImage:(UIImage*)image {
    if (image == nil) {
        self.profileImageView.image = self.defaultProfileImage;
    }
    else {
        self.profileImageView.image = image;
    }
}

- (ImagesCache*)imagesCache {
    if (imagesCache_ == nil) {
        imagesCache_ = [[ImagesCache sharedImagesCache] retain];
    }
    
    return imagesCache_;
}

- (void)setProfileImageFromURL:(NSString*)imageURL {
    
    // Empty url -- use default image
    if (imageURL == nil) {
        self.profileImageView.image = self.defaultProfileImage;
        return;
    }
    
    // Already have it loaded
    UIImage *existing = [self.imagesCache imageFromCache:imageURL];
    if (existing != nil) {
        [self setProfileImageFromImage:existing];
        return;
    }

    // Download image
    
    [self.profileImageActivityIndicator startAnimating];

    // FIXME implementation should handle copy
    CompleteBlock complete = [[^(ImagesCache* imgs){
        UIImage *loadedImage = [imgs imageFromCache:imageURL];
        [self setProfileImageFromImage:loadedImage];
        [self.profileImageActivityIndicator stopAnimating];
    } copy] autorelease];
    
    [self.imagesCache loadImageFromUrl:imageURL
                        completeAction:complete];
}

- (void)configureEditButton {
    BOOL isCurrentUserProfile = (self.fullUser.objectID == [[self.socialize authenticatedUser] objectID]);
    if (isCurrentUserProfile) {
        self.navigationItem.rightBarButtonItem = self.settingsButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)configureViews {
    // Configure labels
    self.userNameLabel.text = self.fullUser.userName;
    if (self.fullUser.firstName != nil && self.fullUser.lastName != nil) {
        self.userDescriptionLabel.text = [NSString stringWithFormat:@"%@ %@", self.fullUser.firstName, self.fullUser.lastName];
    }
    
    // Configure the profile image
    [self setProfileImageFromURL:self.fullUser.smallImageUrl];
    [self configureEditButton];
    self.activityViewController.currentUser = self.fullUser.objectID;
    [self.activityViewController initializeContent];
}

- (void)showEditController {
    self.profileEditViewController.fullUser = self.fullUser;
    self.profileEditViewController.profileImage = self.profileImageView.image;
    [super showEditController];
}

- (void)profileEditViewController:(SocializeProfileEditViewController *)profileEditViewController didUpdateProfileWithUser:(id<SocializeFullUser>)user {
    self.fullUser = user;
    [self configureViews];
    [self.activityViewController fullUserChanged:self.fullUser];
    
    [super profileEditViewController:profileEditViewController didUpdateProfileWithUser:user];
}

- (SocializeActivityViewController*)activityViewController {
    if (activityViewController_ == nil) {
        activityViewController_ = [[SocializeActivityViewController alloc] init];
        activityViewController_.delegate = self;
        activityViewController_.dontShowNames = YES;
        
        BOOL entityLoaderUndefined = [Socialize entityLoaderBlock] == nil;
        activityViewController_.dontShowDisclosure = entityLoaderUndefined;
    }
    
    return activityViewController_;
}

- (void)activityViewControllerDidStartLoadingActivity:(SocializeActivityViewController *)activityViewController {
//    [self.activityLoadingActivityIndicator startAnimating];
}

- (void)activityViewControllerDidStopLoadingActivity:(SocializeActivityViewController *)activityViewController {
//    [self.activityLoadingActivityIndicator stopAnimating];
}

- (void)activityViewController:(SocializeActivityViewController *)activityViewController profileTappedForUser:(id<SocializeUser>)user {
    if (user.objectID != self.fullUser.objectID) {
        UINavigationController *profile = [SocializeProfileViewController socializeProfileViewControllerForUser:user delegate:nil];
        [self presentModalViewController:profile animated:YES];
    }
}

- (void)activityViewController:(SocializeActivityViewController *)activityViewController activityTapped:(id<SocializeActivity>)activity {
    SocializeEntityLoaderBlock entityLoader = [Socialize entityLoaderBlock];
    if (self.navigationController != nil && entityLoader != nil) {
        entityLoader(self.navigationController, activity.entity);
    }
}

- (void)addActivityControllerToView {
    CGRect activityFrame = self.view.frame;
	self.activityViewController.view.frame = CGRectMake(0,160, activityFrame.size.width, activityFrame.size.height-160);
    [self.view addSubview:self.activityViewController.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didGetCurrentUser:(id<SocializeFullUser>)fullUser {
    self.fullUser = fullUser;
    [self configureViews];
}

- (IBAction)headerTapped:(id)sender {
    [self.activityViewController scrollToTop];
}

@end
