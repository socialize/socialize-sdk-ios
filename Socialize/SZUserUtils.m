//
//  SZUserUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/24/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZUserUtils.h"
#import "_Socialize.h"
#import "_SZUserProfileViewController.h"
#import "SZNavigationController.h"
#import "_SZLinkDialogViewController.h"
#import "SDKHelpers.h"
#import "SZDisplay.h"
#import "SZUserSettingsViewController.h"
#import "SZUserProfileViewController.h"
#import "SZLinkDialogViewController.h"
#import "socialize_globals.h"

@implementation SZUserUtils

+ (BOOL)userIsLinked {
    id<SZFullUser> user = [self currentUser];
    return [[user thirdPartyAuth] count] > 0;
}

+ (BOOL)userIsAuthenticated {
    return [[Socialize sharedSocialize] isAuthenticated];
}

+ (void)showLinkDialogWithViewController:(UIViewController*)viewController completion:(void(^)(SZSocialNetwork selectedNetwork))completion cancellation:(void(^)())cancellation {
    NSAssert(SZAvailableSocialNetworks() != SZSocialNetworkNone, @"Link not possible");
    
    SZLinkDialogViewController *linkDialog = [[SZLinkDialogViewController alloc] init];
    linkDialog.completionBlock = ^(SZSocialNetwork selectedNetwork) {
        [viewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL_1(completion, selectedNetwork);
        }];
    };
    
    linkDialog.cancellationBlock = ^{
        [viewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL(cancellation);
        }];
    };
    
    [viewController presentModalViewController:linkDialog animated:YES];
}

+ (void)showUserProfileInViewController:(UIViewController*)viewController user:(id<SocializeFullUser>)user completion:(void(^)(id<SZFullUser> user))completion {
    if (user == nil) {
        user = [self currentUser];
    }
    
    SZUserProfileViewController *profile = [[SZUserProfileViewController alloc] initWithUser:(id<SZUser>)user];
    profile.completionBlock = ^(id<SZFullUser> user) {
        [viewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL_1(completion, user);
        }];
    };
    [viewController presentModalViewController:profile animated:YES];
}

+ (void)showUserSettingsInViewController:(UIViewController*)viewController completion:(void(^)())completion {
    SZUserSettingsViewController *settings = [[SZUserSettingsViewController alloc] init];
    settings.completionBlock = ^(BOOL didSave, id<SZFullUser> user) {
        [viewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL(completion);
        }];
    };
    
    [viewController presentModalViewController:settings animated:YES];
}

+ (SZUserSettings*)currentUserSettings {
    id<SZFullUser> currentUser = [self currentUser];
    SZUserSettings *settings = [[SZUserSettings alloc] initWithFullUser:currentUser];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    settings.dontPostToFacebook = [defaults objectForKey:kSocializeDontPostToFacebookKey];
    settings.dontPostToTwitter = [defaults objectForKey:kSocializeDontPostToTwitterKey];
    settings.autopostEnabled = [defaults objectForKey:kSocializeAutoPostToSocialNetworksKey];
    BOOL dontShareLocation = !SZShouldShareLocation();
    settings.dontShareLocation = [NSNumber numberWithBool:dontShareLocation];
    
    return settings;
}

+ (void)saveUserSettings:(SZUserSettings*)settings success:(void(^)(SZUserSettings *settings, id<SocializeFullUser> updatedUser))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        
        // Save the portion of the settings that are user defaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL shouldShareLocation = ![settings.dontShareLocation boolValue];
        [defaults setObject:[NSNumber numberWithBool:shouldShareLocation] forKey:kSocializeShouldShareLocationKey];
        [defaults setObject:settings.dontPostToFacebook forKey:kSocializeDontPostToFacebookKey];
        [defaults setObject:settings.dontPostToTwitter forKey:kSocializeDontPostToTwitterKey];
        [defaults setObject:settings.autopostEnabled forKey:kSocializeAutoPostToSocialNetworksKey];
        [defaults synchronize];
        
        // Generate an SZFullUser and send it off
        id<SocializeFullUser> user = [self currentUser];
        [settings populateFullUser:user];
        
        if (settings.profileImage == nil) {
            
        }
        
        [[Socialize sharedSocialize] updateUserProfile:user profileImage:settings.profileImage success:^(id<SZFullUser> fullUser) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      fullUser, kSZUpdatedUserKey,
                                      settings, kSZUpdatedUserSettingsKey, nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SZUserSettingsDidChangeNotification object:nil userInfo:userInfo];
            BLOCK_CALL_2(success, settings, fullUser);
        } failure:failure];
        
    }, failure);

}

+ (id<SocializeFullUser>)currentUser {
    return [[Socialize sharedSocialize] authenticatedFullUser];
}

+ (void)getUsersWithIds:(NSArray*)ids success:(void(^)(NSArray *users))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getUsersWithIds:ids success:success failure:failure];
}

@end
