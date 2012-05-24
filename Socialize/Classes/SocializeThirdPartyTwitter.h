//
//  SocializeThirdPartyTwitter.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/1/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeThirdParty.h"

@interface SocializeThirdPartyTwitter : SocializeThirdParty <SocializeThirdParty>

+ (NSString*)consumerKey;
+ (NSString*)consumerSecret;
+ (NSString*)accessToken;
+ (NSString*)accessTokenSecret;
+ (void)removeTwitterCookies;
+ (void)storeLocalCredentialsWithAccessToken:(NSString*)accessToken
                           accessTokenSecret:(NSString*)accessTokenSecret;

@end
