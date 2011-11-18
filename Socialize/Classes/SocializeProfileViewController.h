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

@class ImagesCache;
@class SocializeLoadingView;
@protocol SocializeProfileViewControllerDelegate;

@interface SocializeProfileViewController : SocializeBaseViewController <UINavigationControllerDelegate, SocializeProfileEditViewControllerDelegate, SocializeServiceDelegate>
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
@property (nonatomic, retain) SocializeLoadingView *loadingView;
@property (nonatomic, retain) UINavigationController *navigationControllerForEdit;
@property (nonatomic, retain) ImagesCache *imagesCache;
@property (nonatomic, retain) UIImage *defaultProfileImage;
@property (nonatomic, retain) UIAlertView *alertView;
- (void)doneButtonPressed:(UIBarButtonItem*)button;
- (void)editButtonPressed:(UIBarButtonItem*)button;
- (void)setProfileImageFromURL:(NSString*)imageURL;
- (void)setProfileImageFromImage:(UIImage*)image;
@end

@protocol SocializeProfileViewControllerDelegate
- (void)profileViewControllerDidCancel:(SocializeProfileViewController*)profileViewController;
- (void)profileViewControllerDidSave:(SocializeProfileViewController*)profileViewController;
@end
