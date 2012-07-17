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
- (void)startMockingSucceedingFacebookAuthWithDidAuth:(void(^)(NSString *token, NSDate *expiration))didAuth;
- (void)stopMockingSucceedingFacebookAuth;
- (void)removeAuthenticationInfo;
- (NSString*)twitterAccessToken;
- (NSString*)twitterAccessTokenSecret;
- (void)startMockingSucceededFacebookAuth;
- (void)stopMockingSucceededFacebookAuth;
- (void)startMockingSucceedingLocation;
- (void)stopMockingSucceedingLocation;
- (void)startMockingSucceededTwitterAuth;
- (void)stopMockingSucceededTwitterAuth;

@end
