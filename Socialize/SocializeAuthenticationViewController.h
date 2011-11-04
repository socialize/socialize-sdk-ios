//
//  AuthorizeViewController.h
//  appbuildr
//
//  Created by Fawad Haider  on 5/17/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SocializeServiceDelegate.h"
#import "SocializeAuthTableViewCell.h"
#import "SocializeAuthInfoTableViewCell.h"
#import <Socialize/Socialize.h>

@protocol SocializeAuthorizeViewDelegate

-(void)authorizationCompleted:(BOOL)success;

@end

@interface SocializeAuthenticationViewController : SocializeBaseViewController {
    UITableView                 *tableView;
    id<SocializeAuthorizeViewDelegate>   delegate;
    NSString                    *_facebookUsername;
    //for unit test
    BOOL boolErrorStatus;
}

@property (nonatomic, retain) IBOutlet UITableView     *tableView;
+(UINavigationController*)createNavigationControllerForAuthViewController;
@end
