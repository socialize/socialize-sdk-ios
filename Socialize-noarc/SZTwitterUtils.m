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
#import "SZTwitterLinkViewController.h"
#import "SDKHelpers.h"
#import "SZUserUtils.h"

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
                                                          BLOCK_CALL_1(success, user);
                                                      } failure:failure];
}

+ (void)linkWithViewController:(UIViewController*)viewController success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure {
    NSString *consumerKey = [SocializeThirdPartyTwitter consumerKey];
    NSString *consumerSecret = [SocializeThirdPartyTwitter consumerSecret];
    
    SZTwitterLinkViewController *link = [[SZTwitterLinkViewController alloc] initWithConsumerKey:consumerKey consumerSecret:consumerSecret];

    link.completionBlock = ^{
        [viewController dismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL_1(success, [SZUserUtils currentUser]);
        }];
    };
    
    link.cancellationBlock = ^{
        [viewController dismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorTwitterCancelledByUser]);
        }];
    };
    
    
    [viewController presentModalViewController:link animated:YES];
}

@end
