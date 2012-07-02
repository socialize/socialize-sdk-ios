//
//  KIFTestScenario+SampleAdditions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "KIFTestScenario+TestAppAdditions.h"
#import "KIFTestStep+TestAppAdditions.h"
#import "TestAppKIFTestController.h"
#import "SZTestHelper.h"
#import "TestAppListViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import <Socialize/Socialize.h>

@implementation KIFTestScenario (SampleSdkAppAdditions)

+ (NSArray*)stepsToInitializeTest {
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        [[SZTestHelper sharedTestHelper] removeAuthenticationInfo];
        [SZTwitterUtils unlink];
        [SZFacebookUtils unlink];
        [[TestAppListViewController sharedSampleListViewController] setEntity:nil];
    }]];
    return steps;
}

//+ (id)scenarioToTestFacebook {
//    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that another user's profile can be viewed."];
//    NSString *comment = [NSString stringWithFormat:@"comment for %@", [TestAppKIFTestController runID]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToCreateCommentWithControllerForEntity:@"http://www.getsocialize.com" comment:@"comment!"]];
//    [scenario addStep:[KIFTestStep stepToVerifyFacebookFeedContainsMessage:comment]];
//    
//    return scenario;
//}

//+ (id)scenarioToTestViewOtherProfile {
//    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that another user's profile can be viewed."];
//    [scenario addStep:[KIFTestStep stepToDisableValidFacebookSession]];
//    NSString *url = [TestAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToCreateCommentWithControllerForEntity:url comment:@"comment!"]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToGetCommentsForEntity:url]];
//    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"profile button"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"profile button"]];
//    
//    // edit should be here (our profile)
//    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Settings"]];
//    
//    // Exit and auth as new user
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToReturnToAuth]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToAuthenticate]];
//
//    // View profile as a new user, verify not editable
//    [scenario addStepsFromArray:[KIFTestStep stepsToGetCommentsForEntity:url]];
//    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"profile button"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"profile button"]];
//    [scenario addStep:[KIFTestStep stepToVerifyElementWithAccessibilityLabelDoesNotExist:@"Settings"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];
//    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1 description:@"end"]];
//
//    return scenario;
//}

//+ (id)scenarioToTestActionBar {
//    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the Socialize Action Bar"];
//    [scenario addStep:[KIFTestStep stepToDisableValidFacebookSession]];
//    NSString *url = [TestAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToShowTabbedActionBarForURL:url]];
//    [scenario addStep:[KIFTestStep stepToVerifyViewWithAccessibilityLabel:@"Socialize Action View" passesTest:^BOOL(id view) {
//        return CGRectEqualToRect(CGRectMake(0, 343, 320, 44), [view frame]);
//    }]];
//    
//    // Swap tabs and make sure views increments
//    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:1]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Featured"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Action Bar!"]];
//    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"In progress"]];
////    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:2]];
//    
//    // Verify we can like
//    [scenario addStepsFromArray:[KIFTestStep stepsToLikeOnActionBar]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarLikesAtCount:1]];
//
//    // Make sure post comment shows the comment controller. Make sure views does not increment again
//    [scenario addStepsFromArray:[KIFTestStep stepsToCommentOnActionBar]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"add comment button"]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToCreateComment:@"actionbar comment"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];
//    [scenario addStep:[KIFTestStep stepToCheckAccessibilityLabel:@"comment button" hasValue:@"1"]];
////    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:2]];
//    
//    // Post a share
//    [scenario addStep:[KIFTestStep stepToEnableValidFacebookSession]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Share"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Share via Facebook"]];
////    Actual share disabled until i can get a test facebook account set up
////    [scenario addStepsFromArray:[KIFTestStep stepsToCreateShare:@"actionbar share"]];
//    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Do you want to log in with Facebook?"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"No"]];
////    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:2]];
//    [scenario addStep:[KIFTestStep stepToDisableValidFacebookSession]];
//    
//    [scenario addStep:[KIFTestStep stepToEnableValidFacebookSession]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Share"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Share via Twitter"]];
////    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Do you want to log in with Twitter?"]];
////    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Yes"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
////    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:2]];
//    [scenario addStep:[KIFTestStep stepToDisableValidFacebookSession]];
//
//
//    // Verify we can show the in-app MFMailComposer
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Share"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Share via Email"]];
//    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Send"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Delete Draft"]];
//    
//
//    return scenario;
//}

