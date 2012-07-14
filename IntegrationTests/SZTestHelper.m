//
//  SZTestHelper.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZTestHelper.h"
//#import "SZFacebookUtils.h"
#import "SocializeFacebookAuthHandler.h"
#import <OCMock/OCMock.h>
#import <OCMock/NSObject+ClassMock.h>
//#import "_Socialize.h"
#import <FBConnect/FBConnect.h>
#import "SocializeLocationManager.h"

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

- (NSString*)twitterConsumerKey {
    NSDictionary *apiInfo = [self authInfoFromConfig];
    return [apiInfo objectForKey:@"twitterConsumerKey"];
}

- (NSString*)twitterConsumerSecret {
    NSDictionary *apiInfo = [self authInfoFromConfig];
    return [apiInfo objectForKey:@"twitterConsumerSecret"];
}

- (void)startMockingSucceededTwitterAuth {
    [SZTwitterUtils startMockingClass];
    [[[SZTwitterUtils stub] andReturnBool:YES] isLinked];
    [[[SZTwitterUtils stub] andReturn:[self twitterAccessToken]] accessToken];
    [[[SZTwitterUtils stub] andReturn:[self twitterAccessTokenSecret]] accessTokenSecret];
    [[[SZTwitterUtils stub] andReturn:[self twitterConsumerKey]] consumerKey];
    [[[SZTwitterUtils stub] andReturn:[self twitterConsumerSecret]] consumerSecret];
}

- (void)stopMockingSucceededTwitterAuth {
    [SZTwitterUtils stopMockingClassAndVerify];
}

- (void)startMockingSucceededFacebookAuth {
    [SZFacebookUtils startMockingClass];
    [[[SZFacebookUtils stub] andReturnBool:YES] isLinked];
}

- (void)stopMockingSucceededFacebookAuth {
    [SZFacebookUtils stopMockingClass];    
}

- (void)startMockingSucceedingFacebookAuthWithDidAuth:(void(^)(NSString *token, NSDate *expiration))didAuth {
    [SocializeFacebookAuthHandler startMockingClass];
    
    id mockHandler = [OCMockObject mockForClass:[SocializeFacebookAuthHandler class]];
    [[[mockHandler stub] andDo5:^(id _1, id _2, id _3, id success, id _4) {
        void (^successBlock)(NSString *accessToken, NSDate *expirationDate) = success;
        successBlock([self facebookAccessToken], [NSDate distantFuture]);
        
        BLOCK_CALL_2(didAuth, [self facebookAccessToken], [NSDate distantFuture]);
    }] authenticateWithAppId:OCMOCK_ANY urlSchemeSuffix:OCMOCK_ANY permissions:OCMOCK_ANY success:OCMOCK_ANY foreground:OCMOCK_ANY failure:OCMOCK_ANY];
    
    [[[SocializeFacebookAuthHandler stub] andReturn:mockHandler] sharedFacebookAuthHandler];
}

- (void)stopMockingSucceedingFacebookAuth {
    [SocializeFacebookAuthHandler stopMockingClass];
}

- (void)startMockingSucceedingLocation {
    [SocializeLocationManager startMockingClass];
    [[[SocializeLocationManager stub] andReturnBool:YES] locationServicesAvailable];
    SocializeLocationManager *sharedManager = [[SocializeLocationManager origClass] sharedLocationManager];
    [[[SocializeLocationManager stub] andReturn:sharedManager] sharedLocationManager];

    id mockLocationManager = [OCMockObject mockForClass:[CLLocationManager class]];
    [[[mockLocationManager stub] andDo0:^{
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(37.779432,-122.392166);
        id mockLocation = [OCMockObject mockForClass:[CLLocation class]];
        [[[mockLocation stub] andReturnValue:OCMOCK_VALUE(coordinate)] coordinate];
        [(CLLocation*)[[mockLocation stub] andReturn:[NSDate date]] timestamp];
        CLLocationAccuracy accuracy = 50.f;
        [[[mockLocation stub] andReturnValue:OCMOCK_VALUE(accuracy)] horizontalAccuracy];

        
        [[[SocializeLocationManager origClass] sharedLocationManager] locationManager:nil didUpdateToLocation:mockLocation fromLocation:nil];
    }] startUpdatingLocation];
    
    [[mockLocationManager stub] stopUpdatingLocation];
    
    [[[SocializeLocationManager origClass] sharedLocationManager] setLocationManager:mockLocationManager];
}

- (void)stopMockingSucceedingLocation {
    [[SocializeLocationManager sharedLocationManager] setLocationManager:nil];
    [SocializeLocationManager stopMockingClass];
}

- (void)removeAuthenticationInfo {
    [[Socialize sharedSocialize] removeAuthenticationInfo];
}

@end
