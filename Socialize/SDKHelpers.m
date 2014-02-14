//
//  SDKHelpers.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/20/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SDKHelpers.h"
#import "SocializeObjects.h"
#import "SZShareOptions.h"
#import "SZFacebookUtils.h"
#import "SZTwitterUtils.h"
#import "SZCommentOptions.h"
#import "SocializeThirdParty.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeThirdPartyTwitter.h"
#import "Socialize.h"
#import <SZBlocksKit/BlocksKit.h>
#import <SZBlocksKit/BlocksKit+UIKit.h>
#import "SZUserUtils.h"
#import "_Socialize.h"
#import "SocializePrivateDefinitions.h"
#import "_SZSelectNetworkViewController.h"
#import "SZLinkDialogViewController.h"
#import "SZSelectNetworkViewController.h"
#import "SZLocationUtils.h"
#import "socialize_globals.h"

#define SHARE_COMMENT_COMPLETE_TEXT @"Post"
#define SHARE_COMMENT_TITLE @"Share Comment"
#define SHARE_LIKE_COMPLETE_TEXT @"Like"
#define SHARE_LIKE_TITLE @"Share Like"

SZSocialNetwork SZLinkedSocialNetworks() {
    SZSocialNetwork networks = SZSocialNetworkNone;
    
    if ([SZTwitterUtils isLinked]) {
        networks |= SZSocialNetworkTwitter;
    }
    
    if ([SZFacebookUtils isLinked]) {
        networks |= SZSocialNetworkFacebook;
    }
    
    return networks;
}

SZSocialNetwork SZAvailableSocialNetworks() {
    SZSocialNetwork networks = SZSocialNetworkNone;
    
    if ([SZTwitterUtils isAvailable]) {
        networks |= SZSocialNetworkTwitter;
    }
    
    if ([SZFacebookUtils isAvailable]) {
        networks |= SZSocialNetworkFacebook;
    }
    
    return networks;
}

SZSocialNetwork SZAutoPostNetworks() {
    SZSocialNetwork networks = SZSocialNetworkNone;
    
    for (Class<SocializeThirdParty> thirdParty in [SocializeThirdParty allThirdParties]) {
        if ([thirdParty shouldAutopost] && [thirdParty isLinkedToSocialize]) {
            networks |= [thirdParty socialNetworkFlag];
        }
    }
    
    return networks;
}

BOOL SZShouldShowNetworkSelection() {
    BOOL skipSelection = [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeAutoPostToSocialNetworksKey] boolValue];
    return !skipSelection;
}

BOOL SZShouldShowLinkDialog() {
    return ( SZLinkedSocialNetworks() == SZSocialNetworkNone && SZAvailableSocialNetworks() != SZSocialNetworkNone && ![Socialize authenticationNotRequired]);
}

void SZShowLinkToFacebookAlertView(void (^okBlock)(), void (^cancelBlock)()) {
    UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:@"Facebook Authentication Required" message:@"Link to Facebook?"];
    [alertView bk_addButtonWithTitle:@"Cancel" handler:cancelBlock];
    [alertView bk_addButtonWithTitle:@"OK" handler:^{
        
        // This is a hack for the cases that require a fallback to in-app modal fb login dialog. It does not
        // like being displayed immediately after dismissal of a UIAlertView.
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            BLOCK_CALL(okBlock);
        });
    }];

    [alertView show];
}

