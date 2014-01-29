//
//  ProfileViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/26/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "_SZUserProfileViewController.h"
#import "ImagesCache.h"
#import "UINavigationBarBackground.h"
#import "UIButton+Socialize.h"
#import "UINavigationController+Socialize.h"
#import "SocializeActivityViewController.h"
#import "SZNavigationController.h"
#import "SZUserUtils.h"
#import "socialize_globals.h"
#import "UIDevice+VersionCheck.h"
#import "_SZUserProfileViewControllerIOS6.h"

@interface _SZUserProfileViewController ()
-(void)configureViews;
- (void)addActivityControllerToView;
@end

@implementation _SZUserProfileViewController
@synthesize delegate = delegate_;
@synthesize user = user_;
@synthesize fullUser = fullUser_;
@synthesize userNameLabel = userNameLabel_;
@synthesize userDescriptionLabel = userDescriptionLabel_;
@synthesize userLocationLabel = userLocationLabel_;
@synthesize backgroundImageView = backgroundImageView_;
@synthesize sectionHeaderView = sectionHeaderView_;
@synthesize profileImageView = profileImageView_;
@synthesize profileImageBackgroundView = profileImageBackgroundView_;
@synthesize profileImageActivityIndicator = profileImageActivityIndicator_;
@synthesize imagesCache = imagesCache_;
@synthesize alertView = alertView_;
@synthesize activityViewController = activityViewController_;
@synthesize activityLoadingActivityIndicator = activityLoadingActivityIndicator_;
@synthesize completionBlock = completionBlock_;

+ (id)alloc {
    if([self class] == [_SZUserProfileViewController class] &&
       [[UIDevice currentDevice] systemMajorVersion] < 7) {
        return [_SZUserProfileViewControllerIOS6 alloc];
    }
    else {
        return [super alloc];
    }
}

- (void)dealloc {
    self.user = nil;
    self.fullUser = nil;
    self.userNameLabel = nil;
    self.userDescriptionLabel = nil;
    self.userLocationLabel = nil;
    self.profileImageView = nil;
    self.profileImageActivityIndicator = nil;
    self.imagesCache = nil;
    self.alertView = nil;
    [activityViewController_ setDelegate:nil];
    self.activityViewController = nil;
    self.activityLoadingActivityIndicator = nil;
    
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.userNameLabel = nil;
    self.userDescriptionLabel = nil;
    self.userLocationLabel = nil;
    self.profileImageView = nil;
    self.activityViewController = nil;
}

+ (UINavigationController*)socializeProfileViewControllerForUser:(id<SocializeUser>)user delegate:(id<SocializeBaseViewControllerDelegate>)delegate {
    _SZUserProfileViewController *profile = [[[_SZUserProfileViewController alloc] initWithUser:user delegate:delegate] autorelease];
    UIImage *navImage = [UIImage imageNamed:@"socialize-navbar-bg.png"];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:profile] autorelease];
    [nav.navigationBar setBackgroundImage:navImage];
    return nav;
}

+ (_SZUserProfileViewController*)profileViewController {
    return [[[_SZUserProfileViewController alloc] init] autorelease];
}

+ (UINavigationController*)profileViewControllerInNavigationController {
    _SZUserProfileViewController *profile = [self profileViewController];
    return [[[SZNavigationController alloc] initWithRootViewController:profile] autorelease];
}


+ (UINavigationController*)socializeProfileViewControllerWithDelegate:(id<SocializeBaseViewControllerDelegate>)delegate {
    return [_SZUserProfileViewController socializeProfileViewControllerForUser:nil delegate:delegate];
}

+ (UINavigationController*)currentUserProfileWithDelegate:(id<SocializeBaseViewControllerDelegate>)delegate {
    return [_SZUserProfileViewController socializeProfileViewControllerWithDelegate:delegate];
}

- (id)initWithUser:(id<SocializeUser>)user delegate:(id<SocializeBaseViewControllerDelegate>)delegate {
    if (self = [super initWithNibName:@"_SZUserProfileViewController" bundle:nil]) {
        self.delegate = delegate;
        self.user = user;
    }
    return self;
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
        self.fullUser = [SZUserUtils currentUser];
        [self configureViews];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Profile";
    
    //we will show a done button here if there is not left barbutton item already showing
    if (!self.navigationItem.leftBarButtonItem) {
        WEAK(self) weakSelf = self;
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem blueSocializeBarButtonWithTitle:@"Done" handler:^(id sender) {
            if ([weakSelf.delegate respondsToSelector:@selector(baseViewControllerDidFinish:)]) {
                [weakSelf.delegate baseViewControllerDidFinish:weakSelf];
            } else {
                BLOCK_CALL_1(weakSelf.completionBlock, weakSelf.fullUser);
            }
        }];
    }

    self.backgroundImageView.image = [self defaultBackgroundImage];
    self.sectionHeaderView.image = [self defaultHeaderBackgroundImage];
    [self setProfileImageFromImage:[self defaultProfileImage]];
    [self addActivityControllerToView];
    
    //iOS 7 adjustments for nav bar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - View lifecycle


- (UIImage*)defaultProfileImage {
    return nil;
}

- (UIImage*)defaultProfileBackgroundImage {
    return [UIImage imageNamed:@"socialize-profileimage-large-bg-ios7.png"];
}

- (UIImage *)defaultBackgroundImage {
    return [UIImage imageNamed:@"background_plain.png"];
}

- (UIImage *)defaultHeaderBackgroundImage {
    return [UIImage imageNamed:@"socialize-sectionheader-bg-ios7.png"];
}

- (void)setProfileImageFromImage:(UIImage*)image {
    self.profileImageView.image = nil; //in this variant, profile image and background are one and the same
    if (image == nil) {
        self.profileImageBackgroundView.image = [self defaultProfileBackgroundImage];
    }
    else {
        self.profileImageBackgroundView.image = image;
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
    self.userNameLabel.text = self.fullUser.displayName;
    if ([[self.fullUser description] length] > 0) {
        self.userDescriptionLabel.text = [self.fullUser description];
    }
    
    // Configure the profile image
    [self setProfileImageFromURL:self.fullUser.smallImageUrl];
    [self configureEditButton];
    self.activityViewController.currentUser = self.fullUser.objectID;
    [self.activityViewController initializeContent];
}

- (void)userChanged:(id<SocializeFullUser>)newUser {
    self.fullUser = newUser;
    [self configureViews];
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
        _SZUserProfileViewController *profile = [_SZUserProfileViewController profileViewController];
        profile.user = user;
        SZNavigationController *nav = [[[SZNavigationController alloc] initWithRootViewController:profile] autorelease];
        [self presentViewController:nav animated:YES completion:nil];
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

- (void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray {
    [self stopLoading];
    [self didGetCurrentUser:[dataArray objectAtIndex:0]];
}

- (IBAction)headerTapped:(id)sender {
    [self.activityViewController scrollToTop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    }
}

@end
