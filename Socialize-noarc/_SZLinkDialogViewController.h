//
//  AuthorizeViewController.h
//  appbuildr
//
//  Created by Fawad Haider  on 5/17/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeBaseViewController.h"
#import "_SZUserSettingsViewController.h"
#import "SocializeUser.h"

@class SocializeTwitterAuthDataStore;

typedef enum {
    _SZLinkDialogViewControllerSectionAuthTypes,
    _SZLinkDialogViewControllerSectionAuthInfo,
    _SZLinkDialogViewControllerNumSections
} _SZLinkDialogViewControllerSection;

typedef enum {
    _SZLinkDialogViewControllerRowFacebook,
    _SZLinkDialogViewControllerRowTwitter,
    _SZLinkDialogViewControllerNumRows
} _SZLinkDialogViewControllerRows;

@protocol _SZLinkDialogViewControllerDelegate;

@interface _SZLinkDialogViewController : SocializeBaseViewController<_SZUserSettingsViewControllerDelegate> {
    UIImageView                 *topImage;
    UITableView                 *tableView;
    NSString                    *_facebookUsername;
    UIButton                    *skipButton;
    //for unit test
    BOOL boolErrorStatus;
}

@property (nonatomic, retain) IBOutlet UIImageView     *topImage;
@property (nonatomic, retain) IBOutlet UITableView     *tableView;
@property (nonatomic, retain) IBOutlet UIButton        *skipButton;
@property (nonatomic, copy) void (^completionBlock)(SZSocialNetwork selectedNetwork);

- (id)initWithDelegate:(id<_SZLinkDialogViewControllerDelegate>)delegate;
+ (UINavigationController*)authViewControllerInNavigationController:(id<_SZLinkDialogViewControllerDelegate>)delegate;
- (UIImage *)facebookIcon:(BOOL)enabled;
- (UIImage *)twitterIcon:(BOOL)enabled;
- (UIImage *)callOutArrow;
- (UIImage *)authorizeUserIcon;

@end

@protocol _SZLinkDialogViewControllerDelegate<SocializeBaseViewControllerDelegate>
@optional
- (IBAction)skipButtonPressed:(id)sender;
- (void)authorizationSkipped;
- (void)socializeAuthViewController:(_SZLinkDialogViewController *)authViewController didAuthenticate:(id<SocializeUser>)user;
@end