void SZLinkAndGetPreferredNetworks(UIViewController *viewController, SZLinkContext context, void (^completion)(SZSocialNetwork preferredNetworks), void (^cancellation)()) {
    
    // No Social Networks available
    if (SZAvailableSocialNetworks() == SZSocialNetworkNone) {
        BLOCK_CALL_1(completion, SZSocialNetworkNone);
        return;
    }
    
    if (SZShouldShowLinkDialog()) {
        
        // Link and possibly show network selection
        SZLinkDialogViewController *link = [[SZLinkDialogViewController alloc] init];
        __block __unsafe_unretained SZLinkDialogViewController *weakLink = link;
        __block __unsafe_unretained __typeof__(viewController) weakViewController = viewController;
        link.completionBlock = ^(SZSocialNetwork selectedNetwork) {
            
            if (selectedNetwork != SZSocialNetworkNone) {
                
                // Linked to a network -- Show network selection
                
                _SZSelectNetworkViewController *selectNetwork = [[_SZSelectNetworkViewController alloc] init];
                selectNetwork.completionBlock = ^(SZSocialNetwork selectedNetworks) {
                    [weakViewController SZDismissViewControllerAnimated:YES completion:^{
                        BLOCK_CALL_1(completion, selectedNetworks);
                    }];
                };
                selectNetwork.cancellationBlock = ^{
                    [weakLink popToRootViewControllerAnimated:YES];
                };
                
                switch (context) {
                    case SZLinkContextComment:
                        selectNetwork.title = SHARE_COMMENT_TITLE;
                        selectNetwork.continueText = SHARE_COMMENT_COMPLETE_TEXT;
                        break;
                    case SZLinkContextLike:
                        selectNetwork.title = SHARE_LIKE_TITLE;
                        selectNetwork.continueText = SHARE_LIKE_COMPLETE_TEXT;
                        break;
                }
                
                [weakLink pushViewController:selectNetwork animated:YES];
            } else {
                
                // Opted out of linking -- Don't show network selection
                [weakViewController SZDismissViewControllerAnimated:YES completion:^{
                    BLOCK_CALL_1(completion, SZSocialNetworkNone);
                }];
            }
        };
        
        link.cancellationBlock = ^{
            
            // Explicitly cancelled link -- Dismiss and call cancellation
            [weakViewController SZDismissViewControllerAnimated:YES completion:^{
                BLOCK_CALL(cancellation);                
            }];
        };
        
        [viewController presentViewController:link animated:YES completion:nil];
    } else {
        
        // No link dialog required
        
        if (!SZShouldShowNetworkSelection()) {
            BLOCK_CALL_1(completion, SZAutoPostNetworks());
        } else {
            SZSelectNetworkViewController *selectNetwork = [[SZSelectNetworkViewController alloc] init];
            __block __unsafe_unretained __typeof__(viewController) weakViewController = viewController;

            selectNetwork.completionBlock = ^(SZSocialNetwork selectedNetworks) {
                [weakViewController SZDismissViewControllerAnimated:YES completion:^{
                    BLOCK_CALL_1(completion, selectedNetworks);
                }];
                
            };
            selectNetwork.cancellationBlock = ^{
                [weakViewController SZDismissViewControllerAnimated:YES completion:^{
                    BLOCK_CALL(cancellation);
                }];
            };
            
            switch (context) {
                case SZLinkContextComment:
                    selectNetwork.title = SHARE_COMMENT_TITLE;
                    selectNetwork.continueText = SHARE_COMMENT_COMPLETE_TEXT;
                    break;
                case SZLinkContextLike:
                    selectNetwork.title = SHARE_LIKE_TITLE;
                    selectNetwork.continueText = SHARE_LIKE_COMPLETE_TEXT;
                    break;
            }
            
            [viewController presentViewController:selectNetwork animated:YES completion:nil];
        }
    }
}

void SZFBAuthWrapper( void (^success)(), void (^failure)(NSError *error)) {
    if (![SZFacebookUtils isLinked]) {
        [SZFacebookUtils linkWithOptions:nil success:^(id _) {
            BLOCK_CALL(success);
        } foreground:nil failure:^(NSError *error) {
            BLOCK_CALL_1(failure, error);
        }];
    } else {
        success();
    }
}

void SZTWAuthWrapper(UIViewController *viewController, void (^success)(), void (^failure)(NSError *error)) {
    if (![SZTwitterUtils isLinked]) {
        [SZTwitterUtils linkWithViewController:viewController success:^(id _) {
            BLOCK_CALL(success);
        } failure:^(NSError *error) {
            BLOCK_CALL_1(failure, error);
        }];
    } else {
        success();
    }
}

