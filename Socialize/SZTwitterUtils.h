//
//  SZTwitterUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"

@interface SZTwitterUtils : NSObject

+ (void)setConsumerKey:(NSString*)accessToken consumerSecret:(NSString*)consumerSecret;
+ (NSString*)consumerKey;
+ (NSString*)consumerSecret;
+ (NSString*)accessToken;
+ (NSString*)accessTokenSecret;
+ (BOOL)isAvailable;
+ (BOOL)isLinked;
+ (void)unlink;
+ (void)linkWithAccessToken:(NSString*)accessToken accessTokenSecret:(NSString*)accessTokenSecret success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;
+ (void)linkWithViewController:(UIViewController*)viewController success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;
+ (void)getWithPath:(NSString*)path params:(NSDictionary*)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure;
+ (void)postWithPath:(NSString*)path params:(NSDictionary*)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure;
+ (NSString*)defaultTwitterTextForActivity:(id<SZActivity>)activity;

@end
