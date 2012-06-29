//
//  TestLocationUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/15/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestLocationUtils.h"
#import <Socialize/Socialize.h>

@implementation TestLocationUtils

- (void)testGetCurrentAndLastLocation {
    [self prepare];
    [SZLocationUtils getCurrentLocationWithSuccess:^(CLLocation* location) {
        GHAssertNotNil(location, @"Location is nil");
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    CLLocation *lastLocation = [SZLocationUtils lastKnownLocation];
    GHAssertNotNil(lastLocation, @"last location should not be nil");
}

@end
