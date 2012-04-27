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

+ (void)showUserProfileWithDisplay:(id<SocializeUIDisplay>)display user:(id<SocializeFullUser>)user;
+ (void)showUserSettingsWithDisplay:(id<SocializeUIDisplay>)display;
+ (void)saveUserSettings:(id<SocializeFullUser>)user success:(void(^)(id<SocializeFullUser> user))success failure:(void(^)(NSError *error))failure;

+ (id<SocializeFullUser>)currentUser;

@end
