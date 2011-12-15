//
//  SocializeDeviceTokenServiceTests.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/13/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeDeviceTokenServiceTests.h"
#import "SocializeDeviceToken.h"
#import <OCMock/OCMock.h>

@implementation SocializeDeviceTokenServiceTests

@synthesize deviceTokenService = deviceTokenService_;
@synthesize partialDeviceTokenService = partialDeviceTokenService_;
@synthesize mockRegisterDeviceTimer = mockRegisterDeviceTimer_;
@synthesize mockDeviceTokenString = mockDeviceTokenString_;
@synthesize mockDeviceToken = mockDeviceToken_;

-(void)setUp {
    self.deviceTokenService = [[SocializeDeviceTokenService alloc] init];
    self.partialDeviceTokenService = [OCMockObject partialMockForObject:self.deviceTokenService];
    //create a mock timer and assign it to the token service
    self.mockRegisterDeviceTimer = [OCMockObject mockForClass:[NSTimer class]];
    self.deviceTokenService.registerDeviceTimer = self.mockRegisterDeviceTimer;
    self.mockDeviceTokenString = [OCMockObject niceMockForClass:[NSString class]];
    self.mockDeviceToken = [OCMockObject niceMockForProtocol:@protocol(SocializeDeviceToken)];
    [self.mockDeviceToken setDevice_token:self.mockDeviceTokenString];
}
-(void)tearDown {
    //first we need to verify 
    [self.partialDeviceTokenService verify];
    [self.mockRegisterDeviceTimer verify];
    [self.mockDeviceTokenString verify];
    [self.mockDeviceToken verify];
    
    //deallocate the objects from memory
    self.deviceTokenService = nil;
    self.partialDeviceTokenService = nil;
    self.mockRegisterDeviceTimer = nil;
    self.mockDeviceTokenString = nil;
    self.mockDeviceToken = nil;
}
-(void)testShouldRegisterDeviceToken {
    [[[self.partialDeviceTokenService expect] andReturn:self.mockDeviceTokenString] getDeviceToken];
    BOOL shouldRegister = [self.deviceTokenService shouldRegisterDeviceToken:self.mockDeviceTokenString];
    GHAssertTrue(shouldRegister, @"should register should have returned true");
}

-(void)invokeAppropriateCallback {
    NSArray *objectList = [NSArray arrayWithObject:self.mockDeviceToken];
    [[[self.partialDeviceTokenService expect] andReturn:objectList] getObjectListArray:OCMOCK_ANY];
    [self.deviceTokenService invokeAppropriateCallback:nil objectList:nil errorList:nil];
}
-(void)testRegisterTokenWithTimerInvalidation {
    [[[self.partialDeviceTokenService expect] andReturnBool:NO] shouldRegisterDeviceToken:self.mockDeviceTokenString];
    [[self.partialDeviceTokenService expect] invalidateRegisterDeviceTimer];
    [self.deviceTokenService registerDeviceTokensWithTimer:self.mockDeviceTokenString];
}
-(void)testRegisterTokenWithTimer {
    [[[self.partialDeviceTokenService expect] andReturnBool:YES] shouldRegisterDeviceToken:self.mockDeviceTokenString];
    [[self.partialDeviceTokenService expect] registerDeviceTokenString:self.mockDeviceTokenString];
    [self.deviceTokenService registerDeviceTokensWithTimer:self.mockDeviceTokenString];
}
    

-(void)testInvalidateRegister {
    
    [[self.mockRegisterDeviceTimer expect] invalidate];
    [self.deviceTokenService invalidateRegisterDeviceTimer];
    GHAssertNil(self.deviceTokenService.registerDeviceTimer, @"register device timer should be nil after invalidation");
}
-(void)testRegisterDeviceTokenPersistently {
    id mockString = [OCMockObject mockForClass:[NSString class]];
    [[mockString expect] uppercaseString];
    
    [self.deviceTokenService registerDeviceToken:mockString persistent:YES];
    GHAssertNotNil(self.deviceTokenService.registerDeviceTimer,@"the register service is nil when it should be initialized");
    [mockString verify];
}    
-(void)testRegisterDeviceTokens {
//    -(void)registerDeviceTokens:(NSArray *) tokens {
    NSMutableArray *tokens = [NSArray arrayWithObject:@"FFFF"];
    [[self.partialDeviceTokenService expect] executeRequest:OCMOCK_ANY];
    [self.deviceTokenService registerDeviceTokens:tokens];
    
}
-(void)testRegisterDeviceToken {
    //  -(void)registerDeviceToken:(NSData *)deviceToken {    
    id mockData = [OCMockObject mockForClass:[NSData class]];
    [[self.partialDeviceTokenService expect] registerDeviceToken:mockData];
    [self.deviceTokenService registerDeviceToken:mockData];
    
    [mockData verify];
}

@end
