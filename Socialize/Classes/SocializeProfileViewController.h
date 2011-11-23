//
//  ProfileViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/26/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeFullUser.h"
#import "SocializeProfileEditViewController.h"
#import "_Socialize.h"
#import "SocializeBaseViewController.h"
#import "SocializeActivityViewController.h"

@class ImagesCache;
@class SocializeLoadingView;
@class SocializeActivityViewController;
@protocol SocializeProfileViewControllerDelegate;

@interface SocializeProfileViewController : SocializeBaseViewController <UINavigationControllerDelegate, SocializeProfileEditViewControllerDelegate, SocializeServiceDelegate, SocializeActivityViewControllerDelegate>
+ (UINavigationController*)socializeProfileViewControllerWithDelegate:(id<SocializeProfileViewControllerDelegate>)delegate;
+ (UINavigationController*)currentUserProfileWithDelegate:(id<SocializeProfileViewControllerDelegate>)delegate;
+ (UINavigationController*)socializeProfileViewControllerForUser:(id<SocializeUser>)user delegate:(id<SocializeProfileViewControllerDelegate>)delegate;
- (id)initWithUser:(id<SocializeUser>)user delegate:(id<SocializeProfileViewControllerDelegate>)delegate;
@property (nonatomic, assign) id<SocializeProfileViewControllerDelegate> delegate;
@property (nonatomic, retain) id<SocializeUser> user;
@property (nonatomic, retain) id<SocializeFullUser> fullUser;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *userNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *userDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *userLocationLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *profileImageActivityIndicator;
@property (nonatomic, retain) SocializeProfileEditViewController *profileEditViewController;
@property (nonatomic, retain) UINavigationController *navigationControllerForEdit;
@property (nonatomic, retain) ImagesCache *imagesCache;
@property (nonatomic, retain) UIImage *defaultProfileImage;
@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, retain) SocializeActivityViewController *activityViewController;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityLoadingActivityIndicator;

- (void)doneButtonPressed:(UIBarButtonItem*)button;
- (void)editButtonPressed:(UIBarButtonItem*)button;
- (void)setProfileImageFromURL:(NSString*)imageURL;
- (void)setProfileImageFromImage:(UIImage*)image;
- (IBAction)headerTapped:(id)sender;
@end

@protocol SocializeProfileViewControllerDelegate <NSObject>
@optional
- (void)profileViewControllerDidFinish:(SocializeProfileViewController*)profileViewController;
- (void)profileViewController:(SocializeProfileViewController*)profileViewController wantsViewActivity:(id<SocializeActivity>)activity;
@end
