//
//  SocializeLocationManagerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/23/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeLocationManagerTests.h"

@implementation SocializeLocationManagerTests
@synthesize locationManager = locationManager_;

- (void)setUp {
    self.locationManager = [[[SocializeLocationManager alloc] init] autorelease];
}

- (void)tearDown {
    self.locationManager = nil;
}

@end