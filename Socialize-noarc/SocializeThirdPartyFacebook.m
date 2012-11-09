//
//  SocializeThirdPartyFacebook.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/1/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeThirdPartyFacebook.h"
#import "SocializeCommonDefinitions.h"
#import "_Socialize.h"
#import "socialize_globals.h"

@implementation SocializeThirdPartyFacebook

+ (BOOL)available {
    NSString *facebookAppId = [self facebookAppId];
    if (facebookAppId == nil) {
        return NO;
    }
    
    if (![self canOpenFacebookURL]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSLog(SOCIALIZE_FACEBOOK_CANNOT_OPEN_URL_MESSAGE);
        });
    }
    
    return YES;
}

+ (BOOL)canOpenFacebookURL {
    NSString *facebookAppId = [self facebookAppId];
    NSString *facebookLocalAppId = [self facebookLocalAppId];

    NSURL *testURL = [NSURL URLWithString:[self baseUrlForAppId:facebookAppId localAppId:facebookLocalAppId]];
    if (![[UIApplication sharedApplication] canOpenURL:testURL]) {
        return NO;
    }

    return YES;
}


+ (NSString *)baseUrlForAppId:(NSString*)appId localAppId:(NSString*)localAppId {
    return [NSString stringWithFormat:@"fb%@%@://authorize",
            appId,
            localAppId ? localAppId : @""];
}

+ (NSString*)facebookAppId {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kSocializeFacebookAuthAppId];
}

+ (NSString*)facebookLocalAppId {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kSocializeFacebookAuthLocalAppId];
}

+ (void)storeLocalCredentialsWithAccessToken:(NSString*)accessToken
                              expirationDate:(NSDate*)expirationDate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:kSocializeFacebookAuthAccessToken];
    [defaults setObject:expirationDate forKey:kSocializeFacebookAuthExpirationDate];
    
    [defaults synchronize];
}

+ (NSString*)facebookUrlSchemeSuffix {
    return [self facebookLocalAppId];
}

+ (NSString*)facebookAccessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeFacebookAuthAccessToken];
}

+ (NSDate*)facebookExpirationDate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeFacebookAuthExpirationDate];
}

+ (NSString*)socializeAuthToken {
    return [self facebookAccessToken];
}

+ (NSString*)socializeAuthTokenSecret {
    return nil;
}

+ (SocializeThirdPartyAuthType)socializeAuthType {
    return SocializeThirdPartyAuthTypeFacebook;
}

+ (NSError*)thirdPartyUnavailableError {
    return [NSError defaultSocializeErrorForCode:SocializeErrorFacebookUnavailable];
}

+ (NSError*)userAbortedAuthError {
    return [NSError defaultSocializeErrorForCode:SocializeErrorFacebookCancelledByUser];
}

+ (NSString*)thirdPartyName {
    return @"Facebook";
}

+ (BOOL)isLinkedToSocialize {
    return [self available] && [self hasLocalCredentials] && [[Socialize sharedSocialize] isAuthenticatedWithAuthType:kSocializeFacebookStringForAPI];
}

+ (BOOL)hasLocalCredentials {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kSocializeFacebookAuthAccessToken] != nil &&
    [[defaults objectForKey:kSocializeFacebookAuthExpirationDate] timeIntervalSinceNow] > 0;
}

+ (void)removeFacebookCookies {
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:
                                [NSURL URLWithString:@"http://login.facebook.com"]];
    
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
}

+ (void)removeLocalCredentials {
    [self removeFacebookCookies];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kSocializeFacebookAuthAccessToken];
    [defaults removeObjectForKey:kSocializeFacebookAuthExpirationDate];
}

+ (Facebook*)createFacebookClient {
    NSAssert([self available], @"Tried to create facebook instance when facebook not available");
    NSAssert([self hasLocalCredentials], @"Tried to create facebook instance without local credentials");
    
    Facebook *facebook = [[[Facebook alloc] initWithAppId:[self facebookAppId] urlSchemeSuffix:[self facebookLocalAppId] andDelegate:nil] autorelease];
    facebook.accessToken = [self facebookAccessToken];
    facebook.expirationDate = [self facebookExpirationDate];
    
    return facebook;
    
}

+ (NSString*)dontPostKey {
    return kSocializeDontPostToFacebookKey;
}

+ (SZSocialNetwork)socialNetworkFlag {
    return SZSocialNetworkFacebook;
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
