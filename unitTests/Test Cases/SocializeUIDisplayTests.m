//
//  SocializeUIDisplayTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeUIDisplayTests.h"
#import "SocializeUIDisplayHandler.h"

@implementation SocializeUIDisplayTests
@synthesize display = display_;
@synthesize mockHandler = mockHandler_;

- (void)setUp {
    self.display = [[SocializeUIDisplay alloc] initWithDisplayHandler:self.mockHandler];
}

- (void)tearDown {
    [self.mockHandler verify];
    
    self.mockHandler = nil;
    self.display = nil;
}

@end