+ (id)scenarioToTestUserProfile {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test Socialize User Profiles"];
    
    [scenario addStepsFromArray:[self stepsToInitializeTest]];
    
    NSString *url = [TestAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    NSString *commentText = [NSString stringWithFormat:@"comment for %@", [TestAppKIFTestController runID]];
    [scenario addStep:[KIFTestStep stepToExecuteBlock:^{
        id<SZEntity> entity = [SZEntity entityWithKey:url name:@"Test"];
        id<SZComment> comment = [SZComment commentWithEntity:entity text:commentText];
        [[SZTestHelper sharedTestHelper] createComment:comment];
    }]];
    
//    NSString *firstName = @"Test First Name";
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowUserProfileRow];
    [scenario addStep:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:commentText]];
    [scenario addStepsFromArray:[KIFTestStep stepsToOpenEditProfile]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToSetProfileFirstName:firstName]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Save"]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyProfileFirstName:firstName]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Back"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    
    return scenario;
}

+ (id)scenarioToSleep {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test nothing."];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:5 description:@"Waiting"]];
    return scenario;
}

+ (id)scenarioToTestLikeButton {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the like button"];
    
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[self stepsToInitializeTest]];
    
    // Set up a test entity
    NSString *entityKey = [TestAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        id<SZEntity> entity = [SZEntity entityWithKey:entityKey name:@"Test"];
        [[TestAppListViewController sharedSampleListViewController] setEntity:entity];
    }]];
    
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowButtonsExampleRow];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];
    

    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"like button"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Skip"]];
    [steps addObjectsFromArray:[KIFTestStep stepsToVerifyActionBarLikesAtCount:1]];

    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"like button"]];
//    [steps addObjectsFromArray:[KIFTestStep stepsToVerifyActionBarLikesAtCount:0]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];

    [scenario addStepsFromArray:steps];
    
    return scenario;
}

+ (id)scenarioToTestActionBar {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the like button"];
    
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[self stepsToInitializeTest]];
    
    // Set up a test entity
    NSString *entityKey = [TestAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        id<SZEntity> entity = [SZEntity entityWithKey:entityKey name:@"Test"];
        [[TestAppListViewController sharedSampleListViewController] setEntity:entity];
    }]];
    
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowActionBarExampleRow];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];
    
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"comment button"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];

    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"views button"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"share button"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];

    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"like button"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Skip"]];
    [steps addObjectsFromArray:[KIFTestStep stepsToVerifyActionBarLikesAtCount:1]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"like button"]];
    
    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SocializeAuthenticatedUserDidChangeNotification object:[SZUserUtils currentUser]];
    }]];
    
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"In progress"]];
    [steps addObject:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"In progress"]];
     
//    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    

    [scenario addStepsFromArray:steps];
    
    return scenario;
}

+ (id)scenarioToTestDirectURLNotification {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the like button"];
    
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[self stepsToInitializeTest]];

    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kHandleDirectURLSmartAlertRow];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];

    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Done"]];
    [steps addObject:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"In progress"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    
    [scenario addStepsFromArray:steps];
    
    return scenario;
}

+ (id)scenarioToTestFacebookAuth {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test Facebook Auth Process"];
    
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[self stepsToInitializeTest]];

    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        [[SZTestHelper sharedTestHelper] startMockingSucceedingFacebookAuthWithDidAuth:nil];
    }]];

    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kLinkToFacebookRow];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Facebook link successful"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Ok"]];

    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        [[SZTestHelper sharedTestHelper] stopMockingSucceedingFacebookAuth];
    }]];
    [steps addObject:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"In progress"]];

    [scenario addStepsFromArray:steps];
    
    return scenario;
}

+ (id)scenarioToTestTwitterAuth {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test Twitter Auth Process"];
    
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[self stepsToInitializeTest]];
    
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kLinkToTwitterRow];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];
    [steps addObjectsFromArray:[KIFTestStep stepsToAuthWithTestTwitterInfo]];
    
    [scenario addStepsFromArray:steps];
    
    return scenario;
}

+ (id)scenarioToTestCommentsList {
    NSUInteger numRows = 50;
    
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test comments list."];
    
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[self stepsToInitializeTest]];

    NSString *entityKey = [TestAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    id<SZEntity> entity = [SZEntity entityWithKey:entityKey name:@"Test"];

    // Set a specific entity for this test
    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        [[TestAppListViewController sharedSampleListViewController] setEntity:entity];
    }]];

    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        NSMutableArray *comments = [NSMutableArray array];
        for (int i = 0; i < numRows; i++) {
            id<SZComment> comment = [SZComment commentWithEntity:entity text:[NSString stringWithFormat:@"Comment%02d", i]];
            [comments addObject:comment];
        }
        [[SZTestHelper sharedTestHelper] createComments:comments];
    }]];

    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowCommentsListRow];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];

    // Wait to see first comment
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:[NSString stringWithFormat:@"Comment%02d", numRows - 1]]];

    // Trigger a load
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:19 inSection:0];
    [steps addObject:[KIFTestStep stepToScrollTableViewWithAccessibilityLabel:@"Comments Table View" toRowAtIndexPath:lastPath scrollPosition:UITableViewScrollPositionTop animated:YES]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:[NSString stringWithFormat:@"Comment%02d", 29]]];

    // Trigger another load
    lastPath = [NSIndexPath indexPathForRow:39 inSection:0];
    [steps addObject:[KIFTestStep stepToScrollTableViewWithAccessibilityLabel:@"Comments Table View" toRowAtIndexPath:lastPath scrollPosition:UITableViewScrollPositionTop animated:YES]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:[NSString stringWithFormat:@"Comment%02d", 9]]];

    // Show and hide add comment
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"add comment button"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];

    [scenario addStepsFromArray:steps];
    
    return scenario;
}


