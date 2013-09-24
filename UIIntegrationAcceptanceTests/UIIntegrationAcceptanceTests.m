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
#import "SZTestHelper.h"

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
    // Set up a test entity
    NSString *entityKey = [TestAppHelper testURL:[NSString stringWithFormat:@"%s/entity1", sel_getName(_cmd)]];
    id<SZEntity> entity = [SZEntity entityWithKey:entityKey name:@"Test"];
    [[TestAppListViewController sharedSampleListViewController] setEntity:entity];

    [tester openActionBarExample];
    
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

- (void)testUserProfile
{
    NSString *url = [TestAppHelper testURL:[NSString stringWithFormat:@"%s/entity1", sel_getName(_cmd)]];
    NSString *commentText = [NSString stringWithFormat:@"comment for %@", [TestAppHelper runID]];
    
    id<SZEntity> entity = [SZEntity entityWithKey:url name:@"Test"];
    id<SZComment> comment = [SZComment commentWithEntity:entity text:commentText];
    [[SZTestHelper sharedTestHelper] createComment:comment];
    
    [tester showUserProfile];
    [tester waitForViewWithAccessibilityLabel:commentText];
    
    [tester openEditProfile];

    [tester tapViewWithAccessibilityLabel:@"Back"];
    [tester tapViewWithAccessibilityLabel:@"Done"];
}

- (void)testFacebookAuth
{
    [[SZTestHelper sharedTestHelper] startMockingSucceedingFacebookAuthWithDidAuth:nil];
    
    [tester showLinkToFacebook];
    
    [tester waitForViewWithAccessibilityLabel:@"Facebook link successful"];
    [tester tapViewWithAccessibilityLabel:@"Ok"];
    
    [[SZTestHelper sharedTestHelper] stopMockingSucceedingFacebookAuth];
    
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"In progress"];
}

- (void)testLikeButton
{
    // Set up a test entity
    NSString *entityKey = [TestAppHelper testURL:[NSString stringWithFormat:@"%s/entity1", sel_getName(_cmd)]];
    id<SZEntity> entity = [SZEntity entityWithKey:entityKey name:@"Test"];
    [[TestAppListViewController sharedSampleListViewController] setEntity:entity];
    
    [tester wipeAuthData];
    [tester showButtonExample];
    
    [tester tapViewWithAccessibilityLabel:@"like button"];
    [tester tapViewWithAccessibilityLabel:@"Skip"];
    
    [tester verifyActionBarLikesAtCount:1];
    
    [tester tapViewWithAccessibilityLabel:@"like button"];
    [tester tapViewWithAccessibilityLabel:@"Done"];
}

@end
