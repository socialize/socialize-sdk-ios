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

+ (void)verifyFacebookSettings {
    NSString *facebookAppId = [Socialize facebookAppId];
    NSString *facebookLocalAppId = [Socialize facebookLocalAppId];
    NSAssert(facebookAppId != nil, @"Missing facebook app id. Facebook app id is required to authenticate with facebook.");
    NSURL *testURL = [NSURL URLWithString:[SocializeFacebook baseUrlForAppId:facebookAppId localAppId:facebookLocalAppId]];
    if (![[UIApplication sharedApplication] canOpenURL:testURL]) {
        NSLog(@"[Socialize WARNING] Application is not configured to open facebook URL scheme! Please ensure you have configured a facebook URL scheme for your app as described at http://socialize.github.com/socialize-sdk-ios/socialize_ui.html#adding-facebook-support");
    }
}

+ (SocializeFacebook*)facebookFromSettings {
    [self verifyFacebookSettings];
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
