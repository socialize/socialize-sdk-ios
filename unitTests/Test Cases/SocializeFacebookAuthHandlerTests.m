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
    
    self.mockFacebookClass = [OCMockObject classMockForClass:[SocializeFacebook class]];
    self.facebookAuthHandler.facebookClass = self.mockFacebookClass;
    
    self.mockFacebook = [OCMockObject niceMockForClass:[SocializeFacebook class]];
    
    [super setUp];
}

- (void)tearDown {
    self.facebookAuthHandler = nil;
    
    [super tearDown];
}

- (void)expectFacebookCreation {
    [self.mockFacebookClass expectAllocAndReturn:self.mockFacebook];
    [[[self.mockFacebook expect] andReturn:self.mockFacebook] initWithAppId:OCMOCK_ANY];
}

- (void)attemptAuthenticationWithSuccess:(void(^)(NSString *accessToken, NSDate *expirationDate))success failure:(void(^)(NSError *error))failure {
    [self expectFacebookCreation];
    [self.facebookAuthHandler authenticateWithAppId:nil
                                    urlSchemeSuffix:nil
                                        permissions:nil
                                            success:success
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
    [[[self.mockFacebook expect] andDo0:block] authorize:OCMOCK_ANY delegate:OCMOCK_ANY localAppId:OCMOCK_ANY];
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
    [[self.mockFacebook expect] authorize:OCMOCK_ANY delegate:OCMOCK_ANY localAppId:OCMOCK_ANY];
}

- (void)testSuccessfulAuthenticationCallsSuccessHandler {
    [self succeedFacebookAuthentication];
    [self attemptAuthenticationAndWaitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)testFailedAuthenticationCallsFailureHandler {
    [self failFacebookAuthentication];
    [self attemptAuthenticationAndWaitForStatus:kGHUnitWaitStatusFailure];
}

- (void)testSecondAuthAttemptCausesErrorButStillRetries {
    
    [self ignoreFacebookAuthentication];
    [self attemptAuthenticationWithSuccess:^(NSString *accessToken, NSDate *expirationDate) {
        GHAssertTrue(NO, @"should not be called");
    } failure:^(NSError *error) {
        GHAssertTrue([error isSocializeErrorWithCode:SocializeErrorFacebookAuthRestarted], @"unexpected error");
        // This is the failure block that should be called after second attempt
        [self notify:kGHUnitWaitStatusFailure];
    }];
    
    [self prepare];
    [self ignoreFacebookAuthentication];
    [self attemptAuthenticationWithSuccess:^(NSString *accessToken, NSDate *expirationDate) {
        GHAssertTrue(NO, @"should not be called");
    } failure:^(NSError *error) {
        GHAssertTrue(NO, @"should not be called");
    }];
    
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:1.0];

}

- (void)testSharedHandler {
    SocializeFacebookAuthHandler *handler = [SocializeFacebookAuthHandler sharedFacebookAuthHandler];
    GHAssertNotNil(handler, @"");
}


@end
