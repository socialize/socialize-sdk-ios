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
#import "SZCommentsListViewController.h"
#import "SZNavigationController.h"
#import "SZComposeCommentMessageViewController.h"
#import "SZCommentOptions.h"
#import "SZShareUtils.h"
#import "SZUserUtils.h"

@implementation SZCommentUtils

+ (SZCommentOptions*)userCommentOptions {
    SZCommentOptions *options = (SZCommentOptions*)ActivityOptionsFromUserDefaults([SZCommentOptions class]);
    return options;
}

+ (void)showCommentsListWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity completion:(void(^)())completion {
    SZCommentsListViewController *commentsList = [SZCommentsListViewController commentsListViewControllerWithEntity:entity];
    commentsList.completionBlock = ^{
        [viewController dismissModalViewControllerAnimated:YES];
        BLOCK_CALL(completion);
    };
    
    SZNavigationController *nav = [[[SZNavigationController alloc] initWithRootViewController:commentsList] autorelease];
    [viewController presentModalViewController:nav animated:YES];
}

+ (void)showCommentComposerWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    SZComposeCommentViewController *composer = [SZComposeCommentViewController composeCommentViewControllerWithEntity:entity];
    composer.completionBlock = ^(id<SZComment> comment) {
        [viewController dismissModalViewControllerAnimated:YES];
        BLOCK_CALL_1(success, comment);
    };
    composer.cancellationBlock = ^{
        [viewController dismissModalViewControllerAnimated:YES];
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorCommentCancelledByUser]);
    };
    
    SZNavigationController *nav = [[[SZNavigationController alloc] initWithRootViewController:composer] autorelease];
    [viewController presentModalViewController:nav animated:YES];
}

+ (void)addCommentWithEntity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options networks:(SZSocialNetwork)networks success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    SZComment *comment = [SZComment commentWithEntity:entity text:text];

    [comment setSubscribe:![options dontSubscribeToNotifications]];
    
    ActivityCreatorBlock commentCreator = ^(id<SZShare> share, void(^createSuccess)(id), void(^createFailure)(NSError*)) {
        [[Socialize sharedSocialize] createComments:[NSArray arrayWithObject:comment] success:createSuccess failure:createFailure];
    };
    
    CreateAndShareActivity(comment, options, networks, commentCreator, success, failure);
}

+ (void)addCommentWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    [SZShareUtils getPreferredShareNetworksWithViewController:viewController success:^(SZSocialNetwork networks) {
        [self addCommentWithEntity:entity text:text options:options networks:networks success:success failure:failure];
    } failure:failure];
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
