//
//  SZFacebookUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"
#import "SZSocialNetworkUtils.h"

@interface SZFacebookUtils : NSObject <SZSocialNetworkUtils>

+ (void)setAppId:(NSString*)appId expirationDate:(NSDate*)expirationDate;
+ (NSString*)accessToken;
+ (NSDate*)expirationDate;
+ (void)setURLSchemeSuffix:(NSString*)suffix;
+ (BOOL)isAvailable;
+ (BOOL)isLinked;

+ (void)linkWithAccessToken:(NSString*)accessToken expirationDate:(NSDate*)expirationDate success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;
+ (void)linkWithViewController:(UIViewController*)viewController success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;
+ (void)unlink;

@end
