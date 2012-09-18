//
//  SZSessionTrackerTests.m
//  Socialize
//
//  Created by Nathaniel Griswold on 7/25/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZSessionTrackerTests.h"
#import "SZEventUtils.h"

@implementation SZSessionTrackerTests

- (void)setUp {
    [super setUp];
    [self startMockingSharedSocialize];
    
    [SZEventUtils startMockingClass];
}

- (void)tearDown {
    [super tearDown];
    
    [self stopMockingSharedSocialize];
    [SZEventUtils stopMockingClassAndVerify];
}

- (void)testActiveNotificationLogsEvent {
    [[SZEventUtils expect] trackEventWithBucket:OCMOCK_ANY values:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)testResignActiveNotificationLogsEvent {
    [[SZEventUtils expect] trackEventWithBucket:OCMOCK_ANY values:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillResignActiveNotification object:nil];
}


@end
