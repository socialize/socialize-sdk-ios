//
//  SZShareUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "SZShareUtils.h"
#import <BlocksKit/BlocksKit.h>
#import "Socialize.h"
#import "SocializeObjects.h"
#import "SZBaseShareViewController.h"
#import "SZFacebookUtils.h"
#import "SZTwitterUtils.h"
#import "SocializePrivateDefinitions.h"
#import "SDKHelpers.h"
#import "NSError+Socialize.h"
#import "SocializeThirdParty.h"
#import "SZSelectNetworkViewController.h"
#import "SZShareDialogViewController.h"
#import "SZUserUtils.h"
#import "SocializeLoadingView.h"
#import "socialize_globals.h"

@implementation SZShareUtils

+ (SZShareOptions*)userShareOptions {
    SZShareOptions *options = (SZShareOptions*)SZActivityOptionsFromUserDefaults([SZShareOptions class]);
    return options;
}

+ (void)showShareDialogWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity completion:(void(^)(NSArray *shares))completion {
    SZShareDialogViewController *shareDialog = [[SZShareDialogViewController alloc] initWithEntity:entity];
    shareDialog.completionBlock = ^(NSArray *shares) {
        [viewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL_1(completion, shares);
        }];
    };
    [viewController presentModalViewController:shareDialog animated:YES];
}

+ (void)showShareDialogWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity completion:(void(^)(NSArray *shares))completion cancellation:(void(^)())cancellation {
    
    SZShareDialogViewController *shareDialog = [[SZShareDialogViewController alloc] initWithEntity:entity];
    shareDialog.completionBlock = ^(NSArray *shares) {
        [viewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL_1(completion, shares);
        }];
    };
    
    shareDialog.cancellationBlock = ^{
        [viewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL(cancellation);
        }];
     };
    [viewController presentModalViewController:shareDialog animated:YES];
}


+ (void)shareViaSocialNetworksWithEntity:(id<SZEntity>)entity networks:(SZSocialNetwork)networks options:(SZShareOptions*)options success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    SocializeShareMedium medium = SocializeShareMediumForSZSocialNetworks(networks);
    
    NSString *text = options.text;
    if ([text length] == 0) {
        text = DEFAULT_TWITTER_SHARE_MSG;
    }
    
    SZShare *share = [SZShare shareWithEntity:entity text:text medium:medium];
    
    ActivityCreatorBlock shareCreator = ^(id<SZShare> share, void(^createSuccess)(id), void(^createFailure)(NSError*)) {
        SZAuthWrapper(^{
            [[Socialize sharedSocialize] createShare:share success:createSuccess failure:createFailure];
        }, failure);
    };
                                     
    SZCreateAndShareActivity(share, options, networks, shareCreator, success, failure);
}

+ (NSString*)defaultMessageForShare:(id<SZShare>)share {
    NSDictionary *info = [[[share propagationInfoResponse] allValues] lastObject];
    NSString *entityURL = [info objectForKey:@"entity_url"];
    NSString *applicationURL = [info objectForKey:@"application_url"];

    id<SocializeEntity> e = share.entity;
    
    NSMutableString *msg = [NSMutableString stringWithString:@"I thought you would find this interesting: "];
    
    if ([e.name length] > 0) {
        [msg appendFormat:@"%@ ", e.name];
    }
    
    NSString *applicationName = [share.application name];
    
    [msg appendFormat:@"%@\n\nSent from %@ (%@)", entityURL, applicationName, applicationURL];
    
    return msg;    
}

