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
    
    return [[[SocializeTwitterAuthenticator alloc] initWithDisplayObject:nil
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
    
    [SocializeThirdPartyTwitter startMockingClass];
    
    [self stubBoolsForMockThirdParty:[SocializeThirdPartyTwitter classMock]];
    [[[SocializeThirdPartyTwitter stub] andReturn:@"Twitter"] thirdPartyName];
    [[[SocializeThirdPartyTwitter stub] andReturn:@"token"] accessToken];
    [[[SocializeThirdPartyTwitter stub] andReturn:@"token"] socializeAuthToken];
    [[[SocializeThirdPartyTwitter stub] andReturn:@"secret"] accessTokenSecret];
    [[[SocializeThirdPartyTwitter stub] andReturn:@"secret"] socializeAuthTokenSecret];

    [[[SocializeThirdPartyTwitter stub] andReturnInteger:SocializeThirdPartyAuthTypeTwitter] socializeAuthType];
    
    
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
    [[[self.mockDisplay expect] andDo2:^(id obj, SocializeTwitterAuthViewController *twitterAuth) {
        
        [[[SocializeThirdPartyTwitter expect] andDo0:^{
            self.hasLocalCredentials = YES;
        }] storeLocalCredentialsWithAccessToken:OCMOCK_ANY accessTokenSecret:OCMOCK_ANY screenName:OCMOCK_ANY userId:OCMOCK_ANY];
        
        // Credentials should now be available
        [self.twitterAuthenticator twitterAuthViewController:twitterAuth
                                       didReceiveAccessToken:@"mytoken"
                                           accessTokenSecret:@"mysecret"
                                                  screenName:nil
                                                      userID:nil];
        
        [self.twitterAuthenticator baseViewControllerDidFinish:twitterAuth];
        
    }] socializeObject:OCMOCK_ANY requiresDisplayOfViewController:OCMOCK_ANY];
}

- (void)testSuccessfulInteractiveLogin {
    [self.mockDisplay makeNice];
    
    // Initially, local credentials not available
    [self simulateInteractiveAuthConditions];
    
    // Yes, we want to log in
    [self respondToLoginDialogWithAccept:YES];
    
    // Interactive login completes successfully
    [self succeedInteractiveTwitterLogin];
    
    // Socialize third party link succeeds
    [self suceedSocializeAuthentication];
    
    // Expect success
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

     
@end