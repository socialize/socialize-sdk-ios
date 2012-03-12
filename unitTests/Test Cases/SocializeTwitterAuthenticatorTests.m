//
//  SocializeTwitterAuthenticatorTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeTwitterAuthenticatorTests.h"
#import "OCMock/OCMock.h"
#import "SocializeTwitterAuthenticator.h"
#import "SocializeTwitterAuthViewController.h"
#import "UIViewController+Socialize.h"
#import "_Socialize.h"
#import "SocializeUIDisplayProxy.h"
#import "SocializeTwitterAuthViewControllerDelegate.h"
#import "SocializeThirdPartyTwitter.h"

@implementation SocializeTwitterAuthenticatorTests
@synthesize twitterAuthenticator = twitterAuthenticator_;
@synthesize mockSocialize = mockSocialize_;

- (id)createAction {
    __block id weakSelf = self;
    
    SocializeTwitterAuthenticator *auth = [[[SocializeTwitterAuthenticator alloc] initWithOptions:nil display:self.mockDisplay] autorelease];
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
    
    [SocializeThirdPartyTwitter startMockingClass];
    
    self.mockThirdParty = [SocializeThirdPartyTwitter classMock];
    [self stubBoolsForMockThirdParty:[SocializeThirdPartyTwitter classMock]];
    [[[SocializeThirdPartyTwitter stub] andReturn:@"Twitter"] thirdPartyName];
    [[[SocializeThirdPartyTwitter stub] andReturn:@"token"] accessToken];
    [[[SocializeThirdPartyTwitter stub] andReturn:@"token"] socializeAuthToken];
    [[[SocializeThirdPartyTwitter stub] andReturn:@"secret"] accessTokenSecret];
    [[[SocializeThirdPartyTwitter stub] andReturn:@"secret"] socializeAuthTokenSecret];
    [[[SocializeThirdPartyTwitter stub] andReturn:@"consumerKey"] consumerKey];
    [[[SocializeThirdPartyTwitter stub] andReturn:@"consumerSecret"] consumerSecret];

    [[[SocializeThirdPartyTwitter stub] andReturnInteger:SocializeThirdPartyAuthTypeTwitter] socializeAuthType];
    
    Class realTwitter = [SocializeThirdPartyTwitter origClass];
    [[[SocializeThirdPartyTwitter stub] andReturn:[realTwitter userAbortedAuthError]] userAbortedAuthError];

    self.twitterAuthenticator = (SocializeTwitterAuthenticator*)self.action;
}

- (void)tearDown {
    [super tearDown];
    
    [SocializeThirdPartyTwitter stopMockingClassAndVerify];
    
    self.twitterAuthenticator = nil;
}

- (void)testCreateDestroy {
    [self expectDeallocationOfObject:self.twitterAuthenticator fromTest:_cmd];
}

- (void)testThirdPartyImplemented {
    Class thirdParty = [self.twitterAuthenticator thirdParty];
    GHAssertNotNil(thirdParty, @"third party not found");
}

- (int)authType {
    return SocializeThirdPartyAuthTypeTwitter;
}

- (void)succeedInteractiveTwitterLogin {
    [[[self.mockDisplay expect] andDo2:^(id obj, UINavigationController *twitterNav) {
        
        SocializeTwitterAuthViewController *twitterAuth = (SocializeTwitterAuthViewController*)[twitterNav topViewController];
        
        [[[SocializeThirdPartyTwitter expect] andDo0:^{
            self.hasLocalCredentials = YES;
        }] storeLocalCredentialsWithAccessToken:OCMOCK_ANY accessTokenSecret:OCMOCK_ANY];
        
        // Credentials should now be available
        [self.twitterAuthenticator twitterAuthViewController:twitterAuth
                                       didReceiveAccessToken:@"mytoken"
                                           accessTokenSecret:@"mysecret"
                                                  screenName:nil
                                                      userID:nil];
        
        [self.twitterAuthenticator baseViewControllerDidFinish:twitterAuth];
        
    }] socializeObject:OCMOCK_ANY requiresDisplayOfViewController:OCMOCK_ANY];
}

- (void)succeedToSettings {
    [self.mockDisplay makeNice];
    
    // Initially, local credentials not available
    [self simulateInteractiveAuthConditions];
    
    // Yes, we want to log in
    [self respondToLoginDialogWithAccept:YES];
    
    // Interactive login completes successfully
    [self succeedInteractiveTwitterLogin];
    
    // Socialize third party link succeeds
    [self suceedSocializeAuthentication];
}

- (void)testSuccessfulInteractiveLogin {
    [self succeedToSettings];
    
    // Save settings
    [self expectSettingsAndSave];
    
    // Expect success
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

- (void)testLoggingOutOfThirdPartyInSettingsCausesFailure {
    [self succeedToSettings];
    
    // Save settings
    [self expectSettingsAndLogout];
    
    // Expect success
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}


     
@end