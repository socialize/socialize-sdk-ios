//
//  SocializeServiceTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/26/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeServiceTests.h"
#import <OCMock/OCMock.h>
#import "SocializeRequest.h"
#import "SocializeService.h"

@implementation SocializeServiceTests
@synthesize mockRequest = mockRequest_;

- (void)setUp {
    self.mockRequest = [OCMockObject niceMockForClass:[SocializeRequest class]];
}

- (void)tearDown {
}

- (void)tearDownClass {
    // We are doing some dealloc testing, so for now verify request here to hack around ghunit autorelease flow
    [self.mockRequest verify];
    self.mockRequest = nil;
}

- (void)testThatServiceIsNotDelegateOfExecutedRequestAfterDealloc {
    SocializeService *service = [[SocializeService alloc] init];

    [[self.mockRequest expect] setDelegate:service];
    [service executeRequest:self.mockRequest];
    [self.mockRequest verify];

    [[self.mockRequest expect] setDelegate:nil];
    [service release];
}

@end
