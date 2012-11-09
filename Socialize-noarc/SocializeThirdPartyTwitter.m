//
//  SocializeThirdPartyTwitter.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/1/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeThirdPartyTwitter.h"
#import "SocializeCommonDefinitions.h"
#import "_Socialize.h"
#import "socialize_globals.h"

@implementation SocializeThirdPartyTwitter

+ (BOOL)available {
    return [[self consumerKey] length] > 0 && [[self consumerSecret] length] > 0;
}

+ (NSString*)consumerKey {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeTwitterAuthConsumerKey];
}

+ (NSString*)consumerSecret {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeTwitterAuthConsumerSecret];
}

+ (NSString*)accessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeTwitterAuthAccessToken];
}

+ (NSString*)accessTokenSecret {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeTwitterAuthAccessTokenSecret];
}

+ (NSString*)socializeAuthToken {
    return [self accessToken];
}

+ (NSString*)socializeAuthTokenSecret {
    return [self accessTokenSecret];
}

+ (SocializeThirdPartyAuthType)socializeAuthType {
    return SocializeThirdPartyAuthTypeTwitter;
}

+ (void)storeLocalCredentialsWithAccessToken:(NSString*)accessToken
                           accessTokenSecret:(NSString*)accessTokenSecret {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:kSocializeTwitterAuthAccessToken];
    [defaults setObject:accessTokenSecret forKey:kSocializeTwitterAuthAccessTokenSecret];
    [defaults synchronize];
}

+ (void)removeTwitterCookies {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        if ([[cookie domain] isEqualToString:@".twitter.com"]) {
            [storage deleteCookie:cookie];
        }
    }

}

+ (NSError*)thirdPartyUnavailableError {
    return [NSError defaultSocializeErrorForCode:SocializeErrorTwitterUnavailable];
}

+ (NSError*)userAbortedAuthError {
    return [NSError defaultSocializeErrorForCode:SocializeErrorTwitterCancelledByUser];
}

+ (NSString*)thirdPartyName {
    return @"Twitter";
}

+ (BOOL)isLinkedToSocialize {
    return [self available] && [self hasLocalCredentials] && [[Socialize sharedSocialize] isAuthenticatedWithAuthType:kSocializeTwitterStringForAPI];
}

+ (BOOL)hasLocalCredentials {
    return [[self accessToken] length] > 0 && [[self accessToken] length] > 0;
}

+ (void)removeLocalCredentials {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Remove any Twitter data -- these are Socialize specific
    [defaults removeObjectForKey:kSocializeTwitterAuthAccessToken];
    [defaults removeObjectForKey:kSocializeTwitterAuthAccessTokenSecret];
    [defaults synchronize];
    
    [self removeTwitterCookies];
}

+ (NSString*)dontPostKey {
    return kSocializeDontPostToTwitterKey;
}

+ (SZSocialNetwork)socialNetworkFlag {
    return SZSocialNetworkTwitter;
}

+ (BOOL)userPrefersPost {
    BOOL dontPost = [[[NSUserDefaults standardUserDefaults] objectForKey:[self dontPostKey]] boolValue];
    return !dontPost;
}

+ (BOOL)shouldAutopost {
    BOOL linked = [self isLinkedToSocialize];
    BOOL userPrefersPost = [self userPrefersPost];
    BOOL autopost = [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeAutoPostToSocialNetworksKey] boolValue];
    return linked && autopost && userPrefersPost;
}

@end
