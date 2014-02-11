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
#import <BlocksKit/BlocksKit+UIKit.h>
#import <BlocksKit/BlocksKit+MessageUI.h>
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
#import "UIDevice+VersionCheck.h"
#import <Loopy/Loopy.h>

@implementation SZShareUtils

+ (id)sharedLoopyAPIClient {
    static STAPIClient *loopyAPIClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loopyAPIClient = [[STAPIClient alloc] initWithAPIKey:[Socialize consumerKey]
                                                    loopyKey:[Socialize consumerSecret]];
        [loopyAPIClient getSessionWithReferrer:@"www.facebook.com" //this is temporary until referred clarified
                                   postSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       }];
    });
    return loopyAPIClient;
}

+ (void)reportShareToLoopyWithText:(NSString *)shareText
                           channel:(NSString *)channel
                           success:(id)success
                           failure:(id)failure {
    //cast callbacks until .h import failure issue fixed
    void(^successCallback)(AFHTTPRequestOperation *operation, id responseObject) = (void(^)(AFHTTPRequestOperation *, id))success;
    void(^failureCallback)(AFHTTPRequestOperation *operation, NSError *error) = (void(^)(AFHTTPRequestOperation *, NSError *))failure;
    
    STAPIClient *loopyAPIClient = (STAPIClient *)[SZShareUtils sharedLoopyAPIClient];
    NSDictionary *shareDict = [loopyAPIClient reportShareDictionary:shareText channel:channel];
    [loopyAPIClient reportShare:shareDict
                        success:successCallback
                        failure:failureCallback];
}

+ (SZShareOptions*)userShareOptions {
    SZShareOptions *options = (SZShareOptions*)SZActivityOptionsFromUserDefaults([SZShareOptions class]);
    return options;
}

+ (void)showShareDialogWithViewController:(UIViewController*)viewController
                                   entity:(id<SZEntity>)entity
                               completion:(void(^)(NSArray *shares))completion {
    SZShareDialogViewController *shareDialog = [[SZShareDialogViewController alloc] initWithEntity:entity];

    WEAK(viewController) weakViewController = viewController;
    WEAK(shareDialog) weakShareDialog = shareDialog;

    shareDialog.completionBlock = ^(NSArray *shares) {
        [weakViewController SZDismissViewControllerAnimated:YES completion:^{
            SZSocialNetwork selectedNetworks = weakShareDialog._shareDialogViewController.selectedNetworks;
            SZShareOptions *options = weakShareDialog.shareOptions;
            BOOL useLoopy = options != nil && options.loopyEnabled;
            if(useLoopy) {
                [SZShareUtils reportShareToLoopyWithText:options.text
                                                 channel:[SZShareUtils getNetworksForLoopy:selectedNetworks]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 }
                                                 failure:nil];
            }
            BLOCK_CALL_1(completion, shares);
        }];
    };
    
    // Backward compatibility
    shareDialog.cancellationBlock = ^{
        [weakViewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL_1(completion, [NSArray array]);
        }];
    };
    
    [viewController presentViewController:shareDialog animated:YES completion:nil];
}

+ (void)showShareDialogWithViewController:(UIViewController*)viewController
                                   entity:(id<SZEntity>)entity
                               completion:(void(^)(NSArray *shares))completion
                             cancellation:(void(^)())cancellation {
    [self showShareDialogWithViewController:viewController options:nil entity:entity completion:completion cancellation:cancellation];
}

