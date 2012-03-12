//
//  SocializeFacebookAuthenticatorTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeFacebookAuthenticatorTests.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeFacebookAuthHandler.h"

@implementation SocializeFacebookAuthenticatorTests
@synthesize facebookAuthenticator = facebookAuthenticator_;
@synthesize mockFacebookAuthHandler = mockFacebookAuthHandler_;
@synthesize accessToken = accessToken_;
@synthesize expirationDate = expirationDate_;

- (id)createAction {
    __block id weakSelf = self;
    
//    return [[[SocializeFacebookAuthenticator alloc] initWithDisplayObject:nil
//                                                                 display:self.mockDisplay
//                                                                 options:nil
//                                                                 success:^{
//                                                                     [weakSelf notify:kGHUnitWaitStatusSuccess];
//                                                                 } failure:^(NSError *error) {
//                                                                     [weakSelf notify:kGHUnitWaitStatusFailure];
//                                                                 }] autorelease];
    
    SocializeFacebookAuthenticator *auth = [[[SocializeFacebookAuthenticator alloc] initWithOptions:nil display:self.mockDisplay] autorelease];
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

- (NSInteger)authType {
    return SocializeThirdPartyAuthTypeFacebook;
}

- (void)setUp {
    [super setUp];
    
    [SocializeThirdPartyFacebook startMockingClass];
    
    self.facebookAuthenticator  = (SocializeFacebookAuthenticator*)self.action;
    
    self.mockFacebookAuthHandler = [OCMockObject mockForClass:[SocializeFacebookAuthHandler class]];
    self.facebookAuthenticator.facebookAuthHandler = self.mockFacebookAuthHandler;
    
    self.mockThirdParty = [SocializeThirdPartyFacebook classMock];
    self.thirdPartyAuthenticator.thirdParty = self.mockThirdParty;

    [self stubBoolsForMockThirdParty:self.mockThirdParty];
    
    [[[SocializeThirdPartyFacebook stub] andReturn:@"Facebook"] thirdPartyName];
    [[[SocializeThirdPartyFacebook stub] andReturn:@"AppID"] facebookAppId];
    [[[SocializeThirdPartyFacebook stub] andReturn:nil] facebookUrlSchemeSuffix];
    [[[SocializeThirdPartyFacebook stub] andReturnInteger:SocializeThirdPartyAuthTypeFacebook] socializeAuthType];
    
    [[[SocializeThirdPartyFacebook stub] andReturn:self.accessToken] socializeAuthToken];
    [[[SocializeThirdPartyFacebook stub] andReturn:self.accessToken] facebookAccessToken];
    [[[SocializeThirdPartyFacebook stub] andReturn:self.expirationDate] facebookExpirationDate];
    [[[SocializeThirdPartyFacebook stub] andReturn:nil] socializeAuthTokenSecret];
    Class realFacebook = [SocializeThirdPartyFacebook origClass];
    [[[SocializeThirdPartyFacebook stub] andReturn:[realFacebook userAbortedAuthError]] userAbortedAuthError];
}

- (void)tearDown {
    [self.mockFacebookAuthHandler verify];
    
    self.facebookAuthenticator = nil;
    self.mockFacebookAuthHandler = nil;
    self.expirationDate = nil;
    self.accessToken = nil;
    [SocializeThirdPartyFacebook stopMockingClassAndVerify];

    [super tearDown];

}

- (void)succeedInteractiveFacebookLogin {
    NSString *token = @"token";
    NSDate *expirationDate = [NSDate distantFuture];
    
    [[SocializeThirdPartyFacebook expect]
     storeLocalCredentialsWithAccessToken:token expirationDate:expirationDate];
    
    [[[self.mockFacebookAuthHandler expect] andDo5:^(id appId, id suffix, id perms, id success, id failure) {
        self.hasLocalCredentials = YES;
        void (^successBlock)(NSString *accessToken, NSDate *expirationDate) = success;
        successBlock(token, expirationDate);
    }] authenticateWithAppId:OCMOCK_ANY urlSchemeSuffix:OCMOCK_ANY permissions:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)succeedToSettings {
    [self.mockDisplay makeNice];
    
    // Initially, local credentials not available
    [self simulateInteractiveAuthConditions];
    
    // Yes, we want to log in
    [self respondToLoginDialogWithAccept:YES];
    
    // Interactive login completes successfully
    [self succeedInteractiveFacebookLogin];
    
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
