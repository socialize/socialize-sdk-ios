//
//  ProfileViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/26/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeUser.h"

@protocol ProfileViewControllerDelegate;

@interface SocializeProfileViewController : UIViewController
@property (nonatomic, retain) UIBarButtonItem *doneButton;
@property (nonatomic, retain) UIBarButtonItem *editButton;
@property (nonatomic, assign) id<ProfileViewControllerDelegate> delegate;
@property (nonatomic, retain) id<SocializeUser> user;
@property (nonatomic, retain) IBOutlet UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UILabel *userNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *userDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *userLocationLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *profileImageActivityIndicator;
@end

@protocol ProfileViewControllerDelegate
- (void)profileViewControllerDidCancel:(SocializeProfileViewController*)profileViewController;
- (void)profileViewControllerDidSave:(SocializeProfileViewController*)profileViewController;
@end