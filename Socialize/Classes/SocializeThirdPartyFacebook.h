//
//  SocializeThirdPartyFacebook.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/1/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeThirdParty.h"

@interface SocializeThirdPartyFacebook : NSObject <SocializeThirdParty>

+ (NSString *)baseUrlForAppId:(NSString*)appId localAppId:(NSString*)localAppId;
+ (NSString*)facebookAppId;
+ (NSString*)facebookLocalAppId;
+ (NSString*)facebookUrlSchemeSuffix;
+ (NSString*)facebookAccessToken;
+ (NSString*)facebookExpirationDate;
+ (void)storeLocalCredentialsWithAccessToken:(NSString*)accessToken
                              expirationDate:(NSDate*)expirationDate;

@end
