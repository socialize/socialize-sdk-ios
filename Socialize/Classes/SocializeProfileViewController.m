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
    self.profileEditViewController = nil;
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

/*******
 Legacy profile edit stuff -- please make sure most of this moves into SocializeProfileEditViewController
 *******/

-(NSMutableDictionary *) valueDictionary
{
	NSMutableDictionary * dictionary = [[[NSMutableDictionary alloc]initWithCapacity:5]autorelease];
	
	if (self.fullUser.firstName != nil) 
	{
	    [dictionary setObject:self.fullUser.firstName forKey:@"first name"];
	}
	
	if (self.fullUser.lastName != nil) 
	{
		[dictionary setObject:self.fullUser.lastName forKey:@"last name"];
	}
	
	if (self.fullUser.description != nil) 
	{
		[dictionary setObject:self.fullUser.description forKey:@"bio"];
	}
	
	return dictionary;
}

- (SocializeProfileEditViewController*)profileEditViewController {
    if (profileEditViewController_ == nil) {
        profileEditViewController_ = [[SocializeProfileEditViewController alloc]
                                     initWithStyle:UITableViewStyleGrouped];
    }
    return profileEditViewController_;
}

- (UINavigationController*)navigationControllerForEdit {
    if (navigationControllerForEdit_ == nil) {
        UIImage * socializeNavBarBackground = [UIImage imageNamed:@"socialize-navbar-bg.png"];
        
        navigationControllerForEdit_ = [[UINavigationController alloc] 
                                        initWithRootViewController:self.profileEditViewController];
        [navigationControllerForEdit_.navigationBar setBackgroundImage:socializeNavBarBackground];
        navigationControllerForEdit_.delegate = self;
        navigationControllerForEdit_.wantsFullScreenLayout = YES;
    }
    return navigationControllerForEdit_;
}

-(void)showEditController
{
    self.profileEditViewController.delegate = self;
    
    NSMutableDictionary * dictionary = [self valueDictionary];
    
    NSArray * keyArray = [NSArray arrayWithObjects:@"first name", @"last name", @"bio", nil];
    
    self.profileEditViewController.keyValueDictionary = dictionary;
    self.profileEditViewController.keysToEdit = keyArray;
    
    self.profileEditViewController.navigationItem.rightBarButtonItem.enabled = NO;
    
    UIButton * cancelButton = [UIButton redSocializeNavBarButtonWithTitle:@"Cancel"];
    [cancelButton addTarget:self action:@selector(editVCCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * editLeftItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    profileEditViewController_.navigationItem.leftBarButtonItem = editLeftItem;	
    [editLeftItem release];
    
    
    UIButton * saveButton = [UIButton blueSocializeNavBarButtonWithTitle:@"Save"];
    [saveButton addTarget:self action:@selector(editVCSave:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem  * editRightItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    profileEditViewController_.navigationItem.rightBarButtonItem = editRightItem;	
    [editRightItem release];
    
    

	CGRect windowFrame = self.view.window.frame;
	CGRect navFrame = CGRectMake(0,windowFrame.size.height, windowFrame.size.width, windowFrame.size.height);
	self.navigationControllerForEdit.view.frame = navFrame;
	self.navigationControllerForEdit.navigationBar.tintColor = [UIColor blackColor];
	
	[self.view.window addSubview:self.navigationControllerForEdit.view];
	
	self.profileEditViewController.profileImage = self.profileImageView.image;
    
	CGRect newNavFrame = CGRectMake(0, 0, navFrame.size.width, navFrame.size.height);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(prepare)];
	[UIView setAnimationDuration:0.4];
	self.navigationControllerForEdit.view.frame = newNavFrame;
	[UIView commitAnimations];
}


-(void)hideEditController
{
    [self stopLoading];
	CGRect windowFrame = self.view.window.frame;
	CGRect navFrame = CGRectMake(0,windowFrame.size.height, windowFrame.size.width, windowFrame.size.height);
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(destroy)];
	[UIView setAnimationDuration:0.4];
	self.profileEditViewController.navigationController.view.frame = navFrame;
	[UIView commitAnimations];
}

- (void)navigationController:(UINavigationController *)localNavigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [localNavigationController.navigationBar resetBackground:1234];
}

-(void)editVCSave:(id)button
{
	self.loadingView = [LoadingView loadingViewInView:self.profileEditViewController.navigationController.view];
	self.profileEditViewController.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    id<SocializeFullUser> userCopy = [(id)self.fullUser copy];
    
	[userCopy setFirstName:[self.profileEditViewController.keyValueDictionary valueForKey:@"first name"]];
	[userCopy setLastName:[self.profileEditViewController.keyValueDictionary valueForKey:@"last name"]];
	[userCopy setDescription:[self.profileEditViewController.keyValueDictionary valueForKey:@"bio"]];

    UIImage* newProfileImage = self.profileEditViewController.profileImage;
    [self.socialize updateUserProfile:userCopy profileImage:newProfileImage];

    [userCopy release];
}

-(void)editVCCancel:(id)button
{
	[self hideEditController];
}

-(void)profileEditViewControllerDidCancel:(SocializeProfileEditViewController*)controller;
{
	[self hideEditController];
}

-(void)profileEditViewController:(SocializeProfileEditViewController*)controller didFinishWithError:(NSError*)error
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


@end
