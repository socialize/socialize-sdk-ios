//
//  SZEntityUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/3/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_Socialize.h"

@interface SZEntityUtils : NSObject

+ (void)getEntitiesWithIds:(NSArray*)entityIds success:(void(^)(NSArray *entity))success failure:(void(^)(NSError *error))failure;
+ (void)getEntitiesWithSorting:(SZResultSorting)sorting first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *entity))success failure:(void(^)(NSError *error))failure;
+ (void)getEntitiesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *entity))success failure:(void(^)(NSError *error))failure;
+ (void)getEntityWithKey:(NSString*)key success:(void(^)(id<SZEntity> entity))success failure:(void(^)(NSError *error))failure;
+ (void)addEntity:(id<SZEntity>)entity success:(void(^)(id<SZEntity> entity))success failure:(void(^)(NSError *error))failure;

@end