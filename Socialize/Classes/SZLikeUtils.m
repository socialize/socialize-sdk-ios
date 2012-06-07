//
//  SZLikeUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/3/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZLikeUtils.h"
#import "SZUserUtils.h"
#import "SZEntityUtils.h"
#import "SDKHelpers.h"
#import "SocializeObjects.h"
#import "SZShareUtils.h"

@implementation SZLikeUtils

+ (SZLikeOptions*)userLikeOptions {
    SZLikeOptions *options = (SZLikeOptions*)SZActivityOptionsFromUserDefaults([SZLikeOptions class]);
    return options;
}

+ (void)likeWithDisplay:(id<SZDisplay>)display entity:(id<SZEntity>)entity success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure {
    SZDisplayWrapper *wrapper = [SZDisplayWrapper displayWrapperWithDisplay:display];
    
    LinkWrapper(wrapper, ^(BOOL didPrompt, SZSocialNetwork selectedNetwork) {
        if (AvailableSocialNetworks() == SZSocialNetworkNone || (didPrompt && selectedNetwork == SZSocialNetworkNone)) {
            
            [wrapper startLoadingInTopControllerWithMessage:@"Creating Like"];
            [self likeWithEntity:entity options:nil networks:SZSocialNetworkNone success:^(id<SZLike> like) {
                [wrapper stopLoadingInTopController];
                [wrapper endSequence];
                BLOCK_CALL_1(success, like);
            } failure:^(NSError *error) {
                [wrapper stopLoadingInTopController];
                [wrapper endSequence];
                BLOCK_CALL_1(failure, error);
            }];
            
        } else {
            
            // Networks are available, so get the user's post preference (may show network selection dialog)
            [SZShareUtils getPreferredShareNetworksWithDisplay:wrapper success:^(SZSocialNetwork networks) {
                [wrapper startLoadingInTopControllerWithMessage:@"Creating Like"];
                
                [self likeWithEntity:entity options:nil networks:networks success:^(id<SZLike> like) {
                    [wrapper stopLoadingInTopController];
                    [wrapper endSequence];
                    BLOCK_CALL_1(success, like);
                } failure:^(NSError *error) {
                    [wrapper stopLoadingInTopController];
                    [wrapper endSequence];
                    BLOCK_CALL_1(failure, error);                    
                }];

            } failure:^(NSError *error) {
                [wrapper endSequence];
                BLOCK_CALL_1(failure, error);
            }];
        }
        
    }, ^(NSError *error) {
        [wrapper endSequence];
        BLOCK_CALL_1(failure, error);
    });

}

+ (void)likeWithEntity:(id<SZEntity>)entity options:(SZLikeOptions*)options networks:(SZSocialNetwork)networks success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure {
    SZLike *like = [SZLike likeWithEntity:entity];
    ActivityCreatorBlock likeCreator = ^(id<SZActivity> activity, void(^createSuccess)(id), void(^createFailure)(NSError*)) {
        
        SZAuthWrapper(^{
            [[Socialize sharedSocialize] createLikes:[NSArray arrayWithObject:activity] success:createSuccess failure:createFailure];
        }, failure);

    };

    CreateAndShareActivity(like, options, networks, likeCreator, success, failure);
}

+ (void)unlike:(id<SZEntity>)entity success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure {
    id<SZFullUser> user = [SZUserUtils currentUser];
    
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] deleteLikeForUser:user entity:entity success:success failure:failure];
    }, failure);
}

+ (void)getLikeStatusForEntity:(id<SZEntity>)entity success:(void(^)(BOOL isLiked))success failure:(void(^)(NSError *error))failure {
    [SZEntityUtils getEntityWithKey:[entity key] success:^(id<SocializeEntity> entity) {
        BOOL isLiked = [[[entity userActionSummary] objectForKey:@"likes"] integerValue] > 0;
        BLOCK_CALL_1(success, isLiked);
    } failure:failure];
}

+ (void)getLike:(id<SZEntity>)entity success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure {
    id<SZFullUser> user = [SZUserUtils currentUser];
    
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getLikesForUser:(id<SZUser>)user entity:entity first:nil last:nil success:^(NSArray *likes) {
            BLOCK_CALL_1(success, [likes objectAtIndex:0]);
        } failure:failure];
    }, failure);
}

+ (void)getLikesForUser:(id<SZFullUser>)user start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *likes))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getLikesForUser:(id<SZUser>)user entity:nil first:start last:end success:success failure:failure];
    }, failure);
}

+ (void)getLikesForEntity:(id<SZEntity>)entity start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *likes))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getLikesForEntity:entity first:start last:end success:success failure:failure];
    }, failure);
}

+ (void)getLikesForUser:(id<SZFullUser>)user entity:(id<SZEntity>)entity start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *likes))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getLikesForUser:(id<SZUser>)user entity:entity first:start last:end success:success failure:failure];
    }, failure);
}

@end
