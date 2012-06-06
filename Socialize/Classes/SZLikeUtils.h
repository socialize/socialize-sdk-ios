//
//  SZLikeUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/3/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_Socialize.h"
#import "SZDisplay.h"
#import "SZLikeOptions.h"

@interface SZLikeUtils : NSObject
+ (SZLikeOptions*)userLikeOptions;
+ (void)likeWithDisplay:(id<SZDisplay>)display entity:(id<SZEntity>)entity success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure;
+ (void)likeWithEntity:(id<SZEntity>)entity options:(SZLikeOptions*)options networks:(SZSocialNetwork)networks success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure;

+ (void)unlike:(id<SZEntity>)entity success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure;

@end
