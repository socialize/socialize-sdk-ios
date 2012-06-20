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
#import "SZDisplay.h"
#import "SZUserSettingsViewController.h"

@interface SZUserUtils : NSObject

+ (void)showLinkDialogWithDisplay:(id<SZDisplay>)display success:(void(^)(SZSocialNetwork selectedNetwork))success failure:(void(^)(NSError *error))failure;
+ (void)showUserProfileWithDisplay:(id<SZDisplay>)display user:(id<SocializeFullUser>)user;
+ (SZUserSettingsViewController*)showUserSettingsInViewController:(UIViewController*)viewController;
+ (void)saveUserSettings:(id<SocializeFullUser>)user profileImage:(UIImage*)image success:(void(^)(id<SocializeFullUser> user))success failure:(void(^)(NSError *error))failure;
+ (id<SocializeFullUser>)currentUser;
+ (BOOL)userIsLinked;

@end
