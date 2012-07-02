//
//  SZSmartAlertUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZSmartAlertUtils : NSObject

+ (BOOL)isAvailable;
+ (BOOL)handleNotification:(NSDictionary*)userInfo;
+ (BOOL)isSocializeNotification:(NSDictionary*)userInfo;
+ (void)registerDeviceToken:(NSData*)deviceToken;

@end