//
//  SocializeDeviceTokenSenderTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeDeviceTokenSenderTests.h"
#import "_Socialize.h"
#import "SocializePrivateDefinitions.h"

@interface SocializeDeviceTokenSender ()
- (void)startTimer;
- (void)timerCheck;
@property (nonatomic, assign) BOOL tokenOnServer;
@end

@implementation SocializeDeviceTokenSenderTests
@synthesize deviceTokenSender = deviceTokenSender_;
@synthesize mockSocialize = mockSocialize_;

- (void)setUp {
    self.deviceTokenSender = [[[SocializeDeviceTokenSender alloc] init] autorelease];
    self.deviceTokenSender = [OCMockObject partialMockForObject:self.deviceTokenSender];
    
    // Mock Socialize
    self.mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    [[self.mockSocialize stub] setDelegate:nil];
    self.deviceTokenSender.socialize = self.mockSocialize;
}

- (void)tearDown {
    [self.mockSocialize verify];
    self.mockSocialize = nil;
    self.deviceTokenSender = nil;
}

- (void)testThatDeviceTokenResentOnUserChange {
    NSString *testToken = @"FFFF1234";
    
    [[NSUserDefaults standardUserDefaults] setObject:testToken forKey:kSocializeDeviceTokenKey];
    self.deviceTokenSender.tokenOnServer = YES;
    
    [[self.mockSocialize expect] _registerDeviceTokenString:testToken];
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeAuthenticatedUserDidChangeNotification object:nil];
    
    BOOL registered = self.deviceTokenSender.tokenOnServer;
    GHAssertFalse(registered, @"Should not be registered");
}

- (void)testThatFailureStartsTimer {
    self.deviceTokenSender.tokenOnServer = NO;
    
    [[(id)self.deviceTokenSender expect] startTimer];
    
    [self.deviceTokenSender service:nil didFail:nil];
}

- (void)testSuccessfulCreateUpdatesRegisteredStatus {
    NSString *testToken = @"ffff1234";

    [[NSUserDefaults standardUserDefaults] setObject:testToken forKey:kSocializeDeviceTokenKey];
    self.deviceTokenSender.tokenOnServer = NO;

    
    // Simulate server response with capitalized token string
    SocializeDeviceToken *deviceToken = [[[SocializeDeviceToken alloc] init] autorelease];
    [deviceToken setDevice_token:[testToken uppercaseString]];
    
    [self.deviceTokenSender service:nil didCreate:deviceToken];
    
    GHAssertTrue(self.deviceTokenSender.tokenOnServer, @"Should be registered");
}

- (void)testSuccessfulCreateWithMismatchedTokenFailsAndStartsTimer {
    NSString *testToken = @"FFFF1234";

    [[NSUserDefaults standardUserDefaults] setObject:testToken forKey:kSocializeDeviceTokenKey];
    self.deviceTokenSender.tokenOnServer = NO;
    
    SocializeDeviceToken *deviceToken = [[[SocializeDeviceToken alloc] init] autorelease];
    [deviceToken setDevice_token:@"blah"];

    // Timer should start
    [[(id)self.deviceTokenSender expect] startTimer];

    [self.deviceTokenSender service:nil didCreate:deviceToken];
    
    GHAssertFalse(self.deviceTokenSender.tokenOnServer, @"Should not be registered");
}

- (void)testDeviceTokenRegistration {
    self.deviceTokenSender.tokenOnServer = NO;
    char testTokenData[2] = "\xaa\xff";
    NSData *testToken = [NSData dataWithBytes:&testTokenData length:sizeof(testTokenData)];
    NSString *testTokenString = @"aaff";

    [[self.mockSocialize expect] _registerDeviceTokenString:testTokenString];
    [self.deviceTokenSender registerDeviceToken:testToken];
}

- (void)testTokenAvailableWhenSet {
    NSString *testToken = @"FFFF1234";
    [[NSUserDefaults standardUserDefaults] setObject:testToken forKey:kSocializeDeviceTokenKey];

    BOOL available = [self.deviceTokenSender tokenAvailable];
    GHAssertTrue(available, @"should be available");
}

- (void)testTimerCheckInvalidatesTimerIfNotNeeded {
    id mockTimer = [OCMockObject mockForClass:[NSTimer class]];
    self.deviceTokenSender.timer = mockTimer;

    // Token already sent
    self.deviceTokenSender.tokenOnServer = YES;
    
    // Should invalidate
    [[mockTimer expect] invalidate];

    [self.deviceTokenSender timerCheck];
    [mockTimer verify];
}

- (void)expectRegistrationAndSucceed {
    [[[self.mockSocialize expect] andDo:^(NSInvocation *inv) {
        NSString *deviceTokenString;
        [inv getArgument:&deviceTokenString atIndex:2];
        SocializeDeviceToken *deviceToken = [[[SocializeDeviceToken alloc] init] autorelease];
        [deviceToken setDevice_token:deviceTokenString];
        [self.deviceTokenSender service:nil didCreate:deviceToken];
    }] _registerDeviceTokenString:OCMOCK_ANY];
}

- (void)testSendingMultipleTokens {
    char testTokenData1[2] = "\x11\x22";
    NSData *testToken1 = [NSData dataWithBytes:&testTokenData1 length:sizeof(testTokenData1)];

    char testTokenData2[2] = "\xbb\xee";
    NSString *testTokenString2 = @"bbee";
    NSData *testToken2 = [NSData dataWithBytes:&testTokenData2 length:sizeof(testTokenData2)];

    [self expectRegistrationAndSucceed];
    
    [[self.mockSocialize expect] _registerDeviceTokenString:testTokenString2];
    
    [self.deviceTokenSender registerDeviceToken:testToken1];
    [self.deviceTokenSender registerDeviceToken:testToken2];
}

@end
