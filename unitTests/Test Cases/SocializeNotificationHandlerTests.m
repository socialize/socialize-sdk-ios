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
- (void)animatedDismissOfTopDisplayController;
- (void)removeDisplayController:(SocializeNotificationDisplayController*)displayController;
- (void)addDisplayController:(SocializeNotificationDisplayController*)displayController;
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

- (void)testAddDisplayController {
    // Mock display controller
    id mockNotificationDisplayController = [OCMockObject mockForClass:[SocializeNotificationDisplayController class]];
    [[mockNotificationDisplayController stub] setDelegate:nil];
    
    [[mockNotificationDisplayController expect] setDelegate:self.origNotificationHandler];
    
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
    
    [self.notificationHandler addDisplayController:mockNotificationDisplayController];
    
    [mockNotificationDisplayController verify];
    [mockMainViewController verify];
    [mockView verify];
    
    NSArray *expectedArray = [NSArray arrayWithObject:mockNotificationDisplayController];
    GHAssertEqualObjects(self.notificationHandler.displayControllers, expectedArray, @"Incorrect list of controllers");
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

    
    // Simulate coming from background
    [[[(id)self.notificationHandler stub] andReturnBool:NO] applicationInForeground];
    
    // Expect add new comments controller
    [[(id)self.notificationHandler expect] addDisplayController:[OCMArg checkWithBlock:^BOOL(id controller) {
        return [controller isKindOfClass:[SocializeNewCommentsNotificationDisplayController class]];
    }]];
     
    [self.notificationHandler handleSocializeNotification:userInfo];
    
}

- (void)testHandleRichPushSocializeNotification {
    
    NSDictionary *socializeInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"test title", @"title",
                                   @"rich_push", @"notification_type",
                                   nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:socializeInfo forKey:@"socialize"];
    
    
    // Expect add new comments controller
    [[(id)self.notificationHandler expect] addDisplayController:[OCMArg checkWithBlock:^BOOL(id controller) {
        return [controller isKindOfClass:[SocializeRichPushNotificationDisplayController class]];
    }]];
    
    [self.notificationHandler handleSocializeNotification:userInfo];
}

- (void)testThatDisplayControllerFinishTriggersAnimation {
    [[(id)self.notificationHandler expect] animatedDismissOfTopDisplayController];
    [self.notificationHandler notificationDisplayControllerDidFinish:nil];
}

- (void)testThatFinishingAnimationForDisplayControllerRemovesFromViewAndUpdatesArray {
    
    // Stub in a single display controller
    id mockNotificationDisplayController = [OCMockObject mockForClass:[SocializeNotificationDisplayController class]];
    
    // Should stop being delegate
    [[mockNotificationDisplayController expect] setDelegate:nil];
    
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
