//
//  SocializeNotificationHandler.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/29/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_Socialize.h"
#import "SocializeActivityDetailsViewController.h"
#import "_SZCommentsListViewController.h"
#import "SocializeNewCommentsNotificationDisplayController.h"
#import "SocializeDirectURLNotificationDisplayController.h"

@interface SocializeNotificationHandler : NSObject <SocializeServiceDelegate, SocializeNotificationDisplayControllerDelegate>

+ (BOOL)isSocializeNotification:(NSDictionary*)userInfo;
+ (SocializeNotificationHandler*)sharedNotificationHandler;
- (BOOL)handleSocializeNotification:(NSDictionary*)userInfo;
- (BOOL)applicationInForeground;
- (BOOL)openSocializeNotification:(NSDictionary*)userInfo;

@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) UIWindow *displayWindow;
@property (nonatomic, retain) NSMutableArray *displayControllers;

@end
