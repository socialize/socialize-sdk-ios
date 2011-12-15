//
//  SocializeDeviceTokenServiceTests.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/13/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeDeviceTokenServiceTests.h"
#import <OCMock/OCMock.h>

@implementation SocializeDeviceTokenServiceTests

@synthesize deviceTokenService = deviceTokenService_;
@synthesize partialDeviceTokenService = partialDeviceTokenService_;
@synthesize mockRegisterDeviceTimer = mockRegisterDeviceTimer_;

-(void)setUp {
    self.deviceTokenService = [[SocializeDeviceTokenService alloc] init];
    self.partialDeviceTokenService = [OCMockObject partialMockForObject:self.deviceTokenService];
    //create a mock timer and assign it to the token service
    self.mockRegisterDeviceTimer = [OCMockObject mockForClass:[NSTimer class]];
    self.deviceTokenService.registerDeviceTimer = self.mockRegisterDeviceTimer;
}
-(void)tearDown {
    //first we need to verify 
    [self.partialDeviceTokenService verify];
    [self.mockRegisterDeviceTimer verify];
    
    //deallocate the objects from memory
    self.deviceTokenService = nil;
    self.partialDeviceTokenService = nil;
    self.mockRegisterDeviceTimer = nil;
}
-(void)testInvalidateRegister {
    [[self.mockRegisterDeviceTimer expect] invalidate];
    [self.deviceTokenService invalidateRegisterDeviceTimer];
    GHAssertNil(self.deviceTokenService.registerDeviceTimer, @"register device timer should be nil after invalidation");
}
-(void)testRegisterDeviceTokenPersistently {
    id mockData = [OCMockObject mockForClass:[NSData class]];
    [[self.partialDeviceTokenService expect] getTimerBlockForToken:OCMOCK_ANY];
    [self.deviceTokenService registerDeviceToken:mockData persistent:YES];
    GHAssertNotNil(self.deviceTokenService.registerDeviceTimer,@"the register service is nil when it should be initialized");
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
