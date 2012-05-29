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
#import "SZDisplay.h"
#import "UIAlertView+BlocksKit.h"

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

+ (void)showCommentComposerWithDisplay:(id<SZDisplay>)display entity:(id<SZEntity>)entity success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    SZStackDisplay *stackDisplay = [SZStackDisplay stackDisplayForDisplay:display];
    LinkWrapper(stackDisplay, ^{
        SZComposeCommentMessageViewController *composer = [[[SZComposeCommentMessageViewController alloc] initWithEntity:entity] autorelease];
        composer.completionBlock = ^(NSString *text, SZCommentOptions *options) {

            // Add comment
            [self addCommentWithDisplay:stackDisplay entity:entity text:text options:options success:^(id<SZComment> comment) {
                [display socializeWillEndDisplaySequence];
                BLOCK_CALL_1(success, comment);
            } failure:^(NSError *error) {
                [display socializeWillEndDisplaySequence];
                BLOCK_CALL_1(failure, error);
            }];
            
        };
        composer.cancellationBlock = ^{
            [display socializeWillEndDisplaySequence];
            BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorCommentCancelledByUser]);
        };
        [stackDisplay beginWithOrTransitionToViewController:composer];
    }, ^(NSError *error) {
        [display socializeWillEndDisplaySequence];
        BLOCK_CALL_1(failure, error);
    });
}

+ (void)addCommentWithEntity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options networks:(SZSocialNetwork)networks success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    SZComment *comment = [SZComment commentWithEntity:entity text:text];

    [comment setSubscribe:![options dontSubscribeToNotifications]];
    
    ActivityCreatorBlock commentCreator = ^(id<SZShare> share, void(^createSuccess)(id), void(^createFailure)(NSError*)) {
        [[Socialize sharedSocialize] createComments:[NSArray arrayWithObject:comment] success:createSuccess failure:createFailure];
    };
    
    CreateAndShareActivity(comment, options, networks, commentCreator, success, failure);
}

+ (void)addCommentWithDisplay:(id<SZDisplay>)display entity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    SZStackDisplay *stackDisplay = [SZStackDisplay stackDisplayForDisplay:display];
    
    __block void (^addCommentBlock)() = [^(SZSocialNetwork networks) {
        [stackDisplay socializeWillStartLoadingWithMessage:@"Creating Comment"];
        [self addCommentWithEntity:entity text:text options:options networks:networks success:^(id<SZComment> comment) {
            
            // Comment created successfully
            [addCommentBlock autorelease];
            
            [stackDisplay socializeWillStopLoading];
            BLOCK_CALL_1(success, comment);
        } failure:^(NSError *error) {

            // Comment create failed -- show an alert

            [stackDisplay socializeWillStopLoading];
            NSString *message = [NSString stringWithFormat:@"Error code %d", [error code]];
            UIAlertView *alertView = [UIAlertView alertWithTitle:@"Comment Create Failed" message:message];
            [alertView addButtonWithTitle:@"Cancel" handler:^{
                
                // User cancelled out of loop -- fail
                [addCommentBlock autorelease];
                [display socializeWillEndDisplaySequence];
                BLOCK_CALL_1(failure, error);
            }];
            
            [alertView addButtonWithTitle:@"Retry" handler:addCommentBlock];
            [stackDisplay socializeWillShowAlertView:alertView];
        }];
        
    } copy]; // `addCommentBlock` refers to the heap version of this block for the recursive alert retry call
    
    if (LinkedSocialNetworks() == SZSocialNetworkNone) {
        addCommentBlock(SZSocialNetworkNone);
    } else {
        [SZShareUtils getPreferredShareNetworksWithDisplay:display success:addCommentBlock failure:^(NSError *error) {
            if ([error isSocializeErrorWithCode:SocializeErrorProcessCancelledByUser]) {
                [stackDisplay pop];
            } else {
                [display socializeWillEndDisplaySequence];
                BLOCK_CALL_1(failure, error);
            }
        }];
    }
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
