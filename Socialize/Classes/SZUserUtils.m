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

@implementation SZUserUtils

+ (void)showUserProfileWithDisplay:(id<SocializeUIDisplay>)display user:(id<SocializeUser>)user {
    
}

+ (void)showUserSettingsWithDisplay:(id<SocializeUIDisplay>)display {
    
}

+ (void)saveUserSettings:(id<SocializeFullUser>)user success:(void(^)(id<SocializeFullUser> user))success failure:(void(^)(NSError *error))failure {

}

+ (id<SocializeFullUser>)currentUser {
    return [[Socialize sharedSocialize] authenticatedFullUser];
}

@end