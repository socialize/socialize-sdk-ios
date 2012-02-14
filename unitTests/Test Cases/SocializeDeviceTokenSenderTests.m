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

- (void)setTokenOnServer:(BOOL)tokenOnServer {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:tokenOnServer] forKey:kSocializeDeviceTokenRegisteredKey];
}

- (void)testThatDeviceTokenResentOnUserChange {
    NSString *testToken = @"FFFF1234";
    
    [[NSUserDefaults standardUserDefaults] setObject:testToken forKey:kSocializeDeviceTokenKey];
    [self setTokenOnServer:YES];
    
    [[self.mockSocialize expect] _registerDeviceTokenString:testToken];
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeAuthenticatedUserDidChangeNotification object:nil];
    
    BOOL registered = [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeDeviceTokenRegisteredKey] boolValue];
    GHAssertFalse(registered, @"Should not be registered");
}

- (void)testThatFailureStartsTimer {
    [self setTokenOnServer:NO];
    
    [[(id)self.deviceTokenSender expect] startTimer];
    
    [self.deviceTokenSender service:nil didFail:nil];
}

- (void)testSuccessfulCreateUpdatesRegisteredStatus {
    NSString *testToken = @"ffff1234";

    [[NSUserDefaults standardUserDefaults] setObject:testToken forKey:kSocializeDeviceTokenKey];
    [self setTokenOnServer:NO];
    
    // Simulate server response with capitalized token string
    SocializeDeviceToken *deviceToken = [[[SocializeDeviceToken alloc] init] autorelease];
    [deviceToken setDevice_token:[testToken uppercaseString]];
    
    [self.deviceTokenSender service:nil didCreate:deviceToken];
    
    BOOL registered = [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeDeviceTokenRegisteredKey] boolValue];
    GHAssertTrue(registered, @"Should be registered");
}

- (void)testSuccessfulCreateWithMismatchedTokenFailsAndStartsTimer {
    NSString *testToken = @"FFFF1234";

    [[NSUserDefaults standardUserDefaults] setObject:testToken forKey:kSocializeDeviceTokenKey];
    [self setTokenOnServer:NO];
    
    SocializeDeviceToken *deviceToken = [[[SocializeDeviceToken alloc] init] autorelease];
    [deviceToken setDevice_token:@"blah"];

    // Timer should start
    [[(id)self.deviceTokenSender expect] startTimer];

    [self.deviceTokenSender service:nil didCreate:deviceToken];
    
    BOOL registered = [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeDeviceTokenRegisteredKey] boolValue];
    GHAssertFalse(registered, @"Should not be registered");
}

- (void)testDeviceTokenRegistration {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"kSocializeDeviceTokenRegisteredKey"];
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
    [self setTokenOnServer:YES];
    
    // Should invalidate
    [[mockTimer expect] invalidate];

    [self.deviceTokenSender timerCheck];
    [mockTimer verify];
}

@end
