//
//  SZFacebookUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"

@interface SZFacebookUtils : NSObject

+ (void)setAppId:(NSString*)appId expirationDate:(NSDate*)expirationDate;
+ (NSString*)accessToken;
+ (NSDate*)expirationDate;
+ (void)setURLSchemeSuffix:(NSString*)suffix;
+ (BOOL)isAvailable;
+ (BOOL)isLinked;

+ (void)linkToFacebookWithAccessToken:(NSString*)accessToken expirationDate:(NSDate*)expirationDate success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;
+ (void)linkToFacebookWithViewController:(UIViewController*)viewController success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;
+ (void)unlink;

@end
