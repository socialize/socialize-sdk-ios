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
@end

@implementation SocializeProfileViewController
@synthesize delegate = delegate_;
@synthesize doneButton = doneButton_;
@synthesize editButton = editButton_;
@synthesize user = user_;
@synthesize fullUser = fullUser_;
@synthesize userNameLabel = userNameLabel_;
@synthesize userDescriptionLabel = userDescriptionLabel_;
@synthesize userLocationLabel = userLocationLabel_;
@synthesize profileImageView = profileImageView_;
@synthesize profileImageActivityIndicator = profileImageActivityIndicator_;
@synthesize profileEditViewController = profileEditViewController_;
@synthesize loadingView = loadingView_;
@synthesize socialize = socialize_;
@synthesize navigationControllerForEdit = navigationControllerForEdit_;
@synthesize imagesCache = imagesCache_;

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
    self.doneButton = nil;
    self.editButton = nil;
    self.fullUser = nil;
    self.userNameLabel = nil;
    self.userDescriptionLabel = nil;
    self.userLocationLabel = nil;
    self.profileImageView = nil;
    self.profileEditViewController.delegate = nil;
    self.profileEditViewController = nil;
    self.navigationControllerForEdit.delegate = nil;
    self.navigationControllerForEdit = nil;
    self.socialize = nil;
    
    [super dealloc];
}

- (id)init {
    return [super initWithNibName:@"SocializeProfileViewController" bundle:nil];
}

- (ImagesCache*)imagesCache {
    if (imagesCache_ == nil) {
        imagesCache_ = [[ImagesCache sharedImagesCache] retain];
    }
    
    return imagesCache_;
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    
    return socialize_;
}

- (UIBarButtonItem*)doneButton {
    if (doneButton_ == nil) {
        UIButton *button = [UIButton blueSocializeNavBarButtonWithTitle:@"Done"];
        [button addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        doneButton_ = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return doneButton_;
}

- (UIBarButtonItem*)editButton {
    if (editButton_ == nil) {
        UIButton *button = [UIButton blueSocializeNavBarButtonWithTitle:@"Edit"];
        [button addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        editButton_ = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return editButton_;
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
    return [UIImage imageNamed:@"socialize-profileimage-large-default.png"];
}

- (void)configureViewsForUser:(id<SocializeFullUser>)user {
    
    // Configure labels
    self.userNameLabel.text = user.userName;
    if (user.firstName != nil && user.lastName != nil) {
        self.userDescriptionLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    }
    
    // Configure the profile image
    NSString *url = user.smallImageUrl;
    
    if (url != nil) {
        UIImage *existing = [self.imagesCache imageFromCache:url];
        if (existing != nil) {
            self.profileImageView.image = existing;
        } else {
            CompleteBlock complete = [[^(ImagesCache* imgs){
                UIImage *loadedImage = [imgs imageFromCache:url];
                if (loadedImage != nil) {
                    self.profileImageView.image = loadedImage;
                } else {
                    self.profileImageView.image = [self defaultProfileImage];
                }
                [self.profileImageActivityIndicator stopAnimating];
            } copy] autorelease];
            
            [self.profileImageActivityIndicator startAnimating];
            [self.imagesCache loadImageFromUrl:url
                                               completeAction:complete];
        }
    }
    
    BOOL isCurrentUserProfile = (user.objectID == [[self.socialize authenticatedUser] objectID]);
    if (isCurrentUserProfile) {
        self.navigationItem.rightBarButtonItem = self.editButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)startLoading {
    self.loadingView = [LoadingView loadingViewInView:self.view];
}

- (void)stopLoading {
    [self.loadingView removeView]; self.loadingView = nil;
}

-(void)service:(SocializeService*)service didFail:(NSError*)error
{
    [self stopLoading];
    
    UIAlertView *msg;
    msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:[NSString stringWithFormat: @"cannot get profile %@", [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray
{
    [self stopLoading];
    
    id<SocializeFullUser> fullUser = [dataArray objectAtIndex:0];
    NSAssert([fullUser conformsToProtocol:@protocol(SocializeFullUser)], @"Not a socialize user");
    self.fullUser = fullUser;
    [self configureViewsForUser:self.fullUser];
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object
{
    [self stopLoading];
    self.fullUser = (id<SocializeFullUser>)object;
    [self configureViewsForUser:self.fullUser];
    [self hideEditController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.doneButton;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"socialize-navbar-bg.png"]];

    self.profileImageView.image = [self defaultProfileImage];

    if (self.fullUser != nil) {
        [self configureViewsForUser:self.fullUser];
    } else if (self.user != nil) {
        [self startLoading];
        [self.socialize getUserWithId:self.user.objectID];
    } else {
        [self startLoading];
        [self.socialize getCurrentUser];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.doneButton = nil;
    self.editButton = nil;
    self.userNameLabel = nil;
    self.userDescriptionLabel = nil;
    self.userLocationLabel = nil;
    self.profileImageView = nil;
    self.profileEditViewController = nil;
}

- (SocializeProfileEditViewController*)profileEditViewController {
    if (profileEditViewController_ == nil) {
        profileEditViewController_ = [[SocializeProfileEditViewController alloc]
                                      init];
        profileEditViewController_.delegate = self;
    }
    return profileEditViewController_;
}

-(void)showEditController
{
    UINavigationController *nav = [UINavigationController socializeNavigationControllerWithRootViewController:self.profileEditViewController];
    nav.delegate = self;
    self.profileEditViewController.profileImage = self.profileImageView.image;
    self.profileEditViewController.firstName = self.fullUser.firstName;
    self.profileEditViewController.lastName = self.fullUser.lastName;
    self.profileEditViewController.bio = [self.fullUser description];
    [self.navigationController presentModalViewController:nav animated:YES];
}


-(void)hideEditController
{
    [self stopLoading];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)localNavigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // This is weird. 1234 is special tag set by our UINavigationBar setBackgroundImage: on iOS pre-5.0
    // It is used because somehow the background image moves to the front after some controller transitions
    [localNavigationController.navigationBar resetBackground:1234];
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

@end
