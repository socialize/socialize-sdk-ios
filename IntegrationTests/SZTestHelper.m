//
//  SZTestHelper.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZTestHelper.h"
#import <Socialize/Socialize.h>
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
    [SZFacebookUtils startMockingClass];
    
    [[[SZFacebookUtils stub] andDo4:^(id _1, id _2, id success, id _4) {
        void (^successBlock)(NSString *accessToken, NSDate *expirationDate) = success;
        successBlock([self facebookAccessToken], [NSDate distantFuture]);
    }] linkWithViewController:OCMOCK_ANY options:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)stopMockingSucceedingFacebookAuth {
    [SZFacebookUtils stopMockingClass];
}

- (void)removeAuthenticationInfo {
    [[Socialize sharedSocialize] removeAuthenticationInfo];
}

@end
