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
#import "SocializeProfileViewController.h"
#import "SZNavigationController.h"
#import "SocializeUIDisplayProxy.h"

@implementation SZUserUtils

+ (void)showUserProfileWithDisplay:(id<SocializeUIDisplay>)display user:(id<SocializeUser>)user {
    SocializeProfileViewController *profile = [SocializeProfileViewController profileViewController];
    SocializeUIDisplayProxy *proxy = [SocializeUIDisplayProxy UIDisplayProxyWithObject:profile display:display];
    profile.displayProxy = proxy;
    profile.user = user;
    SZNavigationController *nav = [[[SZNavigationController alloc] initWithRootViewController:profile] autorelease];
    [proxy presentModalViewController:nav];
}

+ (void)showUserSettingsWithDisplay:(id<SocializeUIDisplay>)display {
    
}

+ (void)saveUserSettings:(id<SocializeFullUser>)user success:(void(^)(id<SocializeFullUser> user))success failure:(void(^)(NSError *error))failure {

}

+ (id<SocializeFullUser>)currentUser {
    return [[Socialize sharedSocialize] authenticatedFullUser];
}

@end