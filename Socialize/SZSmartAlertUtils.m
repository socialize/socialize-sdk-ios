//
//  SZSmartAlertUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZSmartAlertUtils.h"
#import "_Socialize.h"
#import "SDKHelpers.h"
#import "SZDisplay.h"
#import "SZWindowDisplay.h"
#import "SZNotificationHandler.h"

static SocializeNewCommentsNotificationBlock _sharedNewCommentsNotificationBlock;

@implementation SZSmartAlertUtils

+ (BOOL)isAvailable {
    BOOL available = [[Socialize sharedSocialize] notificationsAreConfigured];
    if (!available) {
        SZEmitUnconfiguredSmartAlertsMessage();
    }
    return available;
}

+ (BOOL)openNotification:(NSDictionary*)userInfo {
    return [[SZNotificationHandler sharedNotificationHandler] openSocializeNotification:userInfo];
}

+ (BOOL)handleNotification:(NSDictionary*)userInfo {
    return [[SZNotificationHandler sharedNotificationHandler] handleSocializeNotification:userInfo];
}

+ (BOOL)isSocializeNotification:(NSDictionary*)userInfo {
    return [SZNotificationHandler isSocializeNotification:userInfo];
}

+ (void)registerDeviceToken:(NSData*)deviceToken development:(BOOL)development {
    [Socialize registerDeviceToken:deviceToken development:development];
}

+ (void)registerDeviceToken:(NSData*)deviceToken {
    [self registerDeviceToken:deviceToken development:NO];
}

+ (void)setNewCommentsNotificationBlock:(SocializeNewCommentsNotificationBlock)newCommentsBlock {
    _sharedNewCommentsNotificationBlock = [newCommentsBlock copy];
}

+ (SocializeNewCommentsNotificationBlock)newCommentsNotificationBlock {
    return _sharedNewCommentsNotificationBlock;
}

@end
