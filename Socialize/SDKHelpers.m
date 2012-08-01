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
#import "Socialize.h"
#import <BlocksKit/BlocksKit.h>
#import "SZUserUtils.h"
#import "_Socialize.h"
#import "SocializePrivateDefinitions.h"
#import "_SZSelectNetworkViewController.h"
#import "SZLinkDialogViewController.h"
#import "SZSelectNetworkViewController.h"
#import "SZLocationUtils.h"
#import "socialize_globals.h"

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

BOOL SZShouldShowLinkDialog() {
    return ( SZLinkedSocialNetworks() == SZSocialNetworkNone && SZAvailableSocialNetworks() != SZSocialNetworkNone && ![Socialize authenticationNotRequired]);
}

void SZShowLinkToFacebookAlertView(void (^okBlock)(), void (^cancelBlock)()) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Authentication Required" message:@"Link to Facebook?"];
    [alertView addButtonWithTitle:@"Cancel" handler:cancelBlock];
    [alertView addButtonWithTitle:@"Ok" handler:okBlock];

    [alertView show];
}

void SZLinkAndGetPreferredNetworks(UIViewController *viewController, void (^completion)(SZSocialNetwork preferredNetworks), void (^cancellation)()) {
    
    // No Social Networks available
    if (SZAvailableSocialNetworks() == SZSocialNetworkNone) {
        BLOCK_CALL_1(completion, SZSocialNetworkNone);
    }
    
    if (SZShouldShowLinkDialog()) {
        
        // Link and possibly show network selection
        SZLinkDialogViewController *link = [[SZLinkDialogViewController alloc] init];
        __block SZLinkDialogViewController *weakLink = link;
        link.completionBlock = ^(SZSocialNetwork selectedNetwork) {
            
            if (selectedNetwork != SZSocialNetworkNone) {
                
                // Linked to a network -- Show network selection
                _SZSelectNetworkViewController *selectNetwork = [[_SZSelectNetworkViewController alloc] init];
                selectNetwork.completionBlock = ^(SZSocialNetwork selectedNetworks) {
                    [viewController SZDismissViewControllerAnimated:YES completion:^{
                        BLOCK_CALL_1(completion, selectedNetworks);
                    }];
                };
                selectNetwork.cancellationBlock = ^{
                    [link.navigationController popToViewController:link animated:YES];
                };
                
                [weakLink pushViewController:selectNetwork animated:YES];
            } else {
                
                // Opted out of linking -- Don't show network selection
                [viewController SZDismissViewControllerAnimated:YES completion:^{
                    BLOCK_CALL_1(completion, SZSocialNetworkNone);
                }];
            }
        };
        
        link.cancellationBlock = ^{
            
            // Explicitly cancelled link -- Dismiss and call cancellation
            [viewController SZDismissViewControllerAnimated:YES completion:^{
                BLOCK_CALL(cancellation);                
            }];
        };
        
        [viewController presentModalViewController:link animated:YES];
    } else {
        
        // No link dialog required
        SZSelectNetworkViewController *selectNetwork = [[SZSelectNetworkViewController alloc] init];
        selectNetwork.completionBlock = ^(SZSocialNetwork selectedNetworks) {
            [viewController SZDismissViewControllerAnimated:YES completion:^{
                BLOCK_CALL_1(completion, selectedNetworks);
            }];
            
        };
        selectNetwork.cancellationBlock = ^{
            [viewController SZDismissViewControllerAnimated:YES completion:^{
                BLOCK_CALL(cancellation);
            }];
        };
        
        [viewController presentModalViewController:selectNetwork animated:YES];
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
    
    return [shouldShareNumber boolValue];
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

void SZAttemptAction(NSTimeInterval retryInterval, SZAttemptActionBlock attempt) {
    __block void (^attemptBlock)() = ^{
        attempt(^(NSError* error) {
            [NSTimer scheduledTimerWithTimeInterval:retryInterval block:^(NSTimeInterval interval) {
                attemptBlock();
            } repeats:NO];
        });
    };
    
    attemptBlock();
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

void SZCreateAndShareActivity(id<SZActivity> activity, SZPostDataBuilderBlock defaultFacebookPostData, SZActivityOptions *options, SZSocialNetwork networks, ActivityCreatorBlock creator, void (^success)(id<SZActivity> activity), void (^failure)(NSError *error)) {
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
        
        creator(activity, ^(id<SZActivity> activity) {
            if (networks & SZSocialNetworkFacebook) {
                
                SZSocialNetworkPostData *postData = defaultFacebookPostData(activity);
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"

                BLOCK_CALL_2(options.willPostToSocialNetworkBlock, SZSocialNetworkFacebook, postData.params);

#pragma GCC diagnostic pop
                
                BLOCK_CALL_2(options.willAttemptPostToSocialNetworkBlock, SZSocialNetworkFacebook, postData);

                [SZFacebookUtils postWithGraphPath:postData.path params:postData.params success:^(id result) {
                    BLOCK_CALL_1(options.didPostToSocialNetworkBlock, SZSocialNetworkFacebook);
                    
                    [finishedNetworksLock lock];
                    [finishedNetworksLock unlockWithCondition:[finishedNetworksLock condition] | SZSocialNetworkFacebook];
                    
                } failure:^(NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"Socialize Warning: Failed to post to Facebook wall: %@ / %@", [error localizedDescription], [error userInfo]);
                    }
                    
                    // Failed Wall post is still a success. Handle separately in options.
                    BLOCK_CALL_1(options.didFailToPostToSocialNetworkBlock, SZSocialNetworkFacebook);

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

#pragma GCC diagnostic pop

                SZSocialNetworkPostData *postData = [[SZSocialNetworkPostData alloc] init];
                postData.params = params;
                postData.path = @"/1/statuses/update.json";
                postData.entity = [activity entity];
                postData.propagationInfo = [activity propagationInfoResponse];
                BLOCK_CALL_2(options.willAttemptPostToSocialNetworkBlock, SZSocialNetworkTwitter, postData);

                [SZTwitterUtils postWithPath:postData.path params:postData.params success:^(id result) {
                    BLOCK_CALL_1(options.didPostToSocialNetworkBlock, SZSocialNetworkTwitter);

                    [finishedNetworksLock lock];
                    [finishedNetworksLock unlockWithCondition:[finishedNetworksLock condition] | SZSocialNetworkTwitter];
                } failure:^(NSError *error) {
                    
                    BLOCK_CALL_1(options.didFailToPostToSocialNetworkBlock, SZSocialNetworkTwitter);

                    NSLog(@"Socialize Warning: Failed to post to Twitter feed: %@ / %@", [error localizedDescription], [error userInfo]);
                    [finishedNetworksLock lock];
                    [finishedNetworksLock unlockWithCondition:[finishedNetworksLock condition] | SZSocialNetworkTwitter];
                }];
            }
            

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                // Wait for all networks to finish
                [finishedNetworksLock lockWhenCondition:networks];
                [finishedNetworksLock unlock];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    BLOCK_CALL_1(success, activity);
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
        UIAlertView *alertView = [UIAlertView alertWithTitle:@"Error" message:[error localizedDescription]];
        [alertView addButtonWithTitle:@"Ok"];
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

NSString *SZGetProvisioningProfile() {
    NSString * profilePath = [[NSBundle mainBundle] pathForResource:@"embedded.mobileprovision" ofType:nil];
    if (profilePath == nil) {
        return nil;
    }
    
    NSData *profileData = [NSData dataWithContentsOfFile:profilePath];
    NSData *startData = [@"<!DOCTYPE" dataUsingEncoding:NSISOLatin1StringEncoding];

    // Find the xml string
    NSRange doctypeRange = [profileData rangeOfData:startData options:0 range:NSMakeRange(0, [profileData length])];
    if (doctypeRange.location == NSNotFound) {
        return nil;
    }
    NSRange xmlRange = NSMakeRange(doctypeRange.location, [profileData length] - doctypeRange.location);
    NSData *xmlData = [profileData subdataWithRange:xmlRange];
    NSString *profileAsString = [[NSString alloc] initWithData:xmlData encoding:NSISOLatin1StringEncoding];

    return profileAsString;
}

BOOL SZIsProduction() {
    NSString *profileAsString = SZGetProvisioningProfile();
    if ([profileAsString length] == 0) {
        return NO;
    }
    
    profileAsString = [[profileAsString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    NSRange range = [profileAsString rangeOfString:@"<key>get-task-allow</key><true/>" options:NSCaseInsensitiveSearch];
    BOOL isProduction = range.location == NSNotFound;

    return isProduction;
}
