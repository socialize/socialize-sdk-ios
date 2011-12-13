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

-(void)setUp {
    self.deviceTokenService = [[SocializeDeviceTokenService alloc] init];
    self.partialDeviceTokenService = [OCMockObject partialMockForObject:self.deviceTokenService];
}
-(void)tearDown {
    //first we need to verify 
    [self.partialDeviceTokenService verify];
    
    //deallocate the objects from memory
    self.deviceTokenService = nil;
    self.partialDeviceTokenService = nil;
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
