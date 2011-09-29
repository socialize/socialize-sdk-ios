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

@interface SocializeProfileViewController ()
-(void)showEditController;
@end

@implementation SocializeProfileViewController
@synthesize delegate = delegate_;
@synthesize doneButton = doneButton_;
@synthesize editButton = editButton_;
@synthesize user = user_;
@synthesize userNameLabel = userNameLabel_;
@synthesize userDescriptionLabel = userDescriptionLabel_;
@synthesize userLocationLabel = userLocationLabel_;
@synthesize profileImageView = profileImageView_;
@synthesize profileImageActivityIndicator = profileImageActivityIndicator_;
@synthesize profileEditViewController = socializeProfileEditViewController_;
@synthesize loadingView = loadingView_;

- (void)dealloc {
    self.doneButton = nil;
    self.editButton = nil;
    self.user = nil;
    self.userNameLabel = nil;
    self.userDescriptionLabel = nil;
    self.userLocationLabel = nil;
    self.profileImageView = nil;
    self.profileEditViewController = nil;
    
    [super dealloc];
}

- (id)init {
    return [super initWithNibName:@"SocializeProfileViewController" bundle:nil];
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
    /*
    self.profileEditViewController = [[[SocializeProfileEditViewController alloc]
                                       initWithStyle:UITableViewStyleGrouped]
                                      autorelease];
    UINavigationController *newNav = [[[UINavigationController alloc]
                                       initWithRootViewController:self.profileEditViewController]
                                      autorelease];
    [newNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"socialize-navbar-bg.png"]];


    [self.navigationController presentModalViewController:newNav animated:YES];
     */
    
    [self showEditController];
}

- (void)doneButtonPressed:(UIBarButtonItem*)button {
    [self.delegate profileViewControllerDidCancel:self];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (UIImage*)defaultProfileImage {
    return [UIImage imageNamed:@"socialize-profileimage-large-default.png"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.doneButton;
    self.navigationItem.rightBarButtonItem = self.editButton;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"socialize-navbar-bg.png"]];

    self.profileImageView.image = [self defaultProfileImage];

    if (self.user != nil) {
        
        // Configure labels
        self.userNameLabel.text = self.user.userName;
        if (self.user.firstName != nil && self.user.lastName != nil) {
            self.userDescriptionLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
        }
        
        // Configure the profile image
        NSString *url = self.user.smallImageUrl;
        
        if (url != nil) {
            UIImage *existing = [[ImagesCache sharedImagesCache] imageFromCache:url];
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
                [[ImagesCache sharedImagesCache] loadImageFromUrl:url
                                                   completeAction:complete];
            }
        }
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



/*******
 Legacy profile edit stuff -- please make sure most of this moves into SocializeProfileEditViewController
 *******/

-(NSMutableDictionary *) valueDictionary
{
	NSMutableDictionary * dictionary = [[[NSMutableDictionary alloc]initWithCapacity:5]autorelease];
	
	if (self.user.firstName != nil) 
	{
	    [dictionary setObject:self.user.firstName forKey:@"first name"];
	}
	
	if (self.user.lastName != nil) 
	{
		[dictionary setObject:self.user.lastName forKey:@"last name"];
	}
	
	if (self.user.description != nil) 
	{
		[dictionary setObject:self.user.description forKey:@"bio"];
	}
	
	return dictionary;
}


-(void)showEditController
{
    self.profileEditViewController = [[[SocializeProfileEditViewController alloc]
                                       initWithStyle:UITableViewStyleGrouped]
                                      autorelease];
    self.profileEditViewController.delegate = self;

	NSMutableDictionary * dictionary = [self valueDictionary];
	
	NSArray * keyArray = [NSArray arrayWithObjects:@"first name", @"last name", @"bio", nil];
	
	self.profileEditViewController.keyValueDictionary = dictionary;
	self.profileEditViewController.keysToEdit = keyArray;
	
	self.profileEditViewController.navigationItem.rightBarButtonItem.enabled = NO;
	
    UIButton * cancelButton = [UIButton redSocializeNavBarButtonWithTitle:@"Cancel"];
    [cancelButton addTarget:self action:@selector(editVCCancel:) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem * editLeftItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
	self.profileEditViewController.navigationItem.leftBarButtonItem = editLeftItem;	
	[editLeftItem release];
	
	
    UIButton * saveButton = [UIButton blueSocializeNavBarButtonWithTitle:@"Save"];
	[saveButton addTarget:self action:@selector(editVCSave:) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem  * editRightItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
	self.profileEditViewController.navigationItem.rightBarButtonItem = editRightItem;	
	[editRightItem release];
    
	UIImage * socializeNavBarBackground = [UIImage imageNamed:@"socialize-navbar-bg.png"];
	UINavigationController * navController = [[UINavigationController alloc] 
											  initWithRootViewController:self.profileEditViewController];
	
	[navController.navigationBar setBackgroundImage:socializeNavBarBackground];
	navController.delegate = self;
	navController.wantsFullScreenLayout = YES;
	
	CGRect windowFrame = self.view.window.frame;
	CGRect navFrame = CGRectMake(0,windowFrame.size.height, windowFrame.size.width, windowFrame.size.height);
	navController.view.frame = navFrame;
	navController.navigationBar.tintColor = [UIColor blackColor];
	
	[self.view.window addSubview:navController.view];
	
	
	CGRect newNavFrame = CGRectMake(0, 0, navFrame.size.width, navFrame.size.height);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(prepare)];
	[UIView setAnimationDuration:0.4];
	navController.view.frame = newNavFrame;
	[UIView commitAnimations];
}


-(void)hideEditController
{
    [self.loadingView removeView];
	self.loadingView = nil;
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
    
	UIImage* newProfileImage = self.profileEditViewController.profileImage;
	if (newProfileImage)
	{
		self.profileImageView.image = newProfileImage;
	}
	else 
	{
		self.profileImageView.image = [UIImage imageNamed:@"socialize_resources/socialize-profileimage-large-default.png"];
	}
    
//	NSString* firstName = [self.profileEditViewController.keyValueDictionary valueForKey:@"first name"];
//	NSString* lastName = [self.profileEditViewController.keyValueDictionary valueForKey:@"last name"];
//	NSString* description = [self.profileEditViewController.keyValueDictionary valueForKey:@"bio"];
    
    /*
	[self.theService postToProfileFirstName:firstName
								   lastName:lastName 
								description:description 
									  image:newProfileImage];
	*/
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


@end
