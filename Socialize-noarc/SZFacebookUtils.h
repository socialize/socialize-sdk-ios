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
#import "SZDisplay.h"

@interface SZFacebookUtils : NSObject <SZSocialNetworkUtils>

+ (void)setAppId:(NSString*)appId expirationDate:(NSDate*)expirationDate;
+ (NSString*)accessToken;
+ (NSDate*)expirationDate;
+ (void)setURLSchemeSuffix:(NSString*)suffix;
+ (BOOL)isAvailable;
+ (BOOL)isLinked;

+ (void)linkWithAccessToken:(NSString*)accessToken expirationDate:(NSDate*)expirationDate success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;
+ (void)linkWithDisplay:(id<SZDisplay>)display success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;
+ (void)unlink;

+ (void)postWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure;
+ (void)getWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure;
+ (void)deleteWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure;


+ (void)_linkWithDisplay:(id<SZDisplay>)display success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;

@end
