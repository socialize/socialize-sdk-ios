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
    SocializeAuthViewControllerSectionAuthTypes,
    SocializeAuthViewControllerSectionAuthInfo,
    SocializeAuthViewControllerNumSections
} SocializeAuthViewControllerSection;

typedef enum {
    SocializeAuthViewControllerRowFacebook,
    SocializeAuthViewControllerRowTwitter,
    SocializeAuthViewControllerNumRows
} SocializeAuthViewControllerRows;

@protocol SocializeAuthViewControllerDelegate;

@interface SocializeAuthViewController : SocializeBaseViewController<_SZUserSettingsViewControllerDelegate> {
    UITableView                 *tableView;
    NSString                    *_facebookUsername;
    UIButton                    *skipButton;
    //for unit test
    BOOL boolErrorStatus;
}

@property (nonatomic, retain) IBOutlet UITableView     *tableView;
@property (nonatomic, retain) IBOutlet UIButton        *skipButton;
@property (nonatomic, copy) void (^completionBlock)(SZSocialNetwork selectedNetwork);

- (id)initWithDelegate:(id<SocializeAuthViewControllerDelegate>)delegate;
+(UINavigationController*)authViewControllerInNavigationController:(id<SocializeAuthViewControllerDelegate>)delegate;
@end

@protocol SocializeAuthViewControllerDelegate<SocializeBaseViewControllerDelegate>
@optional
-(IBAction)skipButtonPressed:(id)sender;
-(void)authorizationSkipped;
-(void)socializeAuthViewController:(SocializeAuthViewController *)authViewController didAuthenticate:(id<SocializeUser>)user;
@end