void SZAuthWrapper(void (^success)(), void (^failure)(NSError *error)) {
    if (![SZUserUtils userIsAuthenticated]) {
        [[Socialize sharedSocialize] authenticateAnonymouslyWithSuccess:success failure:failure];
    } else {
        success();
    }
}

BOOL SZShouldShareLocation() {
    // FIXME -- Sense should be inverted for a simpler check
    NSNumber *shouldShareNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeShouldShareLocationKey];
    if (shouldShareNumber == nil) {
        return YES;
    }
    
    return [shouldShareNumber boolValue] && ![Socialize locationSharingDisabled];
}

SZActivityOptions *SZActivityOptionsFromUserDefaults(Class optionsClass) {
    SZActivityOptions *options = [optionsClass defaultOptions];
    options.dontShareLocation = ![[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeShouldShareLocationKey] boolValue];
    
    return options;
}
                                                   
SocializeShareMedium SocializeShareMediumForSZSocialNetworks(SZSocialNetwork networks) {
    // Currently Must exlusively share to a Social Network for this to be the medium.
    SocializeShareMedium medium;
    if (networks == SZSocialNetworkFacebook) {
        medium = SocializeShareMediumFacebook;
    } else if (networks == SZSocialNetworkTwitter) {
        medium = SocializeShareMediumTwitter;
    } else {
        medium = SocializeShareMediumOther;
    }
    return medium;
}

void CreateAndShareActivityPromptIfNeeded(id<SZActivity> activity, SZShareOptions *options, ActivityCreatorBlock creator, void (^success)(id<SZActivity> activity), void (^failure)(NSError *error)) {
    if (options == nil) {
        
    }
}

SZPostDataBuilderBlock SZDefaultLinkPostData() {
    return ^(id<SZActivity> activity) {
        // This shortened link returned from the server encapsulates all the Socialize magic
        NSString *shareURL = [[[activity propagationInfoResponse] objectForKey:@"facebook"] objectForKey:@"entity_url"];
        
        NSString *name = [activity.entity displayName];
        NSString *link = shareURL;
        
        NSString *message = @"";
        if ([activity respondsToSelector:@selector(text)]) {
            message = [(id)activity text];
        }
        
        NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           name, @"name",
                                           message, @"message",
                                           link, @"link",
                                           @"link", @"type",
                                           nil];
        SZSocialNetworkPostData *postData = [[SZSocialNetworkPostData alloc] init];
        postData.params = postParams;
        postData.path = @"me/links";
        postData.entity = [activity entity];
        postData.propagationInfo = [activity propagationInfoResponse];
        

        return postData;
    };
}

