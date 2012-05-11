//
//  SZShareUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZShareUtils.h"
#import "MFMailComposeViewController+BlocksKit.h"
#import "MFMessageComposeViewController+BlocksKit.h"
#import "Socialize.h"
#import "SocializeObjects.h"
#import "SZShareDialogViewController.h"

@implementation SZShareUtils

+ (void)showShareDialogWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity {
    SZShareDialogViewController *selectNetwork = [[[SZShareDialogViewController alloc] init] autorelease];
    SZNavigationController *nav = [[[SZNavigationController alloc] initWithRootViewController:selectNetwork] autorelease];
    [viewController presentModalViewController:nav animated:YES];
}

+ (void)shareViaEmailWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    
    if (![self canShareViaEmail]) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorEmailNotAvailable]);
        return;
    }
    
    MFMailComposeViewController *composer = [[[MFMailComposeViewController alloc] init] autorelease];
    composer.sz_completionBlock = ^(MFMailComposeResult result, NSError *error) {
        [viewController dismissModalViewControllerAnimated:YES];
        switch (result) {
            case MFMailComposeResultSent: {
                SZShare *share = [SZShare shareWithEntity:entity text:@"" medium:SocializeShareMediumEmail];
                [[Socialize sharedSocialize] createShare:share success:success failure:failure];
                break;
            }
            case MFMailComposeResultFailed:
                BLOCK_CALL_1(failure, error);
                break;
            case MFMailComposeResultCancelled:
            case MFMailComposeResultSaved:
                BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorShareCancelledByUser]);
                break;
        }
    };
    
    [viewController presentModalViewController:composer animated:YES];
}

+ (void)shareViaSMSWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    
    if (![self canShareViaSMS]) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorSMSNotAvailable]);
        return;
    }
    
    MFMessageComposeViewController *composer = [[[MFMessageComposeViewController alloc] init] autorelease];
    composer.sz_completionBlock = ^(MessageComposeResult result) {
        [viewController dismissModalViewControllerAnimated:YES];
        switch (result) {
            case MessageComposeResultSent: {
                SZShare *share = [SZShare shareWithEntity:entity text:@"" medium:SocializeShareMediumSMS];
                [[Socialize sharedSocialize] createShare:share success:success failure:failure];
                break;
            }
            case MessageComposeResultFailed:
                BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorShareCreationFailed]);
                break;
            case MessageComposeResultCancelled:
                BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorShareCancelledByUser]);
                break;
        }
    };
    
    [viewController presentModalViewController:composer animated:YES];
}


+ (BOOL)canShareViaEmail {
    return [MFMailComposeViewController canSendMail];
}

+ (BOOL)canShareViaSMS {
    return [MFMessageComposeViewController canSendText];
}

+ (void)getShareWithId:(NSNumber*)shareId success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getShareWithId:shareId success:success failure:failure];
}

+ (void)getSharesWithIds:(NSArray*)shareIds success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getSharesWithIds:shareIds success:success failure:failure];
}

+ (void)getSharesWithEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getSharesForEntityKey:[entity key] first:first last:last success:success failure:failure];
}

+ (void)getSharesWithUser:(id<SZUser>)user first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getSharesForUser:user entity:nil first:first last:last success:success failure:failure];
}

+ (void)getSharesWithUser:(id<SZUser>)user entity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getSharesForUser:user entity:entity first:first last:last success:success failure:failure];
}

@end
