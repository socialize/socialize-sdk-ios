//
//  AuthorizeViewController.h
//  appbuildr
//
//  Created by Fawad Haider  on 5/17/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeAuthTableViewCell.h"
#import "SocializeAuthInfoTableViewCell.h"
#import "SocializeBaseViewController.h"
#import "SocializeProfileViewController.h"
#import "SocializeUser.h"


typedef enum {
    SocializeAuthViewControllerSectionAuthTypes,
    SocializeAuthViewControllerSectionAuthInfo,
    SocializeAuthViewControllerNumSections
} SocializeAuthViewControllerSection;

typedef enum {
    SocializeAuthViewControllerRowFacebook,
    SocializeAuthViewControllerRowTwitter
} SocializeAuthViewControllerRows;

@protocol SocializeAuthViewDelegate;

@interface SocializeAuthViewController : SocializeBaseViewController<SocializeProfileViewControllerDelegate> {
    UITableView                 *tableView;
    NSString                    *_facebookUsername;
    //for unit test
    BOOL boolErrorStatus;
}

@property (nonatomic, retain) IBOutlet UITableView     *tableView;
- (id)initWithDelegate:(id<SocializeAuthViewDelegate>)delegate;
+(UINavigationController*)authViewControllerInNavigationController:(id<SocializeAuthViewDelegate>)delegate;
@end

@protocol SocializeAuthViewDelegate<NSObject>
@optional
-(void)authorizationSkipped;
-(void)socializeAuthViewController:(SocializeAuthViewController *)authViewController didAuthenticate:(id<SocializeUser>)user;
@end
