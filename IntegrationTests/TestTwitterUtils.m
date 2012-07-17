//
//  TestSZTwitterUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestTwitterUtils.h"
#import "SZTestHelper.h"
#import <OCMock/NSObject+ClassMock.h>

@implementation TestTwitterUtils

- (void)testTwitterPostAndGet {
    [[SZTestHelper sharedTestHelper] startMockingSucceededTwitterAuth];
    
    NSString *runID = [self runID];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:runID forKey:@"status"];
    
    [self prepare];
    [[SZTwitterUtils origClass] postWithPath:@"/1/statuses/update.json" params:params success:^(id result) {
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    // FIXME
    [NSThread sleepForTimeInterval:5];

    [self prepare];
    [[SZTwitterUtils origClass] getWithPath:@"/1/statuses/user_timeline.json" params:nil success:^(id result) {
        [self notify:kGHUnitWaitStatusSuccess];
        NSString *text = [[result objectAtIndex:0] objectForKey:@"text"];
        GHAssertEqualStrings(text, runID, @"Bad text");
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    [[SZTestHelper sharedTestHelper] stopMockingSucceededTwitterAuth];
}

@end
