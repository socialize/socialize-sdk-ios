//
//  TestEventUtils.m
//  Socialize
//
//  Created by Nathaniel Griswold on 9/7/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "TestEventUtils.h"
#import "SZTestHelper.h"

@implementation TestEventUtils

- (void)testTrackEvent {
    [[SZTestHelper sharedTestHelper] removeAuthenticationInfo];
    
    [self prepare];
    [SZEventUtils trackEventWithBucket:@"bucket" values:nil success:^(id<SocializeComment> comment) {
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
}

@end
