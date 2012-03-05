//
//  SocializeUIDisplayTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeUIDisplayTests.h"
#import "SocializeUIDisplay.h"

@implementation SocializeUIDisplayTests
@synthesize displayProxy = displayProxy_;
@synthesize mockHandler = mockHandler_;
@synthesize mockDisplay = mockDisplay_;

- (void)setUp {
    id mockObject = [OCMockObject mockForClass:[NSObject class]];
    self.mockDisplay = [OCMockObject mockForClass:[NSObject class]];
    self.displayProxy = [[SocializeUIDisplayProxy alloc] initWithObject:mockObject display:nil];
}

- (void)tearDown {
    [self.mockHandler verify];
    [self.mockDisplay verify];
    
    self.mockHandler = nil;
    self.mockDisplay = nil;
    self.displayProxy = nil;
}

@end