+ (void)showShareDialogWithViewController:(UIViewController*)viewController
                                  options:(SZShareOptions*)options
                                   entity:(id<SZEntity>)entity
                               completion:(void(^)(NSArray *shares))completion
                             cancellation:(void(^)())cancellation {
    
    SZShareDialogViewController *shareDialog = [[SZShareDialogViewController alloc] initWithEntity:entity];
    WEAK(viewController) weakViewController = viewController;
//    WEAK(shareDialog) weakShareDialog = shareDialog;
    
    shareDialog.completionBlock = ^(NSArray *shares) {
        [weakViewController SZDismissViewControllerAnimated:YES completion:^{
            //This is handled in shareViaSocialNetworksWithEntity
//            SZSocialNetwork selectedNetworks = weakShareDialog._shareDialogViewController.selectedNetworks;
//            BOOL useLoopy = options != nil && options.loopyEnabled;
//            if(useLoopy) {
//                [SZShareUtils reportShareToLoopyWithText:options.text
//                                                 channel:[SZShareUtils getNetworksForLoopy:selectedNetworks]
//                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                                 }
//                                                 failure:nil];
//            }
            BLOCK_CALL_1(completion, shares);
        }];
    };
    
    shareDialog.cancellationBlock = ^{
        [weakViewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL(cancellation);
        }];
     };
    
    shareDialog.display = viewController;
    shareDialog._shareDialogViewController.shareOptions = options;

    [viewController presentViewController:shareDialog animated:YES completion:nil];
}

+ (void)shareViaSocialNetworksWithEntity:(id<SZEntity>)entity
                                networks:(SZSocialNetwork)networks
                                 options:(SZShareOptions*)options
                                 success:(void(^)(id<SZShare> share))success
                                 failure:(void(^)(NSError *error))failure {
    SocializeShareMedium medium = SocializeShareMediumForSZSocialNetworks(networks);
    SZShare *share = [SZShare shareWithEntity:entity text:options.text medium:medium];
    ActivityCreatorBlock shareCreator = ^(id<SZShare> share, void(^createSuccess)(id), void(^createFailure)(NSError*)) {
        SZAuthWrapper(^{
            [[Socialize sharedSocialize] createShare:share
                                             success:createSuccess
                                             failure:createFailure];
        }, failure);
    };

    //successful shares now report to Loopy SDK also if so configured
    void (^shareSuccess)(id<SZShare> share) = ^(id<SZShare> share) {
        success(share);
        BOOL useLoopy = options != nil && options.loopyEnabled;
        if(useLoopy) {
            [SZShareUtils reportShareToLoopyWithText:options.text
                                             channel:[SZShareUtils getNetworksForLoopy:networks]
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             }
                                             failure:nil];
        }
    };
    SZCreateAndShareActivity(share, SZDefaultLinkPostData(), options, networks, shareCreator, shareSuccess, failure);
}

//for now, simply text-ify networks being shared
+ (NSString *)getNetworksForLoopy:(SZSocialNetwork)networks {
    NSString *channel = @"";
    switch (networks) {
        case SZSocialNetworkTwitter:
            channel = @"twitter";
            break;
            
        case SZSocialNetworkFacebook:
            channel = @"facebook";
            break;
            
        case (SZSocialNetworkTwitter + SZSocialNetworkFacebook):
            channel = @"facebook,twitter";
            break;
            
        default:
            break;
    }
    
    return channel;
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
    [self shareViaEmailWithViewController:viewController options:nil entity:entity success:success failure:failure];
}

