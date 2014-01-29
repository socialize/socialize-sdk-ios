//
//  ProfileViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/26/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeFullUser.h"
#import "_SZUserSettingsViewController.h"
#import "_Socialize.h"
#import "SocializeBaseViewController.h"
#import "SocializeActivityViewController.h"

@class ImagesCache;
@class SocializeLoadingView;
@class SocializeActivityViewController;

@interface _SZUserProfileViewController : SocializeBaseViewController <UINavigationControllerDelegate, _SZUserSettingsViewControllerDelegate, SocializeServiceDelegate, SocializeActivityViewControllerDelegate>
+ (_SZUserProfileViewController*)profileViewController;
+ (UINavigationController*)profileViewControllerInNavigationController;
+ (UINavigationController*)socializeProfileViewControllerWithDelegate:(id<SocializeBaseViewControllerDelegate>)delegate;
+ (UINavigationController*)currentUserProfileWithDelegate:(id<SocializeBaseViewControllerDelegate>)delegate;
+ (UINavigationController*)socializeProfileViewControllerForUser:(id<SocializeUser>)user delegate:(id<SocializeBaseViewControllerDelegate>)delegate;
- (id)initWithUser:(id<SocializeUser>)user delegate:(id<SocializeBaseViewControllerDelegate>)delegate;
@property (nonatomic, retain) id<SocializeUser> user;
@property (nonatomic, retain) id<SocializeFullUser> fullUser;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageBackgroundView;
@property (nonatomic, retain) IBOutlet UIImageView *sectionHeaderView;
@property (nonatomic, retain) IBOutlet UILabel *userNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *userDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *userLocationLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *profileImageActivityIndicator;
@property (nonatomic, retain) ImagesCache *imagesCache;
@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, retain) SocializeActivityViewController *activityViewController;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityLoadingActivityIndicator;
@property (nonatomic, copy) void (^completionBlock)(id<SZFullUser> user);

- (void)setProfileImageFromURL:(NSString*)imageURL;
- (void)setProfileImageFromImage:(UIImage*)image;
- (UIImage *)defaultBackgroundImage;
- (UIImage *)defaultHeaderBackgroundImage;
- (UIImage *)defaultProfileImage;
- (UIImage *)defaultProfileBackgroundImage;
- (IBAction)headerTapped:(id)sender;
@end