+ (id)scenarioToTestComposeCommentNoAuth {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test comment composer with anon."];
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObjectsFromArray:[self stepsToInitializeTest]];

    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowCommentComposerRow];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];

    [steps addObject:[KIFTestStep stepToEnterText:@"Anonymous Comment" intoViewWithAccessibilityLabel:@"Comment Entry"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Send"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Skip"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"tableView"]];;

    [scenario addStepsFromArray:steps];
    return scenario;
}

+ (id)scenarioToTestComposeCommentTwitterAuth {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test comment composer with Twitter."];
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObjectsFromArray:[self stepsToInitializeTest]];
    
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowCommentComposerRow];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];
    
    [steps addObject:[KIFTestStep stepToEnterText:@"Twitter Comment" intoViewWithAccessibilityLabel:@"Comment Entry"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Send"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"twitter"]];
    [steps addObjectsFromArray:[KIFTestStep stepsToAuthWithTestTwitterInfo]];
    [steps addObject:[KIFTestStep stepToVerifyViewWithAccessibilityLabel:@"Twitter Switch" passesTest:^(UISwitch *sw) {
        return sw.isOn;
    }]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Continue"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"tableView"]];;

    [scenario addStepsFromArray:steps];
    return scenario;
}

+ (id)scenarioToTestComposeCommentFacebookAuth {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test comment composer with Facebook."];
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObjectsFromArray:[self stepsToInitializeTest]];
    
    // Select composer in test list
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowCommentComposerRow];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];
    
    // Type in a test message
    [steps addObject:[KIFTestStep stepToEnterText:@"Facebook Comment" intoViewWithAccessibilityLabel:@"Comment Entry"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Send"]];
    
    // Mock out the facebook flow
    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        [[SZTestHelper sharedTestHelper] startMockingSucceedingFacebookAuthWithDidAuth:nil];
    }]];

    // Auth with Facebook, wait for completion
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"facebook"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Ok"]];
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Continue"]];
    
    // Unmock the facebook flow
    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        [[SZTestHelper sharedTestHelper] stopMockingSucceedingFacebookAuth];
    }]];

    // Facebook Switch should be on
    [steps addObject:[KIFTestStep stepToVerifyViewWithAccessibilityLabel:@"Facebook Switch" passesTest:^(UISwitch *sw) {
        return sw.isOn;
    }]];
    
    // Finish posting the comment
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Continue"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"tableView"]];;
    
    [scenario addStepsFromArray:steps];
    return scenario;
}

+ (id)scenarioToTestLikeNoAuth {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test Anonymous Like."];
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObjectsFromArray:[self stepsToInitializeTest]];

    // Select composer in test list
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kLikeEntityRow];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];

    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Skip"]];

    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"tableView"]];;
    
    [scenario addStepsFromArray:steps];
    return scenario;
}

+ (id)scenarioToTestLikeTwitterAuth {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test Like with Twitter Auth"];
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObjectsFromArray:[self stepsToInitializeTest]];
    
    // Select composer in test list
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kLikeEntityRow];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];
    
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"twitter"]];
    [steps addObjectsFromArray:[KIFTestStep stepsToAuthWithTestTwitterInfo]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Continue"]];

    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"tableView"]];;
    
    [scenario addStepsFromArray:steps];
    return scenario;
}

+ (id)scenarioToTestProgrammaticNotificationDismissal {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the like button"];
    
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    
    [steps addObject:[KIFTestStep stepWithDescription:@"Open multiple notifications" executionBlock:^(KIFTestStep *step, NSError **error) {
        NSDictionary *socializeInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"http://www.getsocialize.com/", @"url",
                                       @"developer_direct_url", @"notification_type",
                                       nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:socializeInfo forKey:@"socialize"];     
        
        [Socialize handleNotification:userInfo];
        [Socialize handleNotification:userInfo];
        
        return KIFTestStepResultSuccess;
    }]];
    
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Done"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:1 description:@"Delay"]];
    
    
    [steps addObject:[KIFTestStep stepWithDescription:@"Post Notification" executionBlock:^(KIFTestStep *step, NSError **error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SocializeShouldDismissAllNotificationControllersNotification object:nil];
        
        return KIFTestStepResultSuccess;
    }]];
    
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"tableView"]];
    
    [scenario addStepsFromArray:steps];
    
    return scenario;
}


@end
