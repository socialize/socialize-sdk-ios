//
//  SZTwitterUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZTwitterUtils.h"
#import "SocializeThirdPartyTwitter.h"
#import "_Socialize.h"
#import "SocializeTwitterAuthViewController.h"

@implementation SZTwitterUtils

+ (BOOL)isAvailable {
    return [SocializeThirdPartyTwitter available];
}

+ (BOOL)isLinked {
    return [SocializeThirdPartyTwitter isLinkedToSocialize];
}

+ (void)linkToTwitterWithAccessToken:(NSString*)accessToken accessTokenSecret:(NSString*)accessTokenSecret success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure {
}

+ (void)linkToTwitterWithViewController:(UIViewController*)viewController success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure {
}

@end
