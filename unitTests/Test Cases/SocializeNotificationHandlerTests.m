//
//  SocializeNotificationHandlerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/29/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeNotificationHandlerTests.h"

@implementation SocializeNotificationHandlerTests
@synthesize notificationHandler = notificationHandler_;
@synthesize mockDisplayWindow = mockDisplayWindow_;

- (void)setUp {
    self.notificationHandler = [[[SocializeNotificationHandler alloc] init] autorelease];
    
    self.mockDisplayWindow = [OCMockObject mockForClass:[UIWindow class]];
    self.notificationHandler.displayWindow = self.mockDisplayWindow;
}

- (void)tearDown {
    [self.mockDisplayWindow verify];
    self.notificationHandler = nil;
}

- (void)testValidSocializeNotificationIsNotification {
    
    NSDictionary *socializeInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"304899", @"activity_id",
                                   @"comment", @"activity_type",
                                   @"new_comments", @"notification_type",
                                   nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:socializeInfo forKey:@"socialize"];
    
    BOOL isValid = [SocializeNotificationHandler isSocializeNotification:userInfo];
    GHAssertTrue(isValid, @"should be valid");
}

- (void)testInvalidSocializeNotificationIsNotNotification {
    NSDictionary *socializeInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"304899", @"activity_id",
                                   @"comment", @"activity_type",
                                   @"blah", @"notification_type",
                                   nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:socializeInfo forKey:@"socialize"];
    
    BOOL isValid = [SocializeNotificationHandler isSocializeNotification:userInfo];
    GHAssertFalse(isValid, @"should be valid");
}

- (void)testUnknownNotificationTypeDoesNotCrash {
}

@end
