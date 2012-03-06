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

+ (void)storeLocalCredentialsAccessToken:(NSString*)accessToken
                       accessTokenSecret:(NSString*)accessTokenSecret
                              screenName:(NSString*)screenName
                                  userId:(NSString*)userId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:kSocializeTwitterAuthAccessToken];
    [defaults setObject:accessTokenSecret forKey:kSocializeTwitterAuthAccessTokenSecret];
    [defaults setObject:screenName forKey:kSocializeTwitterAuthScreenName];
    [defaults setObject:userId forKey:kSocializeTwitterAuthUserId];
    [defaults synchronize];
}

+ (BOOL)authenticationPossible {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:kSocializeTwitterAuthConsumerKey] length] > 0 &&
    [[defaults objectForKey:kSocializeTwitterAuthConsumerSecret] length] > 0;
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

+ (BOOL)isAuthenticated {
    return [self hasLocalCredentials] && [[Socialize sharedSocialize] isAuthenticatedWithAuthType:kSocializeTwitterStringForAPI];
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

+ (void)authenticateUsingLocalCredentials {
    [[Socialize sharedSocialize] authenticateViaTwitterWithAccessToken:[self accessToken] accessTokenSecret:[self accessTokenSecret]];
}

@end
