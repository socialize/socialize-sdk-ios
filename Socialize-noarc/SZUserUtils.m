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
#import "SocializeAuthViewController.h"
#import "SDKHelpers.h"
#import "SZDisplay.h"
#import "SZUserSettingsViewController.h"
#import "SZUserProfileViewController.h"

@implementation SZUserUtils

    
+ (BOOL)userIsLinked {
    id<SZFullUser> user = [self currentUser];
    return [[user thirdPartyAuth] count] > 0;
}

+ (void)showLinkDialogWithDisplay:(id<SZDisplay>)display success:(void(^)(SZSocialNetwork selectedNetwork))success failure:(void(^)(NSError *error))failure {
//    if (AvailableSocialNetworks() == SZSocialNetworkNone) {
//        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorLinkNotPossible]);
//    }
//    
//    SZDisplayWrapper *wrapper = [SZDisplayWrapper displayWrapperWithDisplay:display];
//    SocializeAuthViewController *auth = [[SocializeAuthViewController alloc] init];
//    auth.display = display;
//    
//    auth.completionBlock = ^(SZSocialNetwork selectedNetwork) {
//        [wrapper endSequence];
//        BLOCK_CALL_1(success, selectedNetwork);
//    };
//    
//    auth.cancellationBlock = ^{
//        [wrapper endSequence];
//        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorLinkCancelledByUser]);
//    };
//
//    [wrapper beginSequenceWithViewController:auth];
}

+ (void)showUserProfileInViewController:(UIViewController*)viewController user:(id<SocializeFullUser>)user completion:(void(^)(id<SZFullUser> user))completion {
    SZUserProfileViewController *profile = [[SZUserProfileViewController alloc] initWithUser:(id<SZUser>)user];
    profile.completionBlock = ^(id<SZFullUser> user) {
        [viewController dismissModalViewControllerAnimated:YES];
    };
    [viewController presentModalViewController:profile animated:YES];
}

+ (SZUserSettingsViewController*)showUserSettingsInViewController:(UIViewController*)viewController {
    SZUserSettingsViewController *settings = [[SZUserSettingsViewController alloc] init];
    settings.completionBlock = ^(BOOL didSave, id<SZFullUser> user) {
        [viewController dismissModalViewControllerAnimated:YES];
    };
    
    [viewController presentModalViewController:settings animated:YES];
    
    return settings;
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

@end
