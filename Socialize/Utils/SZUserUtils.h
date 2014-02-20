//
//  SZUserUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/24/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeUser.h"
#import "SocializeFullUser.h"
#import "SZUserSettingsViewController.h"
#import "SZUserSettings.h"

@interface SZUserUtils : NSObject

+ (void)showLinkDialogWithViewController:(UIViewController*)viewController completion:(void(^)(SZSocialNetwork selectedNetwork))completion cancellation:(void(^)())cancellation;
+ (void)showUserProfileInViewController:(UIViewController*)viewController user:(id)user completion:(void(^)(id<SZFullUser> user))completion;
+ (void)showUserSettingsInViewController:(UIViewController*)viewController completion:(void(^)())completion;
+ (SZUserSettings*)currentUserSettings;
+ (id<SocializeFullUser>)currentUser;
+ (BOOL)userIsLinked;
+ (BOOL)userIsAuthenticated;
+ (void)getUsersWithIds:(NSArray*)ids success:(void(^)(NSArray *users))success failure:(void(^)(NSError *error))failure;
+ (void)saveUserSettings:(SZUserSettings*)settings success:(void(^)(SZUserSettings *settings, id<SocializeFullUser> updatedUser))success failure:(void(^)(NSError *error))failure;
@end
