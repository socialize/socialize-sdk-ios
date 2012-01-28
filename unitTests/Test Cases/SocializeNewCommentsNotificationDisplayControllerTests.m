//
//  SocializeNewCommentsNotificationDisplayControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/10/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeNewCommentsNotificationDisplayControllerTests.h"
#import "SocializeCommentsTableViewController.h"
#import "SocializeActivityDetailsViewController.h"
#import "SocializeNewCommentsNotificationDisplayController.h"

@implementation SocializeNewCommentsNotificationDisplayControllerTests
@synthesize commentsNotificationDisplayController = commentsNotificationDisplayController_;
@synthesize mockActivityDetailsViewController = mockActivityDetailsViewController_;
@synthesize mockCommentsTableViewController = mockCommentsTableViewController_;
@synthesize mockNavigationController = mockNavigationController_;
@synthesize mockDelegate = mockDelegate_;

- (BOOL)shouldRunOnMainThread {
    return YES;
}

- (void)setUp {
    self.commentsNotificationDisplayController = [[[SocializeNewCommentsNotificationDisplayController alloc] init] autorelease];
    
    NSDictionary *socializeInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:1234], @"activity_id",
                                   @"comment", @"activity_type",
                                   @"new_comments", @"notification_type",
                                   nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:socializeInfo forKey:@"socialize"];
    self.commentsNotificationDisplayController.userInfo = userInfo;
                                                               
    // Stub Activity details
    self.mockActivityDetailsViewController = [OCMockObject mockForClass:[SocializeActivityDetailsViewController class]];
    [[self.mockActivityDetailsViewController stub] setDelegate:nil];
    self.commentsNotificationDisplayController.activityDetailsViewController = self.mockActivityDetailsViewController;
    [[self.mockActivityDetailsViewController stub] setDelegate:nil];
    
    // Stub Comments list
    self.mockCommentsTableViewController = [OCMockObject mockForClass:[SocializeCommentsTableViewController class]];
    self.commentsNotificationDisplayController.commentsTableViewController = self.mockCommentsTableViewController;
    [[self.mockCommentsTableViewController stub] setDelegate:nil];
    
    // Stub Navigation Controller
    self.mockNavigationController = [OCMockObject mockForClass:[UINavigationController class]];
    self.commentsNotificationDisplayController.navigationController = self.mockNavigationController;
    
    self.mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeNotificationDisplayControllerDelegate)];
    self.commentsNotificationDisplayController.delegate = self.mockDelegate;
}

- (void)tearDown {
    [self.mockActivityDetailsViewController verify];
    [self.mockCommentsTableViewController verify];
    [self.mockNavigationController verify];
    
    self.mockActivityDetailsViewController = nil;
    self.mockCommentsTableViewController = nil;
    self.mockNavigationController = nil;
    self.commentsNotificationDisplayController = nil;
}

- (void)testThatMainViewControllerIsNavigationController {
    GHAssertEquals(self.commentsNotificationDisplayController.mainViewController, self.mockNavigationController, @"Should be navigation controller");
}

/*
- (void)testDefaultNavigationController {
    id niceCommentsTableViewController = [OCMockObject niceMockForClass:[SocializeCommentsTableViewController class]];
    self.commentsNotificationDisplayController.commentsTableViewController = niceCommentsTableViewController;

    id niceActivityDetailsViewController = [OCMockObject niceMockForClass:[SocializeActivityDetailsViewController class]];
    self.commentsNotificationDisplayController.activityDetailsViewController = niceActivityDetailsViewController;
    
    self.commentsNotificationDisplayController.navigationController = nil;
    UINavigationController *defaultNav = self.commentsNotificationDisplayController.navigationController;
    
    GHAssertEquals(defaultNav.delegate, self.commentsNotificationDisplayController, @"bad delegate");
}
 */


- (void)testFinishingWithCommentsListNotifiesDelegate {
    [[self.mockDelegate expect] notificationDisplayControllerDidFinish:self.commentsNotificationDisplayController];
    [self.commentsNotificationDisplayController commentsTableViewControllerDidFinish:nil];
}

- (void)testDisplayingActivityDetailsPerformsSpecialConfigurationAndFetchesActivity {
    
    // Title should become something
    [[self.mockActivityDetailsViewController expect] setTitle:OCMOCK_ANY];
    
    // Dismiss button should be cleared, since we are using the back arrow
    id mockNavigationItem = [OCMockObject mockForClass:[UINavigationItem class]];
    [[[self.mockActivityDetailsViewController stub] andReturn:mockNavigationItem] navigationItem];
    [[mockNavigationItem expect] setRightBarButtonItem:nil];
    
    [[self.mockActivityDetailsViewController expect] fetchActivityForType:@"comment" activityID:[NSNumber numberWithInteger:1234]];
    [self.commentsNotificationDisplayController navigationController:self.mockNavigationController willShowViewController:self.mockActivityDetailsViewController animated:YES];
}

- (void)testShowingCommentsTableViewDismissesIfNoEntityAvailable {
    
    // No entity was received
    [[[self.mockCommentsTableViewController stub] andReturn:nil] entity];
    
    // Delegate should be notified immediately that we are done
    [[self.mockDelegate expect] notificationDisplayControllerDidFinish:self.commentsNotificationDisplayController];
    
    [self.commentsNotificationDisplayController navigationController:self.mockNavigationController willShowViewController:self.mockCommentsTableViewController animated:YES];
}

- (void)testShowingCommentsTableViewDoesNothingIfEntityAvailable {
    id mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    [[[mockEntity stub] andReturn:@"testKey"] key];
    
    // Stub mock entity with key
    [[[self.mockCommentsTableViewController stub] andReturn:mockEntity] entity];
    
    [self.commentsNotificationDisplayController navigationController:self.mockNavigationController willShowViewController:self.mockCommentsTableViewController animated:YES];
}

@end
