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

@protocol SocializeAuthViewDelegate<NSObject>
@optional
-(void)authorizationSkipped;
-(void)didAuthenticate:(id<SocializeUser>)user;
@end

@interface SocializeAuthViewController : SocializeBaseViewController<SocializeProfileViewControllerDelegate> {
    UITableView                 *tableView;
    NSString                    *_facebookUsername;
    //for unit test
    BOOL boolErrorStatus;
}

@property (nonatomic, retain) IBOutlet UITableView     *tableView;
- (id)initWithDelegate:(id<SocializeAuthViewDelegate>)delegate;
+(UINavigationController*)createNavigationControllerForAuthViewControllerWithDelegate:(id<SocializeAuthViewDelegate>)delegate;
@end
