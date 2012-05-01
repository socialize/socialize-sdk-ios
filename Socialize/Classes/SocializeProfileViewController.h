//
//  ProfileViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/26/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeFullUser.h"
#import "SZSettingsViewController.h"
#import "_Socialize.h"
#import "SocializeBaseViewController.h"
#import "SocializeActivityViewController.h"

@class ImagesCache;
@class SocializeLoadingView;
@class SocializeActivityViewController;

@interface SocializeProfileViewController : SocializeBaseViewController <UINavigationControllerDelegate, SZSettingsViewControllerDelegate, SocializeServiceDelegate, SocializeActivityViewControllerDelegate>
+ (SocializeProfileViewController*)profileViewController;
+ (UINavigationController*)profileViewControllerInNavigationController;
+ (UINavigationController*)socializeProfileViewControllerWithDelegate:(id<SocializeBaseViewControllerDelegate>)delegate __attribute__((deprecated));
+ (UINavigationController*)currentUserProfileWithDelegate:(id<SocializeBaseViewControllerDelegate>)delegate __attribute__((deprecated));
+ (UINavigationController*)socializeProfileViewControllerForUser:(id<SocializeUser>)user delegate:(id<SocializeBaseViewControllerDelegate>)delegate __attribute__((deprecated));
- (id)initWithUser:(id<SocializeUser>)user delegate:(id<SocializeBaseViewControllerDelegate>)delegate __attribute__((deprecated));
@property (nonatomic, retain) id<SocializeUser> user;
@property (nonatomic, retain) id<SocializeFullUser> fullUser;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *userNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *userDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *userLocationLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *profileImageActivityIndicator;
@property (nonatomic, retain) ImagesCache *imagesCache;
@property (nonatomic, retain) UIImage *defaultProfileImage;
@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, retain) SocializeActivityViewController *activityViewController;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityLoadingActivityIndicator;

- (void)setProfileImageFromURL:(NSString*)imageURL;
- (void)setProfileImageFromImage:(UIImage*)image;
- (IBAction)headerTapped:(id)sender;
@end

