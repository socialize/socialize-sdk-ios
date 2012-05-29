//
//  SZUserUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/24/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZUserUtils.h"
#import "SocializeUIDisplay.h"
#import "_Socialize.h"
#import "SZProfileViewController.h"
#import "SZNavigationController.h"
#import "SocializeUIDisplayProxy.h"
#import "SocializeAuthViewController.h"
#import "SDKHelpers.h"
#import "SZDisplay.h"

@implementation SZUserUtils

    
+ (BOOL)userIsLinked {
    id<SZFullUser> user = [self currentUser];
    return [[user thirdPartyAuth] count] > 0;
}

+ (void)showLinkDialogWithDisplay:(id<SZDisplay>)display success:(void(^)(SZSocialNetwork selectedNetwork))success failure:(void(^)(NSError *error))failure {
    if (AvailableSocialNetworks() == SZSocialNetworkNone) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorLinkNotPossible]);
    }
    
    SocializeAuthViewController *auth = [[[SocializeAuthViewController alloc] init] autorelease];
    
    auth.completionBlock = ^(SZSocialNetwork selectedNetwork) {
        [display socializeWillEndDisplaySequence];
        BLOCK_CALL_1(success, selectedNetwork);
    };
    
    auth.cancellationBlock = ^{
        [display socializeWillEndDisplaySequence];
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorLinkCancelledByUser]);
    };
    
    [display socializeWillBeginDisplaySequenceWithViewController:auth];
}

+ (void)showUserProfileWithViewController:(UIViewController*)viewController user:(id<SocializeFullUser>)user {
    SZProfileViewController *profile = [SZProfileViewController profileViewController];
    SocializeUIDisplayProxy *proxy = [SocializeUIDisplayProxy UIDisplayProxyWithObject:profile display:viewController];
    profile.displayProxy = proxy;
    profile.fullUser = user;
    SZNavigationController *nav = [[[SZNavigationController alloc] initWithRootViewController:profile] autorelease];
    [proxy presentModalViewController:nav];
}

+ (void)showUserSettingsWithViewController:(UIViewController*)viewController {
    SZSettingsViewController *settings = [SZSettingsViewController settingsViewController];
    SZNavigationController *nav = [[[SZNavigationController alloc] initWithRootViewController:settings] autorelease];
    SocializeUIDisplayProxy *proxy = [SocializeUIDisplayProxy UIDisplayProxyWithObject:settings display:viewController];
    settings.displayProxy = proxy;
    [proxy presentModalViewController:nav];
}

+ (void)saveUserSettings:(id<SocializeFullUser>)user profileImage:(UIImage*)image success:(void(^)(id<SocializeFullUser> user))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] updateUserProfile:user profileImage:image success:success failure:failure];
}

+ (id<SocializeFullUser>)currentUser {
    return [[Socialize sharedSocialize] authenticatedFullUser];
}

@end
