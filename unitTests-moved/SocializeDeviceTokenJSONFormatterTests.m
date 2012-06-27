//
//  SocializeDeviceTokenJSONFormatterTests.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/13/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeDeviceTokenJSONFormatterTests.h"
#import <OCMock/OCMock.h>
#import "SocializeDeviceToken.h"

@implementation SocializeDeviceTokenJSONFormatterTests

@synthesize deviceTokenFormatter = deviceTokenFormatter_;

-(void)setUp {
    self.deviceTokenFormatter = [[SocializeDeviceTokenJSONFormatter alloc] init];
}
-(void)tearDown {
    self.deviceTokenFormatter = nil;
}

-(void)testDeviceTokenFormatter {
    //mock out device token to pass into method
    id mockDeviceToken = [OCMockObject mockForProtocol:@protocol(SocializeDeviceToken)];
    [[mockDeviceToken expect] setDevice_alias:OCMOCK_ANY];
    [[mockDeviceToken expect] setDevice_token:OCMOCK_ANY];
    [[mockDeviceToken expect] setApplication:OCMOCK_ANY];
    [[mockDeviceToken expect] setUser:OCMOCK_ANY];
    
    //mock out JSON dictionary
    id mockDictionary = [OCMockObject mockForClass:[NSDictionary class]];
    [[[mockDictionary stub] andReturn:OCMOCK_ANY] objectForKey:OCMOCK_ANY];
    
    //test token formatter
    [self.deviceTokenFormatter doToObject:mockDeviceToken fromDictionary:mockDictionary];
    //verify all methods were called
    [mockDeviceToken verify];
}
@end
