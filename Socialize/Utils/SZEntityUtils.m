//
//  SZEntityUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/3/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZEntityUtils.h"
#import "_Socialize.h"
#import "SDKHelpers.h"
#import "socialize_globals.h"

static SocializeEntityLoaderBlock _sharedEntityLoaderBlock;
static SocializeCanLoadEntityBlock _sharedCanLoadEntityBlock;

@implementation SZEntityUtils

+ (void)getEntitiesWithKeys:(NSArray*)keys success:(void(^)(NSArray *entities))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getEntityWithKey:(id)keys success:^(NSArray *entities) {
            BLOCK_CALL_1(success, entities);
        } failure:failure];
        
    }, failure);
}

+ (void)getEntityWithKey:(NSString*)key success:(void(^)(id<SZEntity> entity))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getEntityWithKey:key success:^(NSArray *entities) {
            BLOCK_CALL_1(success, [entities objectAtIndex:0]);
        } failure:failure];
    }, failure);
}

+ (void)getEntitiesWithIds:(NSArray*)entityIds success:(void(^)(NSArray *entity))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getEntitiesWithIds:entityIds success:success failure:failure];
    }, failure);
}

+ (void)getEntitiesWithSorting:(SZResultSorting)sorting first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *entity))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getEntitiesWithSorting:sorting first:first last:last success:success failure:failure];
    }, failure);
}

+ (void)getEntitiesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *entity))success failure:(void(^)(NSError *error))failure {
    [self getEntitiesWithSorting:SZResultSortingDefault first:first last:last success:success failure:failure];
}

+ (void)addEntity:(id<SZEntity>)entity success:(void(^)(id<SZEntity> entity))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] createEntities:[NSArray arrayWithObject:entity] success:^(NSArray *entities) {
            BLOCK_CALL_1(success, [entities lastObject]);
        } failure:failure];
    }, failure);
}

+ (void)setCanLoadEntityBlock:(SocializeCanLoadEntityBlock)canLoadEntityBlock {
    _sharedCanLoadEntityBlock = [canLoadEntityBlock copy];
}

+ (SocializeCanLoadEntityBlock)canLoadEntityBlock {
    return _sharedCanLoadEntityBlock;
}

+ (void)setEntityLoaderBlock:(SocializeEntityLoaderBlock)entityLoaderBlock {
    _sharedEntityLoaderBlock = [entityLoaderBlock copy];
}

+ (SocializeEntityLoaderBlock)entityLoaderBlock {
    return _sharedEntityLoaderBlock;
}

+ (BOOL)canLoadEntity:(id<SZEntity>)entity {
    BOOL haveEntityLoader = [self entityLoaderBlock] != nil;
    BOOL entityLoadRejected = [self canLoadEntityBlock] != nil && ![self canLoadEntityBlock](entity);
    BOOL canLoadEntity = haveEntityLoader && !entityLoadRejected;
    
    return canLoadEntity;
}

+ (void)fetchEntityAndShowEntityLoaderForEntityWithKey:(NSString*)entityKey success:(void(^)(id<SZEntity> entity))success failure:(void(^)(NSError *error))failure {
    [SZEntityUtils getEntityWithKey:entityKey
                            success:^(id<SocializeEntity> entity) {
                                if ([self showEntityLoaderForEntity:entity]) {
                                    BLOCK_CALL_1(success, entity);                                    
                                } else {
                                    BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorEntityLoadRejected]);
                                }
                            } failure:failure];
}

+ (BOOL)showEntityLoaderForEntity:(id<SZEntity>)entity {
    if (entity == nil) return NO;
    
    return [self showEntityLoaderForNavigationController:nil entity:entity];
}

+ (BOOL)showEntityLoaderForNavigationController:(UINavigationController*)navigationController entity:(id<SZEntity>)entity {
    if (![self canLoadEntity:entity]) {
        return NO;
    }
    
    BLOCK_CALL_2([self entityLoaderBlock], navigationController, entity);
    return YES;
}

@end