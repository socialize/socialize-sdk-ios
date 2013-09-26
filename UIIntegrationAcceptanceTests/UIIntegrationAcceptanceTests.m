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
    
    [tester showButtonExample];
    
    [tester tapViewWithAccessibilityLabel:@"like button"];
    [tester tapViewWithAccessibilityLabel:@"Skip"];
    
    [tester verifyActionBarLikesAtCount:1];
    
    [tester tapViewWithAccessibilityLabel:@"like button"];
    [tester tapViewWithAccessibilityLabel:@"Done"];
}

- (void) testTwitterAuth
{
    [tester showLinkToTwitter];
    [tester authWithTwitter];
}

- (void) testLikeNoAuth
{
    [tester showLikeEntityRow];
    [tester tapViewWithAccessibilityLabel:@"Skip"];
    [tester waitForViewWithAccessibilityLabel:@"tableView"];
}

- (void) testLikeTwitterAuth
{
    [tester showLikeEntityRow];
    [tester tapViewWithAccessibilityLabel:@"twitter"];
    [tester authWithTwitter];
    
    [tester tapViewWithAccessibilityLabel:@"Like"];
    [tester waitForViewWithAccessibilityLabel:@"tableView"];
}

- (void) testDirectURLNotification
{
    [tester showDirectUrlNotifications];
    
    [tester waitForTappableViewWithAccessibilityLabel:@"Done"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"In progress"];
    [tester tapViewWithAccessibilityLabel:@"Done"];
}

- (void) testComposeCommentNoAuth
{
    [tester showCommentComposer];
    [tester enterText:@"Anonymous Comment"  intoViewWithAccessibilityLabel:@"Comment Entry"];
    [tester tapViewWithAccessibilityLabel:@"Continue"];
    [tester tapViewWithAccessibilityLabel:@"Skip"];
    [tester waitForViewWithAccessibilityLabel:@"tableView"];
}

- (void) testCommentsList
{
    NSUInteger numRows = 50;
    
    
    NSString *entityKey = [TestAppHelper testURL:[NSString stringWithFormat:@"%s/entity1", sel_getName(_cmd)]];
    id<SZEntity> entity = [SZEntity entityWithKey:entityKey name:@"Test"];
    [[TestAppListViewController sharedSampleListViewController] setEntity:entity];
    
    NSMutableArray *comments = [NSMutableArray array];
    for (int i = 0; i < numRows / 2; i++) {
        id<SZComment> comment = [SZComment commentWithEntity:entity text:[NSString stringWithFormat:@"Comment%02d", i]];
        [comments addObject:comment];
    }
    [[SZTestHelper sharedTestHelper] createComments:comments];
    

    comments = [NSMutableArray array];
    for (int i = numRows / 2; i < numRows; i++) {
        id<SZComment> comment = [SZComment commentWithEntity:entity text:[NSString stringWithFormat:@"Comment%02d", i]];
        [comments addObject:comment];
    }
    [[SZTestHelper sharedTestHelper] createComments:comments];
    
    
    [tester showCommentsList];
    // Wait to see first comment
    [tester waitForViewWithAccessibilityLabel:[NSString stringWithFormat:@"Comment%02d", numRows - 1]];
    
    
    // Trigger a load
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:19 inSection:0];
    [tester scrollTableViewWithAccessibilityLabel:@"Comments Table View" toRowAtIndexPath:lastPath scrollPosition:UITableViewScrollPositionTop animated:YES];

    [tester waitForViewWithAccessibilityLabel:[NSString stringWithFormat:@"Comment%02d", 29]];
    
    // Trigger another load
    lastPath = [NSIndexPath indexPathForRow:39 inSection:0];
    
    [tester scrollTableViewWithAccessibilityLabel:@"Comments Table View" toRowAtIndexPath:lastPath scrollPosition:UITableViewScrollPositionTop animated:YES];
    
    // Show and hide add comment
    [tester tapViewWithAccessibilityLabel:@"add comment button"];
    [tester tapViewWithAccessibilityLabel:@"Cancel"];
    [tester tapViewWithAccessibilityLabel:@"Close"];
}

- (void)testProgrammaticNotificationDismissal
{
    [tester openSocializeDirectURLNotificationWithURL:@"http://www.getsocialize.com"];
    [tester waitForViewWithAccessibilityLabel:@"Done"];
    [tester openSocializeDirectURLNotificationWithURL:@"http://www.getsocialize.com"];
    
    [tester waitForViewWithAccessibilityLabel:@"Done"];
    [tester waitForTimeInterval:1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeShouldDismissAllNotificationControllersNotification object:nil];

    [tester waitForViewWithAccessibilityLabel:@"tableView"];
}

@end
