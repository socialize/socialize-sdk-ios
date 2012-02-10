//
//  SocializeFacebookInterfaceTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/31/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeFacebookInterfaceTests.h"
#import "SocializeFacebookInterface.h"
#import "SocializeFacebook.h"
#import "Socialize.h"
#import "Facebook+Socialize.h"

@interface SocializeFacebookInterface () <SocializeFBRequestDelegate>
@end

@implementation SocializeFacebookInterfaceTests
@synthesize facebookInterface = facebookInterface_;

- (void)setUp {
    self.facebookInterface = [[[SocializeFacebookInterface alloc] init] autorelease];
}

- (void)tearDown {
    self.facebookInterface = nil;
}

- (void)testSuccessfulRequest {
    __block BOOL completed = NO;
    
    id mockFacebook = [OCMockObject mockForClass:[SocializeFacebook class]];
    id mockRequest = [OCMockObject mockForClass:[SocializeFBRequest class]];
    [[[mockFacebook expect] andReturn:mockRequest] requestWithGraphPath:@"some/path" andParams:[NSMutableDictionary dictionary] andHttpMethod:@"METHOD" andDelegate:self.facebookInterface];
    self.facebookInterface.facebook = mockFacebook;
    
    NSDate *exp = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:@"testToken" forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:exp forKey:@"FBExpirationDateKey"];
    [[mockFacebook expect] setAccessToken:@"testToken"];
    [[mockFacebook expect] setExpirationDate:exp];
    
    [self.facebookInterface requestWithGraphPath:@"some/path" params:nil httpMethod:@"METHOD" completion:^(id result, NSError *error) {
        GHAssertNil(error, @"error was not nil");
        completed = YES;
    }];
    [self.facebookInterface request:mockRequest didLoad:nil];
    
    GHAssertTrue(completed, @"block not completed");
    [mockFacebook verify];
}

- (void)testFailedRequest {
    __block BOOL completed = NO;
    
    id mockFacebook = [OCMockObject mockForClass:[SocializeFacebook class]];
    id mockRequest = [OCMockObject mockForClass:[SocializeFBRequest class]];
    [[[mockFacebook expect] andReturn:mockRequest] requestWithGraphPath:@"some/path" andParams:[NSMutableDictionary dictionary] andHttpMethod:@"METHOD" andDelegate:self.facebookInterface];
    self.facebookInterface.facebook = mockFacebook;
    
    NSDate *exp = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:@"testToken" forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:exp forKey:@"FBExpirationDateKey"];
    [[mockFacebook expect] setAccessToken:@"testToken"];
    [[mockFacebook expect] setExpirationDate:exp];

    [self.facebookInterface requestWithGraphPath:@"some/path" params:nil httpMethod:@"METHOD" completion:^(id result, NSError *error) {
        GHAssertNil(result, @"result was not nil");
        completed = YES;
    }];
    [self.facebookInterface request:mockRequest didFailWithError:nil];
    
    GHAssertTrue(completed, @"block not completed");
}

- (void)testFacebookFromSettingsWhenNotAuthenticatedThrowsException {
    [Socialize storeFacebookAppId:@"fb123"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"FBExpirationDateKey"];
    GHAssertThrows((void)self.facebookInterface.facebook, @"Should throw because url is not configured");
}

- (void)testFacebookFromSettingsWhenAuthenticatedIsValid {
    NSString *fbID = @"fb123";
    NSString *fbAccessToken = @"abc";
    NSDate *fbExpirationDate = [NSDate distantFuture];
    
    [Socialize storeFacebookAppId:fbID];
    [[NSUserDefaults standardUserDefaults] setObject:fbAccessToken forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:fbExpirationDate forKey:@"FBExpirationDateKey"];

    SocializeFacebook *facebook = self.facebookInterface.facebook;
    
    GHAssertEqualObjects(facebook.accessToken, fbAccessToken, @"bad token");
    GHAssertEqualObjects(facebook.expirationDate, fbExpirationDate, @"bad token");
}



@end