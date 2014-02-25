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
#import "_SZCommentsListViewController.h"
#import "SZNavigationController.h"
#import "_SZComposeCommentViewController.h"
#import "SZCommentOptions.h"
#import "SZShareUtils.h"
#import "SZUserUtils.h"
#import "SZComposeCommentViewController.h"
#import "SZCommentsListViewController.h"
#import "socialize_globals.h"
#import "SDKHelpers.h"


@implementation SZCommentUtils

+ (SZCommentOptions*)userCommentOptions {
    SZCommentOptions *options = (SZCommentOptions*)SZActivityOptionsFromUserDefaults([SZCommentOptions class]);
    return options;
}

+ (void)showCommentsListWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity completion:(void(^)())completion {
    SZCommentsListViewController *commentsList = [[SZCommentsListViewController alloc] initWithEntity:entity];
    
    WEAK(viewController) weakViewController = viewController;

    commentsList.completionBlock = ^{
        [weakViewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL(completion);
        }];
    };
    
    [viewController presentViewController:commentsList animated:YES completion:nil];
}

// Compose and share (but no initial link)
+ (void)showCommentComposerWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity completion:(void(^)(id<SZComment> comment))completion cancellation:(void(^)())cancellation {
    
    WEAK(viewController) weakViewController = viewController;
    
    SZComposeCommentViewController *composer = [[SZComposeCommentViewController alloc] initWithEntity:entity];
    composer.completionBlock = ^(id<SZComment> comment) {
        [weakViewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL_1(completion, comment);
        }];
    };
    
    composer.cancellationBlock = ^{
        [weakViewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL(cancellation);
        }];
    };
    
    composer.display = viewController;
    
    [viewController presentViewController:composer animated:YES completion:nil];
}

+ (void)addCommentWithEntity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options networks:(SZSocialNetwork)networks success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    SZComment *comment = [SZComment commentWithEntity:entity text:text];

    [comment setSubscribe:![options dontSubscribeToNotifications]];
    
    ActivityCreatorBlock commentCreator = ^(id<SZShare> share, void(^createSuccess)(id), void(^createFailure)(NSError*)) {

        SZAuthWrapper(^{
            [[Socialize sharedSocialize] createComment:comment success:createSuccess failure:createFailure];
        }, failure);

    };
    
    SZCreateAndShareActivity(comment, SZDefaultLinkPostData(), options, networks, commentCreator, success, failure);
}

+ (void)addCommentWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    SZLinkAndGetPreferredNetworks(viewController, SZLinkContextComment, ^(SZSocialNetwork preferredNetworks) {
        
        // Determined users preferred networks, create the comment ...
        [self addCommentWithEntity:entity text:text options:options networks:preferredNetworks success:success failure:failure];
    }, ^{
        
        // Network selection cancelled ...
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorCommentCancelledByUser]);
    });
}

+ (void)getCommentWithId:(NSNumber*)commentId success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getCommentsWithIds:[NSArray arrayWithObject:commentId] success:^(NSArray *comments) {
            BLOCK_CALL_1(success, [comments objectAtIndex:0]);
        } failure:failure];
    }, failure);

}

+ (void)getCommentsWithIds:(NSArray*)commentIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getCommentsWithIds:commentIds success:success failure:failure];
    }, failure);
}

+ (void)getCommentsByEntity:(id<SZEntity>)entity success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getCommentsWithEntityKey:[entity key] success:success failure:failure];
    }, failure);
}

+ (void)getCommentsByUser:(id<SZUser>)user first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    if (user == nil) {
        user = (id<SZUser>)[SZUserUtils currentUser];
    }
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getCommentsForUser:user entity:nil first:first last:last success:success failure:failure];
    }, failure);
}

+ (void)getCommentsByUser:(id<SZUser>)user entity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    if (user == nil) {
        user = (id<SZUser>)[SZUserUtils currentUser];
    }

    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getCommentsForUser:user entity:nil first:first last:last success:success failure:failure];
    }, failure);
}

+ (void)getCommentsByApplicationWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getCommentsWithFirst:first last:last success:success failure:failure];
    }, failure);
}

@end
