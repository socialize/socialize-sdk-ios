//
//  SZLikeUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/3/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_Socialize.h"
#import "SZLikeOptions.h"

@interface SZLikeUtils : NSObject
+ (SZLikeOptions*)userLikeOptions;
+ (void)likeWithViewController:(UIViewController*)viewController options:(SZLikeOptions*)options entity:(id<SZEntity>)entity success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure;
+ (void)likeWithEntity:(id<SZEntity>)entity options:(SZLikeOptions*)options networks:(SZSocialNetwork)networks success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure;

+ (void)unlike:(id<SZEntity>)entity success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure;
+ (void)isLiked:(id<SZEntity>)entity success:(void(^)(BOOL isLiked))success failure:(void(^)(NSError *error))failure;
+ (void)getLike:(id<SZEntity>)entity success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure;
+ (void)getLikesForUser:(id<SZUser>)user start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *likes))success failure:(void(^)(NSError *error))failure;
+ (void)getLikesForEntity:(id<SZEntity>)entity start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *likes))success failure:(void(^)(NSError *error))failure;
+ (void)getLikeForUser:(id<SZUser>)user entity:(id<SZEntity>)entity success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure;
+ (void)getLikesByApplicationWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *likes))success failure:(void(^)(NSError *error))failure;

@end
