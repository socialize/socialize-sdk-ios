//
//  SocializeNotificationHandlerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/29/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeNotificationHandlerTests.h"
#import "SocializeActivityDetailsViewController.h"

@interface SocializeNotificationHandler ()
- (SocializeNewCommentsNotificationDisplayController*)createNewCommentsDisplayControllerForActivityType:(NSString*)activityType activityID:(NSNumber*)activityID;
- (void)animatedDismissOfTopDisplayController;
- (void)removeDisplayController:(SocializeNotificationDisplayController*)displayController;
@end

@implementation SocializeNotificationHandlerTests
@synthesize notificationHandler = notificationHandler_;
@synthesize origNotificationHandler = origNotificationHandler_;
@synthesize mockDisplayWindow = mockDisplayWindow_;

- (BOOL)shouldRunOnMainThread {
    return YES;
}

- (void)setUp {
    self.origNotificationHandler = [[[SocializeNotificationHandler alloc] init] autorelease];
    self.notificationHandler = [OCMockObject partialMockForObject:self.origNotificationHandler];
    
    self.mockDisplayWindow = [OCMockObject mockForClass:[UIWindow class]];
    self.notificationHandler.displayWindow = self.mockDisplayWindow;
}

- (void)tearDown {
    [self.mockDisplayWindow verify];
    
    self.origNotificationHandler = nil;
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

- (void)testCreateNewCommentsDisplayController {
    NSString *commentType = @"comment";
    NSNumber *commentID = [NSNumber numberWithInteger:1234];
    
    SocializeNewCommentsNotificationDisplayController *controller = [self.notificationHandler createNewCommentsDisplayControllerForActivityType:commentType activityID:commentID];
    GHAssertEqualObjects(controller.activityType, commentType, @"Bad type");
    GHAssertEqualObjects(controller.activityID, commentID, @"Bad id");
    GHAssertEqualObjects(controller.delegate, self.origNotificationHandler, @"Bad delegate");
}

- (void)testHandleNewCommentsSocializeNotification {
    
    NSNumber *testID = [NSNumber numberWithInteger:304899];
    NSString *commentType = @"comment";
    NSDictionary *socializeInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   testID, @"activity_id",
                                   commentType, @"activity_type",
                                   @"new_comments", @"notification_type",
                                   nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:socializeInfo forKey:@"socialize"];

    // Mock display controller
    id mockNotificationDisplayController = [OCMockObject mockForClass:[SocializeNotificationDisplayController class]];
    [[[(id)self.notificationHandler stub] andReturn:mockNotificationDisplayController] createNewCommentsDisplayControllerForActivityType:commentType activityID:testID];
    
    // Has a top controller
    id mockMainViewController = [OCMockObject mockForClass:[UIViewController class]];
    [[[mockNotificationDisplayController stub] andReturn:mockMainViewController] mainViewController];
    
    // With a mock view
    id mockView = [OCMockObject mockForClass:[UIView class]];
    [[[mockMainViewController stub] andReturn:mockView] view];
    
    // Stub in a test frame for the target display window
    CGRect testFrame = CGRectMake(0, 0, 320, 480);
    [[[self.mockDisplayWindow stub] andReturnValue:OCMOCK_VALUE(testFrame)] frame];
    
    // The display controller's view should be configured for window display, under the status bar (20px high on iphone)
    [[mockView expect] setFrame:CGRectMake(0, 20, 320, 460)];
    
    // And it should become a subview of the display window
    [[self.mockDisplayWindow expect] addSubview:mockView];
    
    // Simulate coming from background
    [[[(id)self.notificationHandler stub] andReturnBool:NO] applicationInForeground];
    
    [self.notificationHandler handleSocializeNotification:userInfo];
    
    [mockNotificationDisplayController verify];
    [mockMainViewController verify];
    [mockView verify];
    
    NSArray *expectedArray = [NSArray arrayWithObject:mockNotificationDisplayController];
    GHAssertEqualObjects(self.notificationHandler.displayControllers, expectedArray, @"Incorrect list of controllers");
}

- (void)testThatDisplayControllerFinishTriggersAnimation {
    [[(id)self.notificationHandler expect] animatedDismissOfTopDisplayController];
    [self.notificationHandler notificationDisplayControllerDidFinish:nil];
}

- (void)testThatFinishingAnimationForDisplayControllerRemovesFromViewAndUpdatesArray {
    
    // Stub in a single display controller
    id mockNotificationDisplayController = [OCMockObject mockForClass:[SocializeNotificationDisplayController class]];
    self.notificationHandler.displayControllers = [NSMutableArray arrayWithObject:mockNotificationDisplayController];
    
    // Which has a top controller
    id mockMainViewController = [OCMockObject mockForClass:[UIViewController class]];
    [[[mockNotificationDisplayController stub] andReturn:mockMainViewController] mainViewController];
    
    // With a mock view
    id mockView = [OCMockObject mockForClass:[UIView class]];
    [[[mockMainViewController stub] andReturn:mockView] view];
    
    // Controller view should be removed from view
    [[mockView expect] removeFromSuperview];
    
    // Simulate the end of the animation
    [self.notificationHandler removeDisplayController:mockNotificationDisplayController];
    
    [mockNotificationDisplayController verify];
    [mockMainViewController verify];
    [mockView verify];
    
    // Array should be empty
    GHAssertTrue([self.notificationHandler.displayControllers count] == 0, @"Should be empty");
}

@end
