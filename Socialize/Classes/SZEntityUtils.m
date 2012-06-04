//
//  SZEntityUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/3/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZEntityUtils.h"
#import "_Socialize.h"

@implementation SZEntityUtils

+ (void)getEntityWithKey:(NSString*)key success:(void(^)(id<SZEntity> entity))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getEntityWithKey:key success:^(NSArray *entities) {
        BLOCK_CALL_1(success, [entities objectAtIndex:0]);
    } failure:failure];
}

+ (void)getEntitiesWithIds:(NSArray*)entityIds success:(void(^)(NSArray *entity))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getEntitiesWithIds:entityIds success:success failure:failure];
}

+ (void)getEntitiesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *entity))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getEntitiesWithFirst:first last:last success:success failure:failure];
}

+ (void)addEntity:(id<SZEntity>)entity success:(void(^)(id<SZEntity> entity))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] createEntities:[NSArray arrayWithObject:entity] success:success failure:failure];
}

@end
