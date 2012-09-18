//
//  SZNotificationHandler.h
//  Socialize
//
//  Created by Nathaniel Griswold on 8/30/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZDisplay.h"

@interface SZNotificationHandler : NSObject

+ (BOOL)isSocializeNotification:(NSDictionary*)userInfo;
+ (SZNotificationHandler*)sharedNotificationHandler;
- (BOOL)openSocializeNotification:(NSDictionary*)userInfo;
- (BOOL)handleSocializeNotification:(NSDictionary*)userInfo;

@property (nonatomic, copy) id<SZDisplay>(^displayBlock)();

@end
