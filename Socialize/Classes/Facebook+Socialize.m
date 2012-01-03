//
//  Facebook+Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/31/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "Facebook+Socialize.h"
#import "_Socialize.h"

@implementation SocializeFacebook (Socialize)

+ (NSString *)baseUrlForAppId:(NSString*)appId localAppId:(NSString*)localAppId {
    return [NSString stringWithFormat:@"fb%@%@://authorize",
            appId,
            localAppId ? localAppId : @""];
}

+ (BOOL)isFacebookConfigured {
    NSString *facebookAppId = [Socialize facebookAppId];
    if( facebookAppId == nil ) {
        return NO;
    } else {
        // this makes sure that facebook settings are configured correctly
        [SocializeFacebook verifyFacebookSettings];
        return YES;       
    }
}

+ (BOOL)alreadyAuthenticated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"FBAccessTokenKey"] != nil &&
        [[defaults objectForKey:@"FBExpirationDateKey"] timeIntervalSinceNow] > 0;
}

+ (void)verifyFacebookSettings {
    NSString *facebookAppId = [Socialize facebookAppId];
    NSString *facebookLocalAppId = [Socialize facebookLocalAppId];
    NSAssert(facebookAppId != nil, @"Socialize: Missing facebook app id. Facebook app id is required to authenticate with facebook.");
    NSURL *testURL = [NSURL URLWithString:[SocializeFacebook baseUrlForAppId:facebookAppId localAppId:facebookLocalAppId]];
    if (![self alreadyAuthenticated]) {
        NSAssert([[UIApplication sharedApplication] canOpenURL:testURL], @"Socialize: External Facebook Authentication required, but application is not configured to open facebook URL scheme! Please ensure you have configured your app to open the facebook URL scheme %@ as described at http://socialize.github.com/socialize-sdk-ios/socialize_ui.html#adding-facebook-support", testURL);
    }
}

+ (SocializeFacebook*)facebookFromSettings {
    [SocializeFacebook verifyFacebookSettings];
    NSString *facebookAppId = [Socialize facebookAppId];
    NSString *facebookLocalAppId = [Socialize facebookLocalAppId];
    NSAssert(facebookAppId != nil, @"Missing facebook app id. Facebook app id is required to authenticate with facebook.");
    SocializeFacebook *facebook = [[[SocializeFacebook alloc] initWithAppId:facebookAppId] autorelease];
    facebook.localAppId = facebookLocalAppId;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }

    return facebook;
}


@end