+ (void)shareViaEmailWithViewController:(UIViewController*)viewController options:(SZShareOptions*)options entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    
    if (![self canShareViaEmail]) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorEmailNotAvailable]);
        return;
    }
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    composer.modalPresentationStyle = UIModalPresentationFormSheet;
    
    if([[UIDevice currentDevice] systemMajorVersion] >= 7) {
        [composer.navigationBar setTintColor:[UIColor whiteColor]];
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                   nil];
        [composer.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    }
    
    __block id<SZShare> createdShare = nil;
    
    composer.bk_completionBlock = ^(MFMailComposeViewController *controller, MFMailComposeResult result, NSError *error) {
        switch (result) {
            case MFMailComposeResultSent: {
                BLOCK_CALL_1(success, createdShare);
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
        //as of 2.0.0 BlocksKit, controllers do NOT dismiss themselves
        [controller dismissViewControllerAnimated:YES completion:nil];
    };

    [viewController showSocializeLoadingViewInSubview:nil];
    SZShare *share = [SZShare shareWithEntity:entity text:nil medium:SocializeShareMediumEmail];
    [share setPropagationInfoRequest:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"email"] forKey:@"third_parties"]];
    
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] createShare:share success:^(id<SZShare> serverShare) {
            createdShare = serverShare;
            SZEmailShareData *emailData = [[SZEmailShareData alloc] init];
            emailData.share = serverShare;
            emailData.propagationInfo = [[serverShare propagationInfoResponse] objectForKey:@"email"];
            emailData.messageBody = [self defaultMessageForShare:serverShare];
            emailData.subject = [[serverShare entity] displayName];
            BLOCK_CALL_1(options.willShowEmailComposerBlock, emailData);
            
            [viewController hideSocializeLoadingView];
            [composer setSubject:emailData.subject];
            [composer setMessageBody:emailData.messageBody isHTML:emailData.isHTML];
            
            [viewController presentViewController:composer animated:YES completion:nil];
        } failure:^(NSError *error) {
            [viewController hideSocializeLoadingView];
            BLOCK_CALL_1(failure, error);
        }];
        
    }, ^(NSError *error) {
        BLOCK_CALL_1(failure, error);
    });
}

+ (void)shareViaSMSWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    [self shareViaSMSWithViewController:viewController options:nil entity:entity success:success failure:failure];
}

+ (void)shareViaSMSWithViewController:(UIViewController*)viewController options:(SZShareOptions*)options entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    
    if (![self canShareViaSMS]) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorSMSNotAvailable]);
        return;
    }
    
    MFMessageComposeViewController *composer = [[MFMessageComposeViewController alloc] init];
    
    if([[UIDevice currentDevice] systemMajorVersion] >= 7) {
        [composer.navigationBar setTintColor:[UIColor whiteColor]];
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                   nil];
        [composer.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    }

    __block id<SZShare> createdShare = nil;
    
    composer.bk_completionBlock = ^(MFMessageComposeViewController *controller, MessageComposeResult result) {
        switch (result) {
            case MessageComposeResultSent: {
                BLOCK_CALL_1(success, createdShare);
                break;
            }
            case MessageComposeResultFailed:
                BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorSMSSendFailure]);
                break;
            case MessageComposeResultCancelled:
                BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorShareCancelledByUser]);
                break;
        }
        //as of 2.0.0 BlocksKit, controllers do NOT dismiss themselves
        [controller dismissViewControllerAnimated:YES completion:nil];
    };
    
    [viewController showSocializeLoadingViewInSubview:nil];
    SZShare *share = [SZShare shareWithEntity:entity text:nil medium:SocializeShareMediumSMS];
    [share setPropagationInfoRequest:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"sms"] forKey:@"third_parties"]];
    
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] createShare:share success:^(id<SZShare> serverShare) {
            createdShare = serverShare;
            SZSMSShareData *shareData = [[SZSMSShareData alloc] init];
            shareData.share = serverShare;
            shareData.propagationInfo = [[serverShare propagationInfoResponse] objectForKey:@"sms"];
            shareData.body = [self defaultMessageForShare:serverShare];
            BLOCK_CALL_1(options.willShowSMSComposerBlock, shareData);
            
            [viewController hideSocializeLoadingView];
            [composer setBody:shareData.body];
            [viewController presentViewController:composer animated:YES completion:nil];
        } failure:^(NSError *error) {
            [viewController hideSocializeLoadingView];
            BLOCK_CALL_1(failure, error);
        }];

    }, ^(NSError *error) {
        BLOCK_CALL_1(failure, error);
    });
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

+ (void)getSharesByApplicationWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getSharesWithFirst:first last:last success:success failure:failure];
    }, failure);
}
@end
