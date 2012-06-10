//
//  KIFTestScenario+SampleAdditions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "KIFTestScenario+SampleSdkAppAdditions.h"
#import "KIFTestStep+SampleSdkAppAdditions.h"
#import "SampleSdkAppKIFTestController.h"
#import "SZTestHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "SZTwitterUtils.h"
#import "SampleSdkAppAppDelegate.h"
#import "SZFacebookUtils.h"

@implementation KIFTestScenario (SampleSdkAppAdditions)

+ (SampleListViewController*)sampleListViewController {
    return [[SampleSdkAppAppDelegate sharedDelegate] sampleListViewController];
}

+ (NSArray*)stepsToInitializeTest {
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        [[SZTestHelper sharedTestHelper] removeAuthenticationInfo];
        [SZTwitterUtils unlink];
        [SZFacebookUtils unlink];
        [[SampleSdkAppAppDelegate sharedDelegate] setGlobalEntity:nil];
    }]];
    return steps;
}

//+ (id)scenarioToTestFacebook {
//    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that another user's profile can be viewed."];
//    NSString *comment = [NSString stringWithFormat:@"comment for %@", [SampleSdkAppKIFTestController runID]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToCreateCommentWithControllerForEntity:@"http://www.getsocialize.com" comment:@"comment!"]];
//    [scenario addStep:[KIFTestStep stepToVerifyFacebookFeedContainsMessage:comment]];
//    
//    return scenario;
//}

//+ (id)scenarioToTestViewOtherProfile {
//    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that another user's profile can be viewed."];
//    [scenario addStep:[KIFTestStep stepToDisableValidFacebookSession]];
//    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
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
//    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
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
    
    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    NSString *commentText = [NSString stringWithFormat:@"comment for %@", [SampleSdkAppKIFTestController runID]];
    [scenario addStep:[KIFTestStep stepToExecuteBlock:^{
        id<SZEntity> entity = [SZEntity entityWithKey:url name:@"Test"];
        id<SZComment> comment = [SZComment commentWithEntity:entity text:commentText];
        [[SZTestHelper sharedTestHelper] createComment:comment];
    }]];
    
    NSString *firstName = @"Test First Name";
    [scenario addStepsFromArray:[KIFTestStep stepsToOpenProfile]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:commentText]];
    [scenario addStepsFromArray:[KIFTestStep stepsToOpenEditProfile]];
    [scenario addStepsFromArray:[KIFTestStep stepsToSetProfileFirstName:firstName]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Save"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyProfileFirstName:firstName]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    
    return scenario;
}

+ (id)scenarioToSleep {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test nothing."];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:5 description:@"Waiting"]];
    return scenario;
}

//+ (id)scenarioToTestLikeButton {
//    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the like button"];
//    [scenario addStep:[KIFTestStep stepToDisableValidFacebookSession]];
//    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToShowButtonTestController:url]];
//    
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"like button"]];
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Skip"]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarLikesAtCount:1]];
//
//    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"like button"]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarLikesAtCount:0]];
//    return scenario;
//}

+ (id)scenarioToTestDirectURLNotification {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the like button"];
    
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[self stepsToInitializeTest]];

    NSIndexPath *path = [NSIndexPath indexPathForRow:16 inSection:0];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Input Field"]];
    [steps addObject:[KIFTestStep stepToEnterText:@"http://www.google.com" intoViewWithAccessibilityLabel:@"Input Field"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Enter"]];
    
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Done"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    
    [scenario addStepsFromArray:steps];
    
    return scenario;
}

+ (id)scenarioToTestFacebookAuth {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test Facebook Auth Process"];
    
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[self stepsToInitializeTest]];

    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        [[SZTestHelper sharedTestHelper] startMockingSucceedingFacebookAuth];
    }]];

    NSIndexPath *indexPath = [[self sampleListViewController] indexPathForRowIdentifier:kLinkToFacebookRow];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Yes"]];

    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        [[SZTestHelper sharedTestHelper] stopMockingSucceedingFacebookAuth];
    }]];

    [scenario addStepsFromArray:steps];
    
    return scenario;
}

+ (id)scenarioToTestTwitterAuth {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test Twitter Auth Process"];
    
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[self stepsToInitializeTest]];
    
    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
    }]];
    
    NSIndexPath *indexPath = [[self sampleListViewController] indexPathForRowIdentifier:kLinkToTwitterRow];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];
    
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Username or email"]];
    [steps addObject:[KIFTestStep stepToNoCheckEnterText:@"mr_socialize" intoViewWithAccessibilityLabel:@"Username or email" traits:UIAccessibilityTraitNone]];
    [steps addObject:[KIFTestStep stepToNoCheckEnterText:@"supersecret" intoViewWithAccessibilityLabel:@"Password" traits:UIAccessibilityTraitNone]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Sign In"]];
    [steps addObject:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Twitter Auth"]];

    [scenario addStepsFromArray:steps];
    
    return scenario;
}

+ (id)scenarioToTestCommentsList {
    NSUInteger numRows = 50;
    
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test comments list."];
    
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[self stepsToInitializeTest]];

    NSString *entityKey = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    id<SZEntity> entity = [SZEntity entityWithKey:entityKey name:@"Test"];

    // Set a specific entity for this test
    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        [[SampleSdkAppAppDelegate sharedDelegate] setGlobalEntity:entity];
    }]];

    [steps addObject:[KIFTestStep stepToExecuteBlock:^{
        NSMutableArray *comments = [NSMutableArray array];
        for (int i = 0; i < numRows; i++) {
            id<SZComment> comment = [SZComment commentWithEntity:entity text:[NSString stringWithFormat:@"Comment%02d", i]];
            [comments addObject:comment];
        }
        [[SZTestHelper sharedTestHelper] createComments:comments];
    }]];

    NSIndexPath *indexPath = [[self sampleListViewController] indexPathForRowIdentifier:kShowCommentsListRow];
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

    [scenario addStepsFromArray:steps];
    
    return scenario;
}





@end
