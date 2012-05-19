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
#import "SZFacebookUtils.h"
#import "SZTwitterUtils.h"
#import "SocializePrivateDefinitions.h"

@implementation SZShareUtils

+ (void)showShareDialogWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity {
    SZShareDialogViewController *selectNetwork = [[[SZShareDialogViewController alloc] initWithEntity:entity] autorelease];
//    selectNetwork.disableAutopostSelection = YES;
//    selectNetwork.showOtherShareTypes = YES;
    
    SZNavigationController *nav = [[[SZNavigationController alloc] initWithRootViewController:selectNetwork] autorelease];
    [viewController presentModalViewController:nav animated:YES];
}

+ (void)shareViaSocialNetworksWithEntity:(id<SZEntity>)entity text:(NSString*)text options:(SZShareOptions*)options success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    if (options.shareTo == SZSocialNetworkNone) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorShareCreationFailed]);
        return;
    }
    if (options.shareTo & SZSocialNetworkFacebook && (![SZFacebookUtils isAvailable] || ![SZFacebookUtils isLinked])) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorFacebookUnavailable]);
        return;
    }
    
    if (options.shareTo & SZSocialNetworkTwitter && (![SZTwitterUtils isAvailable] || ![SZTwitterUtils isLinked])) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorTwitterUnavailable]);
        return;
    }

    // Currently Must exlusively share to a Social Network for this to be the medium.
    SocializeShareMedium medium;
    if (options.shareTo == SZSocialNetworkFacebook) {
        medium = SocializeShareMediumFacebook;
    } else if (options.shareTo == SZSocialNetworkTwitter) {
        medium = SocializeShareMediumTwitter;
    } else {
        medium = SocializeShareMediumOther;
    }
    
    SZShare *share = [SZShare shareWithEntity:entity text:text medium:medium];

    if (options.shareTo & SZSocialNetworkFacebook) {
        share.propagationInfoRequest = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"facebook"] forKey:@"third_parties"];
    }
    
    if (options.shareTo & SZSocialNetworkTwitter) {
        share.propagation = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"twitter"] forKey:@"third_parties"];
    }
    
    [[Socialize sharedSocialize] createShare:share success:^(id<SZShare> share) {
        if (options.shareTo & SZSocialNetworkFacebook) {
            
            // This shortened link returned from the server encapsulates all the Socialize magic
            NSString *shareURL = [[[share propagationInfoResponse] objectForKey:@"facebook"] objectForKey:@"application_url"];

            NSString *name = share.application.name;
            NSString *link = shareURL;
            NSString *caption = [NSString stringWithSocializeAppDownloadPlug];
            
            NSString *message;
            if ([share.entity.name length] > 0) {
                message = [NSString stringWithFormat:@"%@: %@ \n\n %@\n\n Shared from %@.", share.entity.name, shareURL, text, share.application.name];
            } else {
                message = [NSString stringWithFormat:@"%@ \n\n %@\n\n Shared from %@.", shareURL, text, share.application.name];
            }

            NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:
                                    message, @"message",
                                    caption, @"caption",
                                    link, @"link",
                                    name, @"name",
                                      @"This is the description", @"description",
                                    nil];

            [SZFacebookUtils postWithGraphPath:@"me/links" postData:postData success:^(id result) {
                BLOCK_CALL_1(success, share);
            } failure:^(NSError *error) {
                
                // Failed Wall post is still a success. Handle separately in options.
                BLOCK_CALL_1(success, share);
            }];
        }
        
        BLOCK_CALL_1(success, share);
    } failure:failure];
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
