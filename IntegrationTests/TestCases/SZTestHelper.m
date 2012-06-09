//
//  SZTestHelper.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZTestHelper.h"
#import "SZFacebookUtils.h"
#import "SocializeFacebookAuthHandler.h"
#import <OCMock/OCMock.h>
#import <OCMock/NSObject+ClassMock.h>

static SZTestHelper *sharedTestHelper;

@implementation SZTestHelper

+ (id)sharedTestHelper {
    if (sharedTestHelper == nil) {
        sharedTestHelper = [[SZTestHelper alloc] init];
    }
    
    return sharedTestHelper;
}

-(NSDictionary*)authInfoFromConfig {
    NSBundle * bundle =  [NSBundle bundleForClass:[self class]];
    NSString * configPath = [bundle pathForResource:@"SocializeApiInfo" ofType:@"plist"];
    NSDictionary * configurationDictionary = [[[NSDictionary alloc]initWithContentsOfFile:configPath] autorelease];
    return  [configurationDictionary objectForKey:@"Socialize API info"];
}

- (NSString*)facebookAccessToken {
    NSDictionary *apiInfo = [self authInfoFromConfig];
    return [apiInfo objectForKey:@"facebookToken"];
}

- (NSString*)twitterAccessToken {
    NSDictionary *apiInfo = [self authInfoFromConfig];
    return [apiInfo objectForKey:@"twitterToken"];
}

- (NSString*)twitterAccessTokenSecret {
    NSDictionary *apiInfo = [self authInfoFromConfig];
    return [apiInfo objectForKey:@"twitterTokenSecret"];
}

- (void)startMockingSucceedingFacebookAuth {
    [SocializeFacebookAuthHandler startMockingClass];
    
    id mockHandler = [OCMockObject mockForClass:[SocializeFacebookAuthHandler class]];
    [[[mockHandler stub] andDo5:^(id _1, id _2, id _3, id success, id _4) {
        void (^successBlock)(NSString *accessToken, NSDate *expirationDate) = success;
        successBlock([self facebookAccessToken], [NSDate distantFuture]);
    }] authenticateWithAppId:OCMOCK_ANY urlSchemeSuffix:OCMOCK_ANY permissions:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    [[[SocializeFacebookAuthHandler stub] andReturn:mockHandler] sharedFacebookAuthHandler];
}

- (void)stopMockingSucceedingFacebookAuth {
    [SocializeFacebookAuthHandler stopMockingClass];
}

- (void)removeAuthenticationInfo {
    [[Socialize sharedSocialize] removeAuthenticationInfo];
}

@end
