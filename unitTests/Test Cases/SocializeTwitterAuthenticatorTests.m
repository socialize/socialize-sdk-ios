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
    
    self.twitterAuthenticator = (SocializeTwitterAuthenticator*)self.action;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"consumerKey" forKey:kSocializeTwitterAuthConsumerKey];
    [[NSUserDefaults standardUserDefaults] setObject:@"consumerSecret" forKey:kSocializeTwitterAuthConsumerSecret];
}

- (void)tearDown {
    [super tearDown];
    
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

- (void)simulateInteractiveAuthConditions {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSocializeTwitterAuthAccessToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSocializeTwitterAuthAccessTokenSecret];
}

- (void)succeedInteractiveTwitterLogin {
    [[[self.mockDisplay expect] andDo2:^(id obj, SocializeTwitterAuthViewController *twitterAuth) {
        
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