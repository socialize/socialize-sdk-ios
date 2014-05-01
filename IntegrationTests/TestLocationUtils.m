//
//  TestLocationUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/15/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestLocationUtils.h"
#import <Socialize/Socialize.h>
#import <Loopy/Loopy.h>

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

//ensures the Loopy location manager and Socialize location manager match up
- (void)testLoopyLocationIntegration {
    STAPIClient *loopy = [Socialize sharedLoopyAPIClient];
    CLLocationManager *loopyLocationManager = loopy.deviceSettings.locationManager;
    BOOL locationSharingDisabled = [Socialize locationSharingDisabled];
    BOOL loopyLocationIntegMatch = (locationSharingDisabled && !loopyLocationManager) ||
                                  (!locationSharingDisabled && loopyLocationManager);
    GHAssertTrue(loopyLocationIntegMatch, @"");
}

@end
