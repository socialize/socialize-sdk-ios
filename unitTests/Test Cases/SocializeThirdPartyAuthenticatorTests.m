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
#import "SocializeProfileEditViewController.h"

@implementation SocializeThirdPartyAuthenticatorTests
@synthesize thirdPartyAuthenticator = thirdPartyAuthenticator_;
@synthesize mockThirdParty = mockThirdParty_;
@synthesize isAuthenticated = isAuthenticated_;
@synthesize hasLocalCredentials = hasLocalCredentials_;
@synthesize authenticationPossible = authenticationPossible_;
@synthesize mockSettings = mockSettings_;

- (id)createAction {
    __block id weakSelf = self;
    
//    return [[[SocializeThirdPartyAuthenticator alloc] initWithDisplayObject:nil
//                                                                    display:self.mockDisplay
//                                                                    options:nil
//                                                                    success:^{
//                                                                        [weakSelf notify:kGHUnitWaitStatusSuccess];
//                                                                    } failure:^(NSError *error) {
//                                                                        [weakSelf notify:kGHUnitWaitStatusFailure];
//                                                                    }] autorelease];
    SocializeThirdPartyAuthenticator *auth = [[[SocializeThirdPartyAuthenticator alloc] initWithOptions:nil display:self.mockDisplay] autorelease];
    auth.successBlock = ^{
        [weakSelf notify:kGHUnitWaitStatusSuccess];
    };
    auth.failureBlock = ^(NSError *error) {
        [weakSelf notify:kGHUnitWaitStatusFailure];
    };
    
    return auth;

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
    
    self.mockSettings = [OCMockObject mockForClass:[SocializeProfileEditViewController class]];
}

- (void)stubBoolsForMockThirdParty:(id)mockThirdParty {
    [[[mockThirdParty stub] andReturnBoolFromBlock:^{ return self.isAuthenticated; }] isLinkedToSocialize];
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
        [self.thirdPartyAuthenticator succeedInteractiveLogin];
        
    }] attemptInteractiveLogin];
}

- (void)expectSocializeAuthenticationAndDo:(void(^)())block {
    [[[self.mockSocialize expect] andDo0:block] authenticateWithThirdPartyAuthType:[self authType]
                                                               thirdPartyAuthToken:OCMOCK_ANY
                                                         thirdPartyAuthTokenSecret:OCMOCK_ANY];

}

- (void)suceedSocializeAuthentication {
    [self expectSocializeAuthenticationAndDo:^{
        self.isAuthenticated = YES;
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

- (void)expectSettingsAndDo:(void(^)(SocializeProfileEditViewController *controller))block {
    [[[self.mockDisplay expect] andDo2:^(id obj, UINavigationController *settingsNav) {
        SocializeProfileEditViewController *settings = (SocializeProfileEditViewController*)[settingsNav topViewController];
        block(settings);
    }] socializeObject:OCMOCK_ANY requiresDisplayOfViewController:OCMOCK_ANY];
}

- (void)expectSettingsAndCancel {
    [self expectSettingsAndDo:^(SocializeProfileEditViewController *settings) {
        [self.thirdPartyAuthenticator baseViewControllerDidCancel:settings];
    }];
}

- (void)expectSettingsAndSave {
    [self expectSettingsAndDo:^(SocializeProfileEditViewController *settings) {
        [self.thirdPartyAuthenticator profileEditViewController:settings didUpdateProfileWithUser:nil];
    }];
}

- (void)expectSettingsAndLogout {
    [self expectSettingsAndDo:^(SocializeProfileEditViewController *settings) {
        self.isAuthenticated = NO;
        [self.thirdPartyAuthenticator profileEditViewController:settings didUpdateProfileWithUser:nil];
    }];    
}

- (void)testCreateDestroy {
//    [self expectDeallocationOfObject:self.thirdPartyAuthenticator fromTest:_cmd];
}

- (void)executeActionAndWaitForStatus:(int)status fromTest:(SEL)test {
    [[self.mockThirdParty expect] removeLocalCredentials];
    [super executeActionAndWaitForStatus:status fromTest:test];
}

- (void)testAuthenticationNotPossibleCausesFailure {
    self.authenticationPossible = NO;
    
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
    
    // Save settings
    [self expectSettingsAndSave];
    
    // Expect success
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

- (void)testLoggingOutOfThirdPartyInSettingsCausesFailure {
    [self.mockDisplay makeNice];
    
    // Initially, local credentials not available
    [self simulateInteractiveAuthConditions];
    
    // Yes, we want to log in
    [self respondToLoginDialogWithAccept:YES];
    
    // Interactive login completes successfully
    [self succeedInteractiveLogin];
    
    // Socialize third party link succeeds
    [self suceedSocializeAuthentication];
    
    // Save settings
    [self expectSettingsAndLogout];
    
    // Expect success
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}


@end
