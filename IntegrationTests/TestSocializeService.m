//
//  TestSocializeService.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestSocializeService.h"

@implementation TestSocializeService

- (void)testDeallocWithOutstandingRequest {
    Socialize *socialize = [[Socialize alloc] initWithDelegate:self];
    [socialize createEntityWithKey:@"entityKey" name:@"entityName"];
    [socialize release];
    
    [NSThread sleepForTimeInterval:10];
}

@end
