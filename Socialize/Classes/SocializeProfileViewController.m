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

@implementation SocializeProfileViewController
@synthesize delegate = delegate_;
@synthesize doneButton = doneButton_;
@synthesize editButton = editButton_;
@synthesize user = user_;
@synthesize userNameLabel = userNameLabel_;
@synthesize userDescriptionLabel = userDescriptionLabel_;
@synthesize userLocationLabel = userLocationLabel_;
@synthesize profileImage = profileImage_;
@synthesize profileImageActivityIndicator = profileImageActivityIndicator_;

- (void)dealloc {
    self.doneButton = nil;
    self.editButton = nil;
    self.user = nil;
    self.userNameLabel = nil;
    self.userDescriptionLabel = nil;
    self.userLocationLabel = nil;
    self.profileImage = nil;
    
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
    [self.delegate profileViewControllerDidSave:self];
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

    self.profileImage.image = [self defaultProfileImage];

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
                self.profileImage.image = existing;
            } else {
                CompleteBlock complete = [[^(ImagesCache* imgs){
                    UIImage *loadedImage = [imgs imageFromCache:url];
                    if (loadedImage != nil) {
                        self.profileImage.image = loadedImage;
                    } else {
                        self.profileImage.image = [self defaultProfileImage];
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
    self.profileImage = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
