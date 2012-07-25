//
//  SZSessionTrackerTests.m
//  Socialize
//
//  Created by Nathaniel Griswold on 7/25/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZSessionTrackerTests.h"

@implementation SZSessionTrackerTests

- (void)setUp {
    [super setUp];
    [self startMockingSharedSocialize];
}

- (void)tearDown {
    [super tearDown];
    
    [self stopMockingSharedSocialize];
}

- (void)testActiveNotificationLogsEvent {
    [[self.mockSharedSocialize expect] trackEventWithBucket:OCMOCK_ANY values:OCMOCK_ANY];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)testResignActiveNotificationLogsEvent {
    [[self.mockSharedSocialize expect] trackEventWithBucket:OCMOCK_ANY values:OCMOCK_ANY];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillResignActiveNotification object:nil];
}


@end