void SZCreateAndShareActivity(id<SZActivity> activity,
                              SZPostDataBuilderBlock defaultFacebookPostData,
                              SZActivityOptions *options,
                              SZSocialNetwork networks,
                              ActivityCreatorBlock creator,
                              void (^success)(id<SZActivity> activity),
                              void (^failure)(NSError *error)) {
    if (networks & SZSocialNetworkFacebook && (![SZFacebookUtils isAvailable] || ![SZFacebookUtils isLinked])) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorFacebookUnavailable]);
        return;
    }
    
    if (networks & SZSocialNetworkTwitter && (![SZTwitterUtils isAvailable] || ![SZTwitterUtils isLinked])) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorTwitterUnavailable]);
        return;
    }

    NSMutableArray *thirdParties = [NSMutableArray array];
    
    if (networks & SZSocialNetworkFacebook) {
        [thirdParties addObject:@"facebook"];
    }
    
    if (networks & SZSocialNetworkTwitter) {
        [thirdParties addObject:@"twitter"];
    }
    
    if ([thirdParties count] > 0) {
        activity.propagationInfoRequest = [NSDictionary dictionaryWithObject:thirdParties forKey:@"third_parties"];
    }
    
    void (^creationBlock)() = ^{
        
        NSConditionLock *finishedNetworksLock = [[NSConditionLock alloc] initWithCondition:0];
        __block NSMutableDictionary *finishedNetworksErrors = [NSMutableDictionary dictionary];
        
        creator(activity, ^(id<SZActivity> activity) {
            if (networks & SZSocialNetworkFacebook) {
                
                SZSocialNetworkPostData *postData = defaultFacebookPostData(activity);
                postData.options = options;
                
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
                BLOCK_CALL_2(options.willPostToSocialNetworkBlock, SZSocialNetworkFacebook, postData.params);
#pragma GCC diagnostic pop
                
                BLOCK_CALL_2(options.willAttemptPostingToSocialNetworkBlock, SZSocialNetworkFacebook, postData);

                [SZFacebookUtils postWithGraphPath:postData.path params:postData.params success:^(id result) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
                    BLOCK_CALL_1(options.didPostToSocialNetworkBlock, SZSocialNetworkFacebook);
#pragma GCC diagnostic pop
                    BLOCK_CALL_2(options.didSucceedPostingToSocialNetworkBlock, SZSocialNetworkFacebook, result);

                    [finishedNetworksLock lock];
                    [finishedNetworksLock unlockWithCondition:[finishedNetworksLock condition] | SZSocialNetworkFacebook];
                    
                } failure:^(NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"Socialize Warning: Failed to post to Facebook wall: %@ / %@", [error localizedDescription], [error userInfo]);
                    }
                    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
                    BLOCK_CALL_1(options.didFailToPostToSocialNetworkBlock, SZSocialNetworkFacebook);
#pragma GCC diagnostic pop
                    BLOCK_CALL_2(options.didFailPostingToSocialNetworkBlock, SZSocialNetworkFacebook, error);

                    //cache error in thread-safe block
                    @synchronized(finishedNetworksErrors) {
                        if(error != nil) {
                            [finishedNetworksErrors setObject:error forKey:[NSNumber numberWithInt:SZSocialNetworkFacebook]];
                        }
                    }
                    [finishedNetworksLock lock];
                    [finishedNetworksLock unlockWithCondition:[finishedNetworksLock condition] | SZSocialNetworkFacebook];
                }];
            }
            
            if (networks & SZSocialNetworkTwitter) {
                NSString *text = [SZTwitterUtils defaultTwitterTextForActivity:activity];
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
                
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
                BLOCK_CALL_2(options.willPostToSocialNetworkBlock, SZSocialNetworkTwitter, params);
#pragma GCC diagnostic pop`

                SZSocialNetworkPostData *postData = [[SZSocialNetworkPostData alloc] init];
                postData.options = options;
                postData.params = params;
                postData.path = @"/1.1/statuses/update.json";
                postData.entity = [activity entity];
                postData.propagationInfo = [activity propagationInfoResponse];
                
                if (options.image != nil) {
                    postData.useMultipart = YES;
                    postData.path = @"/1.1/statuses/update_with_media.json";
                    NSData *imageData = UIImagePNGRepresentation(options.image);
                    [postData.params setObject:imageData forKey:@"media[]"];
                }

                BLOCK_CALL_2(options.willAttemptPostingToSocialNetworkBlock, SZSocialNetworkTwitter, postData);

                [SZTwitterUtils postWithViewController:nil path:postData.path params:postData.params multipart:postData.useMultipart success:^(id result) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
                    BLOCK_CALL_1(options.didPostToSocialNetworkBlock, SZSocialNetworkTwitter);
#pragma GCC diagnostic pop
                    BLOCK_CALL_2(options.didSucceedPostingToSocialNetworkBlock, SZSocialNetworkTwitter, result);

                    [finishedNetworksLock lock];
                    [finishedNetworksLock unlockWithCondition:[finishedNetworksLock condition] | SZSocialNetworkTwitter];
                } failure:^(NSError *error) {
                    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
                    BLOCK_CALL_2(options.didFailPostingToSocialNetworkBlock, SZSocialNetworkTwitter, error);
#pragma GCC diagnostic pop

                    NSLog(@"Socialize Warning: Failed to post to Twitter feed: %@ / %@", [error localizedDescription], [error userInfo]);

                    //cache error in thread-safe block
                    @synchronized(finishedNetworksErrors) {
                        if(error != nil) {
                            [finishedNetworksErrors setObject:error forKey:[NSNumber numberWithInt:SZSocialNetworkFacebook]];
                        }
                    }
                    [finishedNetworksLock lock];
                    [finishedNetworksLock unlockWithCondition:[finishedNetworksLock condition] | SZSocialNetworkTwitter];
                }];
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // Wait for all networks to finish
                [finishedNetworksLock lockWhenCondition:networks];
                [finishedNetworksLock unlock];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([finishedNetworksErrors count] > 0) {
                        //FIXME more explicit error messaging
                        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorServerReturnedErrors]);
                    }
                    else {
                        BLOCK_CALL_1(success, activity);
                    }
                });
            });
        }, failure);
        
    };

    if (SZShouldShareLocation() && !options.dontShareLocation) {
        [SZLocationUtils getCurrentLocationWithSuccess:^(CLLocation *location) {
            activity.lat = [NSNumber numberWithDouble:location.coordinate.latitude];
            activity.lng = [NSNumber numberWithDouble:location.coordinate.longitude];
            creationBlock();
        } failure:^(NSError *error) {
            NSLog(@"Socialize Warning: Location sharing requested, but could not get location. %@", [error localizedDescription]);
            creationBlock();
        }];
    } else {
        creationBlock();
    }    
}

BOOL SZErrorsAreDisabled() {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeUIErrorAlertsDisabled] boolValue];
}

void UIControllerDidFailWithErrorNotification(id object, NSError *error) {
    NSDictionary *userInfo = nil;
    if (error != nil) {
        userInfo = [NSDictionary dictionaryWithObject:error forKey:SocializeUIControllerErrorUserInfoKey];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeUIControllerDidFailWithErrorNotification
                                                        object:object
                                                      userInfo:userInfo];
}

void SZPostSocializeUIControllerDidFailWithErrorNotification(id object, NSError *error) {
    NSDictionary *userInfo = nil;
    if (error != nil) {
        userInfo = [NSDictionary dictionaryWithObject:error forKey:SocializeUIControllerErrorUserInfoKey];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeUIControllerDidFailWithErrorNotification
                                                        object:object
                                                      userInfo:userInfo];
}

void SZEmitUIError(id object, NSError *error) {
    SZPostSocializeUIControllerDidFailWithErrorNotification(object, error);
    
    if (!SZErrorsAreDisabled()) {
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"Error" message:[error localizedDescription]];
        [alertView bk_addButtonWithTitle:@"OK" handler:nil];
        [alertView show];
    }
}

void SZEmitUnconfiguredFacebookMessage() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(SOCIALIZE_FACEBOOK_NOT_CONFIGURED_MESSAGE);
    });

}

void SZEmitUnconfiguredTwitterMessage() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(SOCIALIZE_TWITTER_NOT_CONFIGURED_MESSAGE);        
    });
    
}

void SZEmitUnconfiguredSmartAlertsMessage() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(SOCIALIZE_NOTIFICATIONS_NOT_CONFIGURED_MESSAGE);
    });
}

BOOL SZOSGTE(NSString *minVersion) {
    NSString *currOsVersion = [[UIDevice currentDevice] systemVersion];
    NSComparisonResult result = [currOsVersion compare:minVersion options:NSNumericSearch];
    return result == NSOrderedSame || result == NSOrderedDescending;
}

NSStringEncoding NSStringEncodingForURLResponse(NSHTTPURLResponse *response) {
    NSStringEncoding encoding = NSISOLatin1StringEncoding;
    NSString *contentType = [[[response allHeaderFields] objectForKey:@"Content-Type"] lowercaseString];
    if (contentType && [contentType rangeOfString:@"charset=utf-8"].location != NSNotFound) {
        encoding = NSUTF8StringEncoding;
    }
    
    return encoding;
}

NSString *NSStringForHTTPURLResponse(NSHTTPURLResponse* response, NSData *data) {
    NSStringEncoding encoding = NSStringEncodingForURLResponse(response);
    return [[NSString alloc] initWithData:data encoding:encoding];
}


