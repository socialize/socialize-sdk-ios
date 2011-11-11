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
#import "LoadingView.h"
#import "ImagesCache.h"
#import "UINavigationController+Socialize.h"

@interface SocializeProfileViewController ()
-(void)showEditController;
-(void)hideEditController;
-(void)configureViews;
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
@synthesize loadingView = loadingView_;
@synthesize navigationControllerForEdit = navigationControllerForEdit_;
@synthesize imagesCache = imagesCache_;
@synthesize defaultProfileImage = defaultProfileImage_;
@synthesize alertView = alertView_;

+ (UIViewController*)socializeProfileViewControllerForUser:(id<SocializeUser>)user delegate:(id<SocializeProfileViewControllerDelegate>)delegate {
    SocializeProfileViewController *profile = [[[SocializeProfileViewController alloc] init] autorelease];
    profile.delegate = delegate;
    profile.user = user;
    UIImage *navImage = [UIImage imageNamed:@"socialize-navbar-bg.png"];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:profile] autorelease];
    [nav.navigationBar setBackgroundImage:navImage];
    return nav;
}

+ (UIViewController*)socializeProfileViewControllerWithDelegate:(id<SocializeProfileViewControllerDelegate>)delegate {
    return [self socializeProfileViewControllerForUser:nil delegate:delegate];
}

+ (UIViewController*)currentUserProfileWithDelegate:(id<SocializeProfileViewControllerDelegate>)delegate {
    return [self socializeProfileViewControllerWithDelegate:delegate];
}

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
    self.socialize.delegate = nil;
    self.socialize = nil;
    self.imagesCache = nil;
    self.defaultProfileImage = nil;
    
    [super dealloc];
}

- (id)init {
    return [super initWithNibName:@"SocializeProfileViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.doneButton;
    self.profileImageView.image = [self defaultProfileImage];
    
    if (self.fullUser != nil) {
        // Already have a full user
        [self configureViews];
    } else if (self.user != nil) {
        // Have a partial user object, fetch the whole thing
        [self startLoading];
        [self.socialize getUserWithId:self.user.objectID];
    } else {
        // no full user or partial user, load for current user
        [self startLoading];
        [self.socialize getCurrentUser];
    }
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
}

- (void)editButtonPressed:(UIBarButtonItem*)button {
    [self showEditController];
}

- (void)doneButtonPressed:(UIBarButtonItem*)button {
    if (self.delegate != nil) {
        [self.delegate profileViewControllerDidCancel:self];
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
    self.profileEditViewController.profileImage = self.profileImageView.image;
    self.profileEditViewController.firstName = self.fullUser.firstName;
    self.profileEditViewController.lastName = self.fullUser.lastName;
    self.profileEditViewController.bio = [self.fullUser description];
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

- (void)profileEditViewControllerDidSave:(SocializeProfileEditViewController *)profileEditViewController {
    self.loadingView = [LoadingView loadingViewInView:self.profileEditViewController.navigationController.view];
	self.profileEditViewController.navigationItem.rightBarButtonItem.enabled = NO;
    
    id<SocializeFullUser> userCopy = [(id)self.fullUser copy];
    userCopy.firstName = self.profileEditViewController.firstName;
    userCopy.lastName = self.profileEditViewController.lastName;
    userCopy.description = self.profileEditViewController.bio;
    UIImage* newProfileImage = self.profileEditViewController.profileImage;
    [self.socialize updateUserProfile:userCopy profileImage:newProfileImage];
}

-(void)service:(SocializeService*)service didFail:(NSError*)error
{
    [self stopLoading];
    [self showAllertWithText:[NSString stringWithFormat: @"cannot get profile %@", [error localizedDescription]] andTitle:@"Error occurred"];
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray
{
    [self stopLoading];
    
    id<SocializeFullUser> fullUser = [dataArray objectAtIndex:0];
    NSAssert([fullUser conformsToProtocol:@protocol(SocializeFullUser)], @"Not a socialize user");
    self.fullUser = fullUser;
    [self configureViews];
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object
{
    [self stopLoading];
    self.fullUser = (id<SocializeFullUser>)object;
    [self configureViews];
    [self hideEditController];
}


@end
