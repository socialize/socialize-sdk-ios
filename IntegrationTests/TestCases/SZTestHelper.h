//
//  SZTestHelper.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZIntegrationTestCase.h"

@interface SZTestHelper : SZIntegrationTestCase
+ (id)sharedTestHelper;
- (NSString*)facebookAccessToken;
- (void)startMockingSucceedingFacebookAuth;
- (void)stopMockingSucceedingFacebookAuth;
- (void)removeAuthenticationInfo;
- (NSString*)twitterAccessToken;
- (NSString*)twitterAccessTokenSecret;

@end
