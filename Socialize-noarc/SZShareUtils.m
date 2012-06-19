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
#import "SZShareDialogViewController.h"
#import "SZFacebookUtils.h"
#import "SZTwitterUtils.h"
#import "SocializePrivateDefinitions.h"
#import "SDKHelpers.h"
#import "NSError+Socialize.h"
#import "SocializeThirdParty.h"

@implementation SZShareUtils

+ (SZShareOptions*)userShareOptions {
    SZShareOptions *options = (SZShareOptions*)SZActivityOptionsFromUserDefaults([SZShareOptions class]);
    return options;
}

+ (void)getPreferredShareNetworksWithDisplay:(id<SZDisplay>)display success:(void(^)(SZSocialNetwork networks))success failure:(void(^)(NSError *error))failure {
    BOOL autopostIsSet = [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeAutoPostToSocialNetworksKey] boolValue];
    
    if (autopostIsSet || AvailableSocialNetworks() == SZSocialNetworkNone) {
        
        // The user has autopost enabled, so we already know the answer
        SZSocialNetwork socialNetworks = [SocializeThirdParty preferredNetworks];
        BLOCK_CALL_1(success, socialNetworks);
    } else {
        
        // The user has not enable autopost, so we must prompt them
        SZShareDialogViewController *dialog = [[[SZShareDialogViewController alloc] initWithEntity:nil] autorelease];
        dialog.dontRequireNetworkSelection = YES;
        
        dialog.completionBlock = ^(SZSocialNetwork selectedNetworks) {
            [display socializeWillEndDisplaySequence];
            BLOCK_CALL_1(success, selectedNetworks);
        };
        dialog.cancellationBlock = ^{
            [display socializeWillEndDisplaySequence];
            BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorNetworkSelectionCancelledByUser]);
        };
        [display socializeWillBeginDisplaySequenceWithViewController:dialog];
    }
}

+ (void)showShareDialogWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    SZShareDialogViewController *selectNetwork = [[[SZShareDialogViewController alloc] initWithEntity:entity] autorelease];
    selectNetwork.disableAutopostSelection = YES;
    selectNetwork.showOtherShareTypes = YES;
    selectNetwork.completionBlock = ^(SZSocialNetwork networks) {
        [viewController dismissModalViewControllerAnimated:YES];
        
        SZShareOptions *shareOptions = [self userShareOptions];

        [self shareViaSocialNetworksWithEntity:entity networks:networks options:shareOptions success:success failure:failure];
    };
    selectNetwork.cancellationBlock = ^{
        [viewController dismissModalViewControllerAnimated:YES];        
    };
    
    SZNavigationController *nav = [[[SZNavigationController alloc] initWithRootViewController:selectNetwork] autorelease];
    [viewController presentModalViewController:nav animated:YES];
}

+ (void)shareViaSocialNetworksWithEntity:(id<SZEntity>)entity networks:(SZSocialNetwork)networks options:(SZShareOptions*)options success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    SocializeShareMedium medium = SocializeShareMediumForSZSocialNetworks(networks);
    SZShare *share = [SZShare shareWithEntity:entity text:options.text medium:medium];
    
    ActivityCreatorBlock shareCreator = ^(id<SZShare> share, void(^createSuccess)(id), void(^createFailure)(NSError*)) {
        SZAuthWrapper(^{
            [[Socialize sharedSocialize] createShare:share success:createSuccess failure:createFailure];
        }, failure);
    };
                                     
    CreateAndShareActivity(share, options, networks, shareCreator, success, failure);
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
                
                SZAuthWrapper(^{
                    SZShare *share = [SZShare shareWithEntity:entity text:@"" medium:SocializeShareMediumEmail];
                    [[Socialize sharedSocialize] createShare:share success:success failure:failure];
                }, failure);
                
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
                
                SZAuthWrapper(^{
                    SZShare *share = [SZShare shareWithEntity:entity text:@"" medium:SocializeShareMediumSMS];
                    [[Socialize sharedSocialize] createShare:share success:success failure:failure];
                }, failure);

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
