//
//  SZViewUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/5/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZViewUtils.h"
#import "_Socialize.h"

@implementation SZViewUtils

- (void)viewEntity:(id<SZEntity>)entity success:(void(^)(id<SZView> view))success failure:(void(^)(NSError *error))failure {
    id<SZView> view = [SZView viewWithEntity:entity];
    [[Socialize sharedSocialize] createView:view success:success failure:failure];
}

- (void)getView:(id<SZEntity>)entity success:(void(^)(id<SZView> view))success failure:(void(^)(NSError *error))failure {
    id<SZUser> currentUser = [[Socialize sharedSocialize] authenticatedUser];
    [[Socialize sharedSocialize] getViewsForUser:currentUser entity:entity first:nil last:nil success:^(NSArray *views){
        BLOCK_CALL_1(success, [views objectAtIndex:0]);
    } failure:failure];
}

- (void)getViewsByUser:(id<SZUser>)user start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *views))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getViewsForUser:user entity:nil first:start last:end success:success failure:failure];
}

- (void)getViewsByUser:(id<SZUser>)user entity:(id<SZEntity>)entity start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *views))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getViewsForUser:user entity:entity first:start last:end success:success failure:failure];
}

@end