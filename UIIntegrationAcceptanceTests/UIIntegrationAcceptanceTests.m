//
//  UIIntegrationAcceptanceTests.m
//  UIIntegrationAcceptanceTests
//
//  Created by Sergey Popenko on 9/22/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//
#import "KIFUITestActor+TestApp.h"
#import "TestAppHelper.h"
#import "TestAppListViewController.h"

@interface UIIntegrationAcceptanceTests : KIFTestCase

@end

@implementation UIIntegrationAcceptanceTests

- (void)beforeAll
{
}

- (void)afterAll
{
}

- (void)beforeEach
{
    [tester initializeTest];
}

- (void)testActionBar
{
    NSLog(@"Test the action bar");
    
    // Set up a test entity
    NSString *entityKey = [TestAppHelper testURL:[NSString stringWithFormat:@"%s/entity1", sel_getName(_cmd)]];
    id<SZEntity> entity = [SZEntity entityWithKey:entityKey name:@"Test"];
    [[TestAppListViewController sharedSampleListViewController] setEntity:entity];
    
    
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowActionBarExampleRow];
    [tester scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
    [tester tapViewWithAccessibilityLabel:@"comment button"];
    [tester tapViewWithAccessibilityLabel:@"Close"];
    
    [tester tapViewWithAccessibilityLabel:@"views button"];
    [tester tapViewWithAccessibilityLabel:@"Cancel"];
    
    [tester tapViewWithAccessibilityLabel:@"share button"];
    [tester tapViewWithAccessibilityLabel:@"Cancel"];
    
    [tester tapViewWithAccessibilityLabel:@"like button"];
    [tester tapViewWithAccessibilityLabel:@"Skip"];
    [tester verifyActionBarLikesAtCount:1];
    [tester tapViewWithAccessibilityLabel:@"like button"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeAuthenticatedUserDidChangeNotification object:[SZUserUtils currentUser]];
    
    [tester waitForViewWithAccessibilityLabel:@"In progress"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"In progress"];
    [tester tapViewWithAccessibilityLabel:@"Cancel"];
}
@end
