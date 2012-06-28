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

@implementation SZUserUtils

+ (BOOL)userIsLinked {
    id<SZFullUser> user = [self currentUser];
    return [[user thirdPartyAuth] count] > 0;
}

+ (void)showLinkDialogWithViewController:(UIViewController*)viewController completion:(void(^)(SZSocialNetwork selectedNetwork))completion cancellation:(void(^)())cancellation {
    NSAssert(SZAvailableSocialNetworks() != SZSocialNetworkNone, @"Link not possible");
    
    SZLinkDialogViewController *linkDialog = [[SZLinkDialogViewController alloc] init];
    linkDialog.completionBlock = ^(SZSocialNetwork selectedNetwork) {
        [viewController dismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL_1(completion, selectedNetwork);
        }];
    };
    
    linkDialog.cancellationBlock = ^{
        [viewController dismissViewControllerAnimated:YES completion:^{
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
        [viewController dismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL_1(completion, user);
        }];
    };
    [viewController presentModalViewController:profile animated:YES];
}

+ (void)showUserSettingsInViewController:(UIViewController*)viewController completion:(void(^)())completion {
    SZUserSettingsViewController *settings = [[SZUserSettingsViewController alloc] init];
    settings.completionBlock = ^(BOOL didSave, id<SZFullUser> user) {
        [viewController dismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL(completion);
        }];
    };
    
    [viewController presentModalViewController:settings animated:YES];
}

+ (void)saveUserSettings:(id<SocializeFullUser>)user profileImage:(UIImage*)image success:(void(^)(id<SocializeFullUser> user))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        
        [[Socialize sharedSocialize] updateUserProfile:user profileImage:image success:^(id<SZFullUser> fullUser) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:fullUser forKey:kSZUpdatedUserSettingsKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:SZUserSettingsDidChangeNotification object:nil userInfo:userInfo];
            BLOCK_CALL_1(success, fullUser);
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
