//
//  SocializeThirdPartyAuthenticatorTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/1/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeThirdPartyAuthenticatorTests.h"
#import "SocializeThirdParty.h"
#import "NSError+Socialize.h"
#import "SocializeUIDisplay.h"
#import "_Socialize.h"
#import "SocializeServiceDelegate.h"

@implementation SocializeThirdPartyAuthenticatorTests
@synthesize thirdPartyAuthenticator = thirdPartyAuthenticator_;
@synthesize mockThirdParty = mockThirdParty_;
@synthesize isAuthenticated = isAuthenticated_;
@synthesize hasLocalCredentials = hasLocalCredentials_;
@synthesize authenticationPossible = authenticationPossible_;

- (id)createAction {
    __block id weakSelf = self;
    
    return [[[SocializeThirdPartyAuthenticator alloc] initWithDisplayObject:nil
                                                                    display:self.mockDisplay
                                                                    options:nil
                                                                    success:^{
                                                                        [weakSelf notify:kGHUnitWaitStatusSuccess];
                                                                    } failure:^(NSError *error) {
                                                                        [weakSelf notify:kGHUnitWaitStatusFailure];
                                                                    }] autorelease];
}

- (BOOL)shouldRunOnMainThread {
    return YES;
}

- (void)setUp {
    [super setUp];
    
    self.thirdPartyAuthenticator = (SocializeThirdPartyAuthenticator*)self.action;

    self.mockThirdParty = [OCMockObject classMockForProtocol:@protocol(SocializeThirdParty)];
    self.thirdPartyAuthenticator.thirdParty = self.mockThirdParty;
    
    [[[self.mockThirdParty stub] andReturn:@"My Third Party"] thirdPartyName];
    
    [[[self.mockThirdParty stub] andReturnFromBlock:^{
        id mockError = [OCMockObject mockForClass:[NSError class]];
        return mockError;
    }] thirdPartyUnavailableError];

    [[[self.mockThirdParty stub] andReturnFromBlock:^{
        id mockError = [OCMockObject mockForClass:[NSError class]];
        return mockError;
    }] userAbortedAuthError];

    [self stubBoolsForMockThirdParty:self.mockThirdParty];
    
    [[[self.mockThirdParty stub] andReturnInteger:[self authType]] socializeAuthType];
}

- (void)stubBoolsForMockThirdParty:(id)mockThirdParty {
    [[[mockThirdParty stub] andReturnBoolFromBlock:^{ return self.isAuthenticated; }] isAuthenticated];
    [[[mockThirdParty stub] andReturnBoolFromBlock:^{ return self.hasLocalCredentials; }] hasLocalCredentials];
    [[[mockThirdParty stub] andReturnBoolFromBlock:^{ return self.authenticationPossible; }] available];
}

- (NSInteger)authType {
    return 0xfeedface;
}

- (void)tearDown {
    [self.mockThirdParty verify];
    
    self.mockThirdParty = nil;
    self.thirdPartyAuthenticator = nil;
    
    [super tearDown];
}

- (void)respondToLoginDialogWithAccept:(BOOL)accept {
    [[[self.mockDisplay expect] andDo2:^(id obj, UIAlertView *alertView) {
        int buttonIndex = accept ? 1 : 0;
        [alertView simulateButtonPressAtIndex:buttonIndex];
    }] socializeObject:OCMOCK_ANY requiresDisplayOfAlertView:OCMOCK_ANY];
}

- (void)simulateLocalCredentials {
    self.hasLocalCredentials = YES;
    [[[self.mockThirdParty stub] andReturn:@"My Access Token"] socializeAuthToken];
    [[[self.mockThirdParty stub] andReturn:@"My Access Token Secret"] socializeAuthTokenSecret];
}

- (void)succeedInteractiveLogin {
    [[[self.partialAction expect] andDo0:^{
        
        // Credentials should now be available
        [self simulateLocalCredentials];
        
        // Finish off the auth process
        [self.thirdPartyAuthenticator tryToFinishAuthenticating];
        
    }] attemptInteractiveLogin];
}

- (void)expectSocializeAuthenticationAndDo:(void(^)())block {
    [[[self.mockSocialize expect] andDo0:block] authenticateWithThirdPartyAuthType:[self authType]
                                                               thirdPartyAuthToken:OCMOCK_ANY
                                                         thirdPartyAuthTokenSecret:OCMOCK_ANY];

}

- (void)suceedSocializeAuthentication {
    [self expectSocializeAuthenticationAndDo:^{
        [self.thirdPartyAuthenticator didAuthenticate:nil];
    }];
}

- (void)failSocializeAuthWithError:(NSError*)error {
    [self expectSocializeAuthenticationAndDo:^{
        [self.thirdPartyAuthenticator service:nil didFail:error];
    }];
}

- (void)failSocializeAuthWithHTTPStatusCode:(int)statusCode {
    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    [[[mockResponse stub] andReturnInteger:statusCode] statusCode];
    [self failSocializeAuthWithError:[NSError socializeServerReturnedHTTPErrorErrorWithResponse:mockResponse responseBody:@""]];
}

- (void)simulateAutoAuthConditions {
    self.isAuthenticated = NO;
    self.authenticationPossible = YES;
    [self simulateLocalCredentials];
}

- (void)simulateInteractiveAuthConditions {
    self.isAuthenticated = NO;
    self.hasLocalCredentials = NO;
    self.authenticationPossible = YES;
}

- (void)testCreateDestroy {
//    [self expectDeallocationOfObject:self.thirdPartyAuthenticator fromTest:_cmd];
}

- (void)testAuthenticationNotPossibleCausesFailure {
    self.authenticationPossible = NO;
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testAutoAuthSuccess {
    [self.mockDisplay makeNice];
    
    [self simulateAutoAuthConditions];

    [self suceedSocializeAuthentication];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

- (void)autoAuthCredentialsWipeTestWithStatusCode:(int)statusCode {
    [self.mockDisplay makeNice];
    
    [self simulateAutoAuthConditions];
    
    [[[self.mockThirdParty expect] andDo0:^{
        self.hasLocalCredentials = NO;
    }] removeLocalCredentials];
    
    // Simulate the 401
    [self failSocializeAuthWithHTTPStatusCode:statusCode];
    
    // Cancel auth
    [self respondToLoginDialogWithAccept:NO];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testAutoAuthFailureWith401WipesCredentialsAndOpensDialog {
    [self autoAuthCredentialsWipeTestWithStatusCode:401];
}

- (void)testAutoAuthFailureWith403WipesCredentialsAndOpensDialog {
    [self autoAuthCredentialsWipeTestWithStatusCode:403];
}

- (void)testAutoAuthFailureWith400CausesFailure {
    [self.mockDisplay makeNice];
    
    [self simulateAutoAuthConditions];
    
    // Simulate the 400
    [self failSocializeAuthWithHTTPStatusCode:400];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testSuccessfulInteractiveLogin {
    [self.mockDisplay makeNice];
    
    // Initially, local credentials not available
    [self simulateInteractiveAuthConditions];
    
    // Yes, we want to log in
    [self respondToLoginDialogWithAccept:YES];
    
    // Interactive login completes successfully
    [self succeedInteractiveLogin];
    
    // Socialize third party link succeeds
    [self suceedSocializeAuthentication];
    
    // Expect success
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

@end
