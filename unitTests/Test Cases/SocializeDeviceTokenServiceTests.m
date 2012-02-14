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

@interface SocializeDeviceTokenService ()
@end


@implementation SocializeDeviceTokenServiceTests

@synthesize deviceTokenService = deviceTokenService_;
@synthesize partialDeviceTokenService = partialDeviceTokenService_;
@synthesize mockDeviceTokenString = mockDeviceTokenString_;
@synthesize mockDeviceToken = mockDeviceToken_;

-(void)setUp {
    self.deviceTokenService = [[SocializeDeviceTokenService alloc] init];
    self.partialDeviceTokenService = [OCMockObject partialMockForObject:self.deviceTokenService];
    //create a mock timer and assign it to the token service
    self.mockDeviceTokenString = [OCMockObject niceMockForClass:[NSString class]];
    self.mockDeviceToken = [OCMockObject niceMockForProtocol:@protocol(SocializeDeviceToken)];
    [self.mockDeviceToken setDevice_token:self.mockDeviceTokenString];
}
-(void)tearDown {
    //first we need to verify 
    [self.partialDeviceTokenService verify];
    [self.mockDeviceTokenString verify];
    [self.mockDeviceToken verify];
    
    //deallocate the objects from memory
    self.deviceTokenService = nil;
    self.partialDeviceTokenService = nil;
    self.mockDeviceTokenString = nil;
    self.mockDeviceToken = nil;
}

-(void)invokeAppropriateCallback {
    NSArray *objectList = [NSArray arrayWithObject:self.mockDeviceToken];
    [[[self.partialDeviceTokenService expect] andReturn:objectList] getObjectListArray:OCMOCK_ANY];
    [self.deviceTokenService invokeAppropriateCallback:nil objectList:nil errorList:nil];
}

-(void)testRegisterDeviceToken {
//    NSMutableArray *tokens = [NSArray arrayWithObject:@"FFFF"];
    [[self.partialDeviceTokenService expect] executeRequest:[OCMArg checkWithBlock:^(SocializeRequest *request) {
        NSArray *params = [request params];
        NSDictionary *deviceTokenObject = [params objectAtIndex:0];
        NSString *deviceToken = [deviceTokenObject objectForKey:@"device_token"];
        NSString *deviceType = [deviceTokenObject objectForKey:@"device_type"];
        
        if (![deviceToken isEqualToString:@"FFFF"])
            return NO;
        if (![deviceType isEqualToString:@"iOS"])
            return NO;
        
        return YES;
    }]];
    
    [self.deviceTokenService registerDeviceTokenString:@"FFFF"];
    
}

@end
