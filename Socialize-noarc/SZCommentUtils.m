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
#import "_SZComposeCommentViewController.h"
#import "SZCommentOptions.h"
#import "SZShareUtils.h"
#import "SZUserUtils.h"
#import "SZDisplay.h"
#import <BlocksKit/BlocksKit.h>
#import "SZComposeCommentViewController.h"

@implementation SZCommentUtils

+ (SZCommentOptions*)userCommentOptions {
    SZCommentOptions *options = (SZCommentOptions*)SZActivityOptionsFromUserDefaults([SZCommentOptions class]);
    return options;
}

+ (void)showCommentsListWithDisplay:(id<SZDisplay>)display entity:(id<SZEntity>)entity completion:(void(^)())completion {
    SZDisplayWrapper *wrapper = [SZDisplayWrapper displayWrapperWithDisplay:display];

    SZCommentsListViewController *commentsList = [SZCommentsListViewController commentsListViewControllerWithEntity:entity];
    commentsList.completionBlock = ^{
        [wrapper endSequence];
        BLOCK_CALL(completion);
    };
    
    [wrapper beginSequenceWithViewController:commentsList]; 
}

// Compose and share (but no initial link)
+ (void)showCommentComposerWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity completion:(void(^)(id<SZComment> comment))completion cancellation:(void(^)())cancellation {
    SZComposeCommentViewController *composer = [[SZComposeCommentViewController alloc] initWithEntity:entity];
    composer.completionBlock = ^(id<SZComment> comment) {
        [viewController dismissModalViewControllerAnimated:YES];
    };
    composer.cancellationBlock = ^{
        BLOCK_CALL(cancellation);
        [viewController dismissModalViewControllerAnimated:YES];
    };
    
    [viewController presentModalViewController:composer animated:YES];
}

+ (void)addCommentWithEntity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options networks:(SZSocialNetwork)networks success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    SZComment *comment = [SZComment commentWithEntity:entity text:text];

    [comment setSubscribe:![options dontSubscribeToNotifications]];
    
    ActivityCreatorBlock commentCreator = ^(id<SZShare> share, void(^createSuccess)(id), void(^createFailure)(NSError*)) {

        SZAuthWrapper(^{
            [[Socialize sharedSocialize] createComment:comment success:createSuccess failure:createFailure];
        }, failure);

    };
    
    CreateAndShareActivity(comment, options, networks, commentCreator, success, failure);
}

+ (void)addCommentWithDisplay:(id<SZDisplay>)display entity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
//    SZDisplayWrapper *wrapper = [SZDisplayWrapper displayWrapperWithDisplay:display];
//
//    __block void (^addCommentBlock)() = [^(SZSocialNetwork networks) {
//        
//        [wrapper startLoadingInTopControllerWithMessage:@"Creating Comment"];
//        
//        [self addCommentWithEntity:entity text:text options:options networks:networks success:^(id<SZComment> comment) {
//
//            // Comment has been added
//            
//            [wrapper stopLoadingInTopController];
//
//            [addCommentBlock autorelease];
//
//            BLOCK_CALL_1(success, comment);
//        } failure:^(NSError *error) {
//            
//            // Comment add failure -- show an alert and possibly loop (recursively call addCommentBlock)
//
//            [wrapper stopLoadingInTopController];
//
//            NSString *message = [NSString stringWithFormat:@"Error code %d", [error code]];
//            UIAlertView *alertView = [UIAlertView alertWithTitle:@"Comment Create Failed" message:message];
//            
//            // Cancel button -- fail
//            [alertView addButtonWithTitle:@"Cancel" handler:^{
//                
//                [addCommentBlock autorelease];
//                [wrapper endSequence];
//                BLOCK_CALL_1(failure, error);
//            }];
//            
//            // Retry button -- recursively call addCommentBlock
//            [alertView addButtonWithTitle:@"Retry" handler:addCommentBlock];
//            
//            [wrapper showAlertView:alertView];
//            
//        }];
//        
//    } copy]; // `addCommentBlock` refers to the heap version of this block for the recursive alert retry call
//    
//    LinkWrapper(wrapper, ^(BOOL didPrompt, SZSocialNetwork selectedNetwork) {
//        if (AvailableSocialNetworks() == SZSocialNetworkNone || (didPrompt && selectedNetwork == SZSocialNetworkNone)) {
//            
//            // No networks are linked, so the user must have opted out of linking. Skip the selection dialog
//            addCommentBlock(SZSocialNetworkNone);
//            
//        } else {
//
//            // Networks are available, so get the user's post preference (may show network selection dialog)
//            [SZShareUtils getPreferredShareNetworksWithDisplay:wrapper success:addCommentBlock failure:^(NSError *error) {
//                [wrapper endSequence];
//                BLOCK_CALL_1(failure, error);
//            }];
//        }
//    }, ^(NSError *error) {
//        [wrapper endSequence];
//        BLOCK_CALL_1(failure, error);
//    });
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

+ (void)getCommentsByEntityWithEntityKey:(NSString*)entityKey success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getCommentsWithEntityKey:entityKey success:success failure:failure];
    }, failure);
}

+ (void)getCommentsByUserWithUser:(id<SZUser>)user first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getCommentsForUser:user entity:nil first:first last:last success:success failure:failure];
    }, failure);
}

+ (void)getCommentsByUserAndEntityWithUser:(id<SZUser>)user entity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getCommentsForUser:user entity:nil first:first last:last success:success failure:failure];
    }, failure);
}

@end
