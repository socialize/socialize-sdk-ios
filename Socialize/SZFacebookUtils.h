//
//  SZFacebookUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"
#import "SZFacebookLinkOptions.h"

@interface SZFacebookUtils : NSObject

+ (NSArray*)requiredPermissions;
+ (void)setAccessToken:(NSString*)accessToken expirationDate:(NSDate*)expirationDate;
+ (void)setAppId:(NSString*)appId;
+ (NSString*)accessToken;
+ (NSDate*)expirationDate;
+ (NSString*)urlSchemeSuffix;
+ (void)setURLSchemeSuffix:(NSString*)suffix;
+ (BOOL)isAvailable;
+ (BOOL)isLinked;

+ (void)linkWithAccessToken:(NSString*)accessToken expirationDate:(NSDate*)expirationDate success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;
+ (void)linkWithOptions:(SZFacebookLinkOptions*)options success:(void(^)(id<SZFullUser>))success foreground:(void(^)())foreground failure:(void(^)(NSError *error))failure;
+ (void)unlink;
+ (void)cancelLink;

+ (void)postWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure;
+ (void)getWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure;
+ (void)deleteWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure;

@end
