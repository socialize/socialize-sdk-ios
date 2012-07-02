//
//  SZActionUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZActionUtils.h"
#import "_Socialize.h"
#import "SDKHelpers.h"
#import "SZUserUtils.h"

@implementation SZActionUtils

+ (void)getActionsByApplicationWithStart:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *actions))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getActivityOfApplicationWithFirst:start last:end success:success failure:failure];
    }, failure);
}

+ (void)getActionsByUser:(id<SZUser>)user start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *actions))success failure:(void(^)(NSError *error))failure {
    if (user == nil) {
        user = (id<SZUser>)[SZUserUtils currentUser];
    }

    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getActivityForUser:user entity:nil first:start last:end success:success failure:failure];
    }, failure);
}

+ (void)getActionsByEntity:(id<SZEntity>)entity start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *actions))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getActivityOfEntity:entity first:start last:end success:success failure:failure];
    }, failure);
}

+ (void)getActionsByUser:(id<SZUser>)user entity:(id<SZEntity>)entity start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *actions))success failure:(void(^)(NSError *error))failure {
    if (user == nil) {
        user = (id<SZUser>)[SZUserUtils currentUser];
    }

    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getActivityForUser:user entity:entity first:start last:end success:success failure:failure];
    }, failure);
}

@end
