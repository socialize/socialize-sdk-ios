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
#import "SZNavigationController.h"

@implementation SZTwitterUtils

+ (BOOL)isAvailable {
    return [SocializeThirdPartyTwitter available];
}

+ (BOOL)isLinked {
    return [SocializeThirdPartyTwitter isLinkedToSocialize];
}

+ (void)unlink {
    [SocializeThirdPartyTwitter removeLocalCredentials];
}

+ (void)linkWithAccessToken:(NSString*)accessToken accessTokenSecret:(NSString*)accessTokenSecret success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure {
    [SocializeThirdPartyTwitter storeLocalCredentialsWithAccessToken:accessToken accessTokenSecret:accessTokenSecret];
    
    [[Socialize sharedSocialize] linkToTwitterWithAccessToken:accessToken
                                            accessTokenSecret:accessTokenSecret
                                                      success:^(id<SZFullUser> user) {
                                                          [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kSocializeDontPostToTwitterKey];
                                                          success(user);
                                                      } failure:failure];
}

+ (void)linkWithViewController:(UIViewController*)viewController success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure {
    NSString *consumerKey = [SocializeThirdPartyTwitter consumerKey];
    NSString *consumerSecret = [SocializeThirdPartyTwitter consumerSecret];
    
    SocializeTwitterAuthViewController *auth = [[[SocializeTwitterAuthViewController alloc] initWithConsumerKey:consumerKey consumerSecret:consumerSecret] autorelease];
    SZNavigationController *nav = [[[SZNavigationController alloc] initWithRootViewController:auth] autorelease];

    auth.twitterAuthSuccessBlock = ^(NSString *accessToken, NSString *accessTokenSecret, NSString *screenName, NSString *userId) {
        [viewController dismissModalViewControllerAnimated:YES];
        [self linkWithAccessToken:accessToken accessTokenSecret:accessTokenSecret success:success failure:failure];
    };
    
    auth.cancellationBlock = ^{
        [viewController dismissModalViewControllerAnimated:YES];
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorTwitterCancelledByUser]);
    };
    
    [viewController presentModalViewController:nav animated:YES];
}

@end
