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

@interface SZUserUtils : NSObject

+ (void)showLinkDialogWithViewController:(UIViewController*)viewController completion:(void(^)(SZSocialNetwork selectedNetwork))completion cancellation:(void(^)())cancellation;
+ (void)showUserProfileInViewController:(UIViewController*)viewController user:(id<SocializeFullUser>)user completion:(void(^)(id<SZFullUser> user))completion;
+ (void)showUserSettingsInViewController:(UIViewController*)viewController completion:(void(^)())completion;
+ (void)saveUserSettings:(id<SocializeFullUser>)user profileImage:(UIImage*)image success:(void(^)(id<SocializeFullUser> user))success failure:(void(^)(NSError *error))failure;
+ (id<SocializeFullUser>)currentUser;
+ (BOOL)userIsLinked;

@end
