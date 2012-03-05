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
@synthesize mockThirdPartyFacebook = mockThirdPartyFacebook_;
@synthesize accessToken = accessToken_;
@synthesize expirationDate = expirationDate_;

- (id)createAction {
    __block id weakSelf = self;
    
    return [[[SocializeFacebookAuthenticator alloc] initWithDisplayObject:nil
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

- (NSInteger)authType {
    return SocializeThirdPartyAuthTypeFacebook;
}

- (void)setUp {
    [super setUp];
    
    self.facebookAuthenticator  = (SocializeFacebookAuthenticator*)self.action;
    
    self.mockFacebookAuthHandler = [OCMockObject mockForClass:[SocializeFacebookAuthHandler class]];
    self.facebookAuthenticator.facebookAuthHandler = self.mockFacebookAuthHandler;
    
    self.mockThirdPartyFacebook = [OCMockObject classMockForClass:[SocializeThirdPartyFacebook class]];
    self.facebookAuthenticator.thirdParty = self.mockThirdPartyFacebook;

    [self stubBoolsForMockThirdParty:self.mockThirdPartyFacebook];
    
    [[[self.mockThirdPartyFacebook stub] andReturn:@"Facebook"] thirdPartyName];
    [[[self.mockThirdPartyFacebook stub] andReturn:@"AppID"] facebookAppId];
    [[[self.mockThirdPartyFacebook stub] andReturn:nil] facebookUrlSchemeSuffix];
    [[[self.mockThirdPartyFacebook stub] andReturnInteger:SocializeThirdPartyAuthTypeFacebook] socializeAuthType];
    
    [[[self.mockThirdPartyFacebook stub] andReturn:self.accessToken] socializeAuthToken];
    [[[self.mockThirdPartyFacebook stub] andReturn:self.accessToken] facebookAccessToken];
    [[[self.mockThirdPartyFacebook stub] andReturn:self.expirationDate] facebookExpirationDate];
    [[[self.mockThirdPartyFacebook stub] andReturn:nil] socializeAuthTokenSecret];
}

- (void)tearDown {
    [self.mockFacebookAuthHandler verify];
    [self.mockThirdPartyFacebook verify];
    
    self.facebookAuthenticator = nil;
    self.mockFacebookAuthHandler = nil;
    self.mockThirdPartyFacebook = nil;
    self.expirationDate = nil;
    self.accessToken = nil;
    
    [super tearDown];
}

- (void)succeedInteractiveFacebookLogin {
    NSString *token = @"token";
    NSDate *expirationDate = [NSDate distantFuture];
    
    [[self.mockThirdPartyFacebook expect]
     storeLocalCredentialsWithAccessToken:token expirationDate:expirationDate];
    
    [[[self.mockFacebookAuthHandler expect] andDo5:^(id appId, id suffix, id perms, id success, id failure) {
        self.hasLocalCredentials = YES;
        void (^successBlock)(NSString *accessToken, NSDate *expirationDate) = success;
        successBlock(token, expirationDate);
    }] authenticateWithAppId:OCMOCK_ANY urlSchemeSuffix:OCMOCK_ANY permissions:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)testSuccessfulInteractiveLogin {
    [self.mockDisplay makeNice];
    
    // Initially, local credentials not available
    [self simulateInteractiveAuthConditions];
    
    // Yes, we want to log in
    [self respondToLoginDialogWithAccept:YES];
    
    // Interactive login completes successfully
    [self succeedInteractiveFacebookLogin];
    
    // Socialize third party link succeeds
    [self suceedSocializeAuthentication];
    
    // Expect success
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

@end
