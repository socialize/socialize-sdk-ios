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
-(void)showEditController;
-(void)hideEditController;
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
@synthesize profileEditViewController = profileEditViewController_;
@synthesize navigationControllerForEdit = navigationControllerForEdit_;
@synthesize imagesCache = imagesCache_;
@synthesize defaultProfileImage = defaultProfileImage_;
@synthesize alertView = alertView_;
@synthesize activityViewController = activityViewController_;
@synthesize activityLoadingActivityIndicator = activityLoadingActivityIndicator_;

- (void)dealloc {
    self.fullUser = nil;
    self.userNameLabel = nil;
    self.userDescriptionLabel = nil;
    self.userLocationLabel = nil;
    self.profileImageView = nil;
    self.profileEditViewController.delegate = nil;
    self.profileEditViewController = nil;
    self.navigationControllerForEdit.delegate = nil;
    self.navigationControllerForEdit = nil;
    self.imagesCache = nil;
    self.defaultProfileImage = nil;
    self.activityViewController = nil;
    self.activityViewController.delegate = nil;
    self.activityViewController = nil;
    
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
    self.profileEditViewController = nil;
    self.defaultProfileImage = nil;
    self.activityViewController = nil;
}

+ (UINavigationController*)socializeProfileViewControllerForUser:(id<SocializeUser>)user delegate:(id<SocializeProfileViewControllerDelegate>)delegate {
    SocializeProfileViewController *profile = [[[SocializeProfileViewController alloc] initWithUser:user delegate:delegate] autorelease];
    UIImage *navImage = [UIImage imageNamed:@"socialize-navbar-bg.png"];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:profile] autorelease];
    [nav.navigationBar setBackgroundImage:navImage];
    return nav;
}

+ (UINavigationController*)socializeProfileViewControllerWithDelegate:(id<SocializeProfileViewControllerDelegate>)delegate {
    return [SocializeProfileViewController socializeProfileViewControllerForUser:nil delegate:delegate];
}

+ (UINavigationController*)currentUserProfileWithDelegate:(id<SocializeProfileViewControllerDelegate>)delegate {
    return [SocializeProfileViewController socializeProfileViewControllerWithDelegate:delegate];
}

- (id)initWithUser:(id<SocializeUser>)user delegate:(id<SocializeProfileViewControllerDelegate>)delegate {
    if( self = [self init] ) {
        self.delegate = delegate;
        self.user = user;
    }
    return self;
}
- (id)init {
    return [super initWithNibName:@"SocializeProfileViewController" bundle:nil];
}

- (void)afterLoginAction {
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

    self.profileImageView.image = [self defaultProfileImage];
    
    [self addActivityControllerToView];
}

- (void)editButtonPressed:(UIBarButtonItem*)button {
    [self showEditController];
}

- (void)doneButtonPressed:(UIBarButtonItem*)button {
    if ([self.delegate respondsToSelector:@selector(profileViewControllerDidFinish:)]) {
        [self.delegate profileViewControllerDidFinish:self];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
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
        self.navigationItem.rightBarButtonItem = self.editButton;
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
    [self.activityViewController setCurrentUser:self.fullUser.objectID];
}

- (SocializeProfileEditViewController*)profileEditViewController {
    if (profileEditViewController_ == nil) {
        profileEditViewController_ = [[SocializeProfileEditViewController alloc]
                                      init];
        profileEditViewController_.delegate = self;
    }
    return profileEditViewController_;
}

- (UINavigationController*)navigationControllerForEdit {
    if (navigationControllerForEdit_ == nil) {
        navigationControllerForEdit_ = [[UINavigationController socializeNavigationControllerWithRootViewController:self.profileEditViewController] retain];
        navigationControllerForEdit_.delegate = self;
    }
    return navigationControllerForEdit_;
}

-(void)showEditController
{
    self.profileEditViewController.fullUser = self.fullUser;
    self.profileEditViewController.profileImage = self.profileImageView.image;
    [self presentModalViewController:self.navigationControllerForEdit animated:YES];
}


-(void)hideEditController
{
    [self stopLoading];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)profileEditViewControllerDidCancel:(SocializeProfileEditViewController *)profileEditViewController {
	[self hideEditController];    
}

- (void)profileEditViewController:(SocializeProfileEditViewController *)profileEditViewController didUpdateProfileWithUser:(id<SocializeFullUser>)user {
    self.fullUser = user;
    [self configureViews];
    [self hideEditController];
}

- (SocializeActivityViewController*)activityViewController {
    if (activityViewController_ == nil) {
        activityViewController_ = [[SocializeActivityViewController alloc] init];
        activityViewController_.delegate = self;
        activityViewController_.dontShowNames = YES;
        activityViewController_.dontShowDisclosure = ![self.delegate respondsToSelector:@selector(profileViewController:wantsViewActivity:)];
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
    if ([self.delegate respondsToSelector:@selector(profileViewController:wantsViewActivity:)]) {
        [self.delegate profileViewController:self wantsViewActivity:activity];
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

-(void)service:(SocializeService*)service didFail:(NSError*)error
{
    [self stopLoading];
    [self showAlertWithText:[NSString stringWithFormat: @"cannot get profile %@", [error localizedDescription]] andTitle:@"Error occurred"];
}

- (void)didGetCurrentUser:(id<SocializeFullUser>)fullUser {
    self.fullUser = fullUser;
    [self configureViews];
}

- (IBAction)headerTapped:(id)sender {
    [self.activityViewController scrollToTop];
}

@end
