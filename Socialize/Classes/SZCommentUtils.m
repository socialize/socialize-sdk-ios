//
//  SZCommentUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/19/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZCommentUtils.h"
#import "_Socialize.h"
#import "SDKHelpers.h"

@implementation SZCommentUtils

+ (void)addCommentWithEntity:(id<SZEntity>)entity text:(NSString*)text shareOptions:(SZShareOptions*)shareOptions success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    SZComment *comment = [SZComment commentWithEntity:entity text:text];
    
    ActivityCreatorBlock creator = ^(id<SZComment> comment, void(^createSuccess)(id), void(^createFailure)(NSError*)) {
        [[Socialize sharedSocialize] createComments:[NSArray arrayWithObject:comment] success:createSuccess failure:createFailure];
    };

    CreateAndShareActivity(comment, shareOptions, creator, success, failure);
}

+ (void)getCommentWithId:(NSNumber*)commentId success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getCommentsWithIds:[NSArray arrayWithObject:commentId] success:success failure:failure];
}

+ (void)getCommentsWithIds:(NSArray*)commentIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getCommentsWithIds:commentIds success:success failure:failure];
}

+ (void)getCommentsByEntityWithEntityKey:(NSString*)entityKey success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getCommentsWithEntityKey:entityKey success:success failure:failure];
}

+ (void)getCommentsByUserWithUser:(id<SZUser>)user first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getCommentsForUser:user entity:nil first:first last:last success:success failure:failure];
}

+ (void)getCommentsByUserAndEntityWithUser:(id<SZUser>)user entity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getCommentsForUser:user entity:nil first:first last:last success:success failure:failure];
}

@end
