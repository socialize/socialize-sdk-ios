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

@interface ProfileViewController : UIViewController
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, assign) id<ProfileViewControllerDelegate> delegate;
@property (nonatomic, retain) id<SocializeUser> user;
@property (nonatomic, retain) IBOutlet UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@end

@protocol ProfileViewControllerDelegate
- (void)profileViewControllerDidCancel:(ProfileViewController*)profileViewController;
- (void)profileViewControllerDidSave:(ProfileViewController*)profileViewController;
@end