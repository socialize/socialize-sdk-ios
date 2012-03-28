//
//  SocializeNotificationDisplayControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/27/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeNotificationDisplayControllerTests.h"
#import "SocializeNotificationDisplayController.h"

@implementation SocializeNotificationDisplayControllerTests
@synthesize mockDelegate = mockDelegate_;
@synthesize notificationDisplayController = notificationDisplayController_;

- (SocializeNotificationDisplayController*)notificationDisplayController {
    return (SocializeNotificationDisplayController*)self.uut;
}

- (void)setUp {
    [super setUp];
    
    self.mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeNotificationDisplayControllerDelegate)];
    self.notificationDisplayController.delegate = self.mockDelegate;
}

- (void)tearDown {
    [super tearDown];
    
    [self.mockDelegate verify];
    
    [self.notificationDisplayController setDelegate:nil];
    self.mockDelegate = nil;
}

@end
