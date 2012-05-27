//
//  SZUserUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/24/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeUIDisplay.h"
#import "SocializeUser.h"
#import "SocializeFullUser.h"

@interface SZUserUtils : NSObject

+ (void)showLinkDialogWithViewController:(UIViewController*)viewController success:(void(^)(SZSocialNetwork selectedNetwork))success failure:(void(^)(NSError *error))failure;
+ (void)showUserProfileWithViewController:(UIViewController*)viewController user:(id<SocializeFullUser>)user;
+ (void)showUserSettingsWithViewController:(UIViewController*)viewController;
+ (void)saveUserSettings:(id<SocializeFullUser>)user profileImage:(UIImage*)image success:(void(^)(id<SocializeFullUser> user))success failure:(void(^)(NSError *error))failure;
+ (id<SocializeFullUser>)currentUser;
+ (BOOL)userIsLinked;

@end
