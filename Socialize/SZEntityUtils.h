//
//  SZEntityUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/3/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeCommonDefinitions.h"

@interface SZEntityUtils : NSObject

+ (void)getEntitiesWithKeys:(NSArray*)keys success:(void(^)(NSArray *entities))success failure:(void(^)(NSError *error))failure;
+ (void)getEntitiesWithIds:(NSArray*)entityIds success:(void(^)(NSArray *entity))success failure:(void(^)(NSError *error))failure;
+ (void)getEntitiesWithSorting:(SZResultSorting)sorting first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *entity))success failure:(void(^)(NSError *error))failure;
+ (void)getEntitiesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *entity))success failure:(void(^)(NSError *error))failure;
+ (void)getEntityWithKey:(NSString*)key success:(void(^)(id<SZEntity> entity))success failure:(void(^)(NSError *error))failure;
+ (void)addEntity:(id<SZEntity>)entity success:(void(^)(id<SZEntity> entity))success failure:(void(^)(NSError *error))failure;

+ (void)setEntityLoaderBlock:(SocializeEntityLoaderBlock)entityLoaderBlock;
+ (SocializeEntityLoaderBlock)entityLoaderBlock;
+ (void)setCanLoadEntityBlock:(SocializeCanLoadEntityBlock)canLoadEntityBlock;
+ (SocializeCanLoadEntityBlock)canLoadEntityBlock;

+ (BOOL)canLoadEntity:(id<SZEntity>)entity;

+ (void)fetchEntityAndShowEntityLoaderForEntityWithKey:(NSString*)entityKey success:(void(^)(id<SZEntity> entity))success failure:(void(^)(NSError *error))failure;

+ (BOOL)showEntityLoaderForEntity:(id<SZEntity>)entity;
+ (BOOL)showEntityLoaderForNavigationController:(UINavigationController*)navigationController entity:(id<SZEntity>)entity;

@end