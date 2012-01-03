//
//  SocializeNotificationHandler.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/29/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_Socialize.h"

@class SocializeActivityDetailsViewController;

@interface SocializeNotificationHandler : NSObject <SocializeServiceDelegate>

+ (BOOL)isSocializeNotification:(NSDictionary*)userInfo;
+ (SocializeNotificationHandler*)sharedNotificationHandler;
- (BOOL)handleSocializeNotification:(NSDictionary*)userInfo;

@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) SocializeActivityDetailsViewController *activityDetailsViewController;
@property (nonatomic, retain) UIWindow *displayWindow;

@end
