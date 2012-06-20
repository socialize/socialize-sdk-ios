//
//  SZUserUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/24/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZUserUtils.h"
#import "_Socialize.h"
#import "SZProfileViewController.h"
#import "SZNavigationController.h"
#import "SocializeAuthViewController.h"
#import "SDKHelpers.h"
#import "SZDisplay.h"
#import "SZUserSettingsViewController.h"

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

+ (void)showUserProfileWithDisplay:(id<SZDisplay>)display user:(id<SocializeFullUser>)user {
    SZDisplayWrapper *wrapper = [SZDisplayWrapper displayWrapperWithDisplay:display];
    SZProfileViewController *profile = [SZProfileViewController profileViewController];
    
    profile.fullUser = user;
    profile.completionBlock = ^{
        [wrapper endSequence];
    };
    
    profile.cancellationBlock = ^{
        [wrapper endSequence];
    };

    [wrapper beginSequenceWithViewController:profile];
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
