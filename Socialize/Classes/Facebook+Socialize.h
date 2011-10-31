//
//  Facebook+Socialize.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/31/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeFacebook.h"

@interface SocializeFacebook ()
- (NSString *)getOwnBaseUrl;
@end


@interface SocializeFacebook (Socialize)

+ (NSString *)baseUrlForAppId:(NSString*)appId localAppId:(NSString*)localAppId;

/**
 Generates a facebook object using the store Socialize settings. Also verifies app is properly
 configured for using facebook
 
 @return A new facebook instance
 */
+ (SocializeFacebook*)facebookFromSettings;

+ (BOOL)facebookIsUsable;
+ (void)verifyFacebookSettings;

@end
