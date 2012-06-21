//
//  SocializeNewCommentsNotificationHandler.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeActivityDetailsViewController.h"
#import "_SZCommentsListViewController.h"
#import "SocializeNotificationDisplayController.h"
#import "SocializeActivityDetailsViewControllerDelegate.h"

@interface SocializeNewCommentsNotificationDisplayController : SocializeNotificationDisplayController <SocializeActivityDetailsViewControllerDelegate, _SZCommentsListViewControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) _SZCommentsListViewController *commentsTableViewController;
@property (nonatomic, retain) SocializeActivityDetailsViewController *activityDetailsViewController;
@end

