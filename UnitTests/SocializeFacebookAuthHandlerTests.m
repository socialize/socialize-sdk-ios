//
//  SocializeFacebookAuthHandlerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeFacebookAuthHandlerTests.h"
#import "SocializeCommonDefinitions.h"
#import "NSError+Socialize.h"

@implementation SocializeFacebookAuthHandlerTests
@synthesize facebookAuthHandler = facebookAuthHandler_;
@synthesize mockFacebookClass = mockFacebookClass_;
@synthesize mockFacebook = mockFacebook_;

- (void)setUp {
    self.facebookAuthHandler = [[[SocializeFacebookAuthHandler alloc] init] autorelease];
    
    self.mockFacebookClass = [OCMockObject classMockForClass:[Facebook class]];
    [Facebook startMockingClass];
    
    self.mockFacebook = [OCMockObject niceMockForClass:[Facebook class]];
    
    [super setUp];
}

- (void)tearDown {
    [Facebook stopMockingClassAndVerify];
    
    self.facebookAuthHandler = nil;
    
    [super tearDown];
}

- (void)expectFacebookCreation {
    [[[Facebook expect] andReturnFromBlock:^{ return [self.mockFacebook retain]; }] alloc];
    [[[self.mockFacebook expect] andReturn:self.mockFacebook] initWithAppId:OCMOCK_ANY urlSchemeSuffix:OCMOCK_ANY andDelegate:OCMOCK_ANY];
}

- (void)attemptAuthenticationWithSuccess:(void(^)(NSString *accessToken, NSDate *expirationDate))success failure:(void(^)(NSError *error))failure {
    [self expectFacebookCreation];
    [self.facebookAuthHandler authenticateWithAppId:nil
                                    urlSchemeSuffix:nil
                                        permissions:nil
                                            success:success
                                         foreground:nil
                                            failure:failure];
}

- (void)attemptAuthenticationAndWaitForStatus:(int)status {
    [self prepare];
    [self attemptAuthenticationWithSuccess:^(NSString *token, NSDate *expirationDate) {
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    
    [self waitForStatus:status timeout:1];
}

- (void)respondToFacebookAuthWithBlock:(void(^)())block {
    [[[self.mockFacebook expect] andDo0:block] authorize:OCMOCK_ANY];
}

- (void)succeedFacebookAuthentication {
    NSURL *testURL = [NSURL URLWithString:@"testURL"];
    // Simulate safari finishing and handleOpenURL being called on return
    [self respondToFacebookAuthWithBlock:^{
        [self.facebookAuthHandler handleOpenURL:testURL];
    }];
    
    // Succeed and call delegate fbDidLogin if handleOpenURL is sent to facebook instance
    [[[self.mockFacebook expect] andDo0:^{
        [self.facebookAuthHandler fbDidLogin];
    }] handleOpenURL:testURL];
}
     

- (void)failFacebookAuthentication {
    // Simulate failure
    [self respondToFacebookAuthWithBlock:^{
        [self.facebookAuthHandler fbDidNotLogin:YES];
    }];
}

- (void)ignoreFacebookAuthentication {
    [[self.mockFacebook expect] authorize:OCMOCK_ANY];
}

- (void)testSuccessfulAuthenticationCallsSuccessHandler {
    [self succeedFacebookAuthentication];
    [self attemptAuthenticationAndWaitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)testFailedAuthenticationCallsFailureHandler {
    [self failFacebookAuthentication];
    [self attemptAuthenticationAndWaitForStatus:kGHUnitWaitStatusFailure];
}

- (void)testSharedHandler {
    SocializeFacebookAuthHandler *handler = [SocializeFacebookAuthHandler sharedFacebookAuthHandler];
    GHAssertNotNil(handler, @"");
}


@end
