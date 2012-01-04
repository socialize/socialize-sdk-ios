//
//  SocializeNotificationHandlerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/29/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeNotificationHandlerTests.h"
#import "SocializeActivityDetailsViewController.h"

@implementation SocializeNotificationHandlerTests
@synthesize notificationHandler = notificationHandler_;
@synthesize origNotificationHandler = origNotificationHandler_;
@synthesize mockDisplayWindow = mockDisplayWindow_;
@synthesize mockActivityDetailsViewController = mockActivityDetailsViewController_;
@synthesize mockNavigationController = mockNavigationController_;

- (void)setUp {
    self.origNotificationHandler = [[[SocializeNotificationHandler alloc] init] autorelease];
    self.notificationHandler = [OCMockObject partialMockForObject:self.origNotificationHandler];
    
    self.mockDisplayWindow = [OCMockObject mockForClass:[UIWindow class]];
    self.notificationHandler.displayWindow = self.mockDisplayWindow;
    
    self.mockActivityDetailsViewController = [OCMockObject mockForClass:[SocializeActivityDetailsViewController class]];
    self.notificationHandler.activityDetailsViewController = self.mockActivityDetailsViewController;
    
    self.mockNavigationController = [OCMockObject mockForClass:[UINavigationController class]];
    self.notificationHandler.navigationController = self.mockNavigationController;
}

- (void)tearDown {
    [self.mockDisplayWindow verify];
    [self.mockActivityDetailsViewController verify];
    [self.mockNavigationController verify];
    
    self.origNotificationHandler = nil;
    self.notificationHandler = nil;
    self.mockActivityDetailsViewController = nil;
    self.mockNavigationController = nil;
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

- (void)testHandleSocializeNotification {
    
    NSNumber *testID = [NSNumber numberWithInteger:304899];
    NSDictionary *socializeInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   testID, @"activity_id",
                                   @"comment", @"activity_type",
                                   @"new_comments", @"notification_type",
                                   nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:socializeInfo forKey:@"socialize"];

    
    // Expect these are nilled out. Ignore the messages and keep our mocks in place for testing
    [[(id)self.notificationHandler expect] setNavigationController:nil];
    [[(id)self.notificationHandler expect] setActivityDetailsViewController:nil];

    // Stub in the frame for the display window
    CGRect testFrame = CGRectMake(0, 0, 320, 480);
    [[[self.mockDisplayWindow stub] andReturnValue:OCMOCK_VALUE(testFrame)] frame];
    
    // Stub in a UIView for the navigation controller
    id mockView = [OCMockObject mockForClass:[UIView class]];
    [[[self.mockNavigationController stub] andReturn:mockView] view];
    
    // Should be configured for window display, under the status bar (20px high on iphone)
    [[mockView expect] setFrame:CGRectMake(0, 20, 320, 460)];
    
    // Should become a subview of the window
    [[self.mockDisplayWindow expect] addSubview:mockView];
    
    // Should load our activity
    [[self.mockActivityDetailsViewController expect] fetchActivityForType:@"comment" activityID:testID];
    
    [self.notificationHandler handleSocializeNotification:userInfo];
}

@end
