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
#import "SDKHelpers.h"

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

+ (void)linkWithDisplay:(id<SZDisplay>)display success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure {
    SZDisplayWrapper *wrapper = [SZDisplayWrapper displayWrapperWithDisplay:display];
    
    NSString *consumerKey = [SocializeThirdPartyTwitter consumerKey];
    NSString *consumerSecret = [SocializeThirdPartyTwitter consumerSecret];
    
    SocializeTwitterAuthViewController *auth = [[[SocializeTwitterAuthViewController alloc] initWithConsumerKey:consumerKey consumerSecret:consumerSecret] autorelease];

    auth.twitterAuthSuccessBlock = ^(NSString *accessToken, NSString *accessTokenSecret, NSString *screenName, NSString *userId) {
        [wrapper startLoadingInTopControllerWithMessage:@"Linking"];
        [self linkWithAccessToken:accessToken accessTokenSecret:accessTokenSecret success:^(id<SZFullUser> user) {
            [wrapper stopLoadingInTopController];
            [wrapper endSequence];
            BLOCK_CALL_1(success, user);
        } failure:^(NSError *error) {
            SZEmitUIError(auth, error);
            [wrapper stopLoadingInTopController];
            BLOCK_CALL_1(failure, error);
        }];
    };
    
    auth.cancellationBlock = ^{
        [wrapper endSequence];
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorTwitterCancelledByUser]);
    };
    
    [wrapper beginSequenceWithViewController:auth];
}

@end