+ (void)shareViaEmailWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    
    if (![self canShareViaEmail]) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorEmailNotAvailable]);
        return;
    }
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    composer.sz_completionBlock = ^(MFMailComposeResult result, NSError *error) {
        switch (result) {
            case MFMailComposeResultSent: {
                
                SZAuthWrapper(^{
                    SZShare *share = [SZShare shareWithEntity:entity text:@"" medium:SocializeShareMediumEmail];
                    [[Socialize sharedSocialize] createShare:share success:^(id<SZShare> createdShare) {
                        BLOCK_CALL_1(success, createdShare);
                    } failure:^(NSError *error) {
                        BLOCK_CALL_1(failure, error);
                    }];
                }, ^(NSError *error) {
                    BLOCK_CALL_1(failure, error);
                });
                
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
    
    // Note that composers dismiss themselves

    [viewController showSocializeLoadingViewInSubview:nil];
    SZShare *share = [SZShare shareWithEntity:entity text:nil medium:SocializeShareMediumSMS];
    [share setPropagationInfoRequest:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"email"] forKey:@"third_parties"]];
    [[Socialize sharedSocialize] createShare:share success:^(id<SZShare> serverShare) {
        [viewController hideSocializeLoadingView];
        [composer setSubject:@"123"];
        [composer setMessageBody:[self defaultMessageForShare:serverShare] isHTML:NO];
        [viewController presentModalViewController:composer animated:YES];
    } failure:^(NSError *error) {
        [viewController hideSocializeLoadingView];
    }];
     
    
}

+ (void)shareViaSMSWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    
    if (![self canShareViaSMS]) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorSMSNotAvailable]);
        return;
    }
    
    MFMessageComposeViewController *composer = [[MFMessageComposeViewController alloc] init];
    composer.sz_completionBlock = ^(MessageComposeResult result) {
        switch (result) {
            case MessageComposeResultSent: {
                
                SZAuthWrapper(^{
                    SZShare *share = [SZShare shareWithEntity:entity text:@"" medium:SocializeShareMediumSMS];
                    [[Socialize sharedSocialize] createShare:share success:^(id<SZShare> createdShare) {
                        BLOCK_CALL_1(success, createdShare);
                    } failure:^(NSError *error) {
                        BLOCK_CALL_1(failure, error);
                    }];
                }, ^(NSError *error) {
                    BLOCK_CALL_1(failure, error);
                });

                break;
            }
            case MessageComposeResultFailed:
                BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorSMSSendFailure]);
                break;
            case MessageComposeResultCancelled:
                BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorShareCancelledByUser]);
                break;
        }
    };
    
    // Note that composers dismiss themselves
    
    [viewController showSocializeLoadingViewInSubview:nil];
    SZShare *share = [SZShare shareWithEntity:entity text:nil medium:SocializeShareMediumSMS];
    [share setPropagationInfoRequest:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"sms"] forKey:@"third_parties"]];
    [[Socialize sharedSocialize] createShare:share success:^(id<SZShare> serverShare) {
        [viewController hideSocializeLoadingView];
        [composer setBody:[self defaultMessageForShare:serverShare]];
        [viewController presentModalViewController:composer animated:YES];
    } failure:^(NSError *error) {
        [viewController hideSocializeLoadingView];
    }];
}


+ (BOOL)canShareViaEmail {
    return [MFMailComposeViewController canSendMail];
}

+ (BOOL)canShareViaSMS {
    return [MFMessageComposeViewController canSendText];
}

+ (void)getShareWithId:(NSNumber*)shareId success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getShareWithId:shareId success:success failure:failure];
    }, failure);
}

+ (void)getSharesWithIds:(NSArray*)shareIds success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getSharesWithIds:shareIds success:success failure:failure];
    }, failure);
}

+ (void)getSharesWithEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getSharesForEntityKey:[entity key] first:first last:last success:success failure:failure];
    }, failure);
}

+ (void)getSharesWithUser:(id<SZUser>)user first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    if (user == nil) {
        user = (id<SZUser>)[SZUserUtils currentUser];
    }
    
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getSharesForUser:user entity:nil first:first last:last success:success failure:failure];
    }, failure);
}

+ (void)getSharesWithUser:(id<SZUser>)user entity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getSharesForUser:user entity:entity first:first last:last success:success failure:failure];
    }, failure);
}

@end
