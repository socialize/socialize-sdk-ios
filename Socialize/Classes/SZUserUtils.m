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

@implementation SZUserUtils

+ (void)showUserProfileWithViewController:(UIViewController*)viewController user:(id<SocializeUser>)user {
    SZProfileViewController *profile = [SZProfileViewController profileViewController];
    SocializeUIDisplayProxy *proxy = [SocializeUIDisplayProxy UIDisplayProxyWithObject:profile display:viewController];
    profile.displayProxy = proxy;
    profile.user = user;
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