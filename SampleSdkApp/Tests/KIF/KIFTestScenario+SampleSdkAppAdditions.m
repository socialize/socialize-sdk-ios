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
@implementation KIFTestScenario (SampleSdkAppAdditions)

//+ (id)scenarioToTestFacebook {
//    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that another user's profile can be viewed."];
//    NSString *comment = [NSString stringWithFormat:@"comment for %@", [SampleSdkAppKIFTestController runID]];
//    [scenario addStepsFromArray:[KIFTestStep stepsToCreateCommentWithControllerForEntity:@"http://www.getsocialize.com" comment:@"comment!"]];
//    [scenario addStep:[KIFTestStep stepToVerifyFacebookFeedContainsMessage:comment]];
//    
//    return scenario;
//}

+ (id)scenarioToTestViewOtherProfile {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that another user's profile can be viewed."];
    [scenario addStep:[KIFTestStep stepToDisableValidFacebookSession]];
    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateCommentWithControllerForEntity:url comment:@"comment!"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToGetCommentsForEntity:url]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"profile button"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"profile button"]];
    
    // edit should be here (our profile)
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Settings"]];
    
    // Exit and auth as new user
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToReturnToAuth]];
    [scenario addStepsFromArray:[KIFTestStep stepsToAuthenticate]];

    // View profile as a new user, verify not editable
    [scenario addStepsFromArray:[KIFTestStep stepsToGetCommentsForEntity:url]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"profile button"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"profile button"]];
    [scenario addStep:[KIFTestStep stepToVerifyElementWithAccessibilityLabelDoesNotExist:@"Settings"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1 description:@"end"]];

    return scenario;
}

+ (id)scenarioToTestCommentsViewControllerWithAutoAuth {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that test that socialize UI views work even when not logged in."];
    [scenario addStep:[KIFTestStep stepToDisableValidFacebookSession]];
    [scenario addStepsFromArray:[KIFTestStep stepsToNoAuth]];
    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    NSString *commentString = [NSString stringWithFormat:@"Comment from %s", _cmd];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateCommentWithControllerForEntity:url comment:commentString]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyCommentExistsForEntity:url comment:commentString]];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Comments List"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];   
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tests"]];   
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Authenticate"]];   
    return scenario;
}

+ (id)scenarioToTestActionBar {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the Socialize Action Bar"];
    [scenario addStep:[KIFTestStep stepToDisableValidFacebookSession]];
    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [scenario addStepsFromArray:[KIFTestStep stepsToShowTabbedActionBarForURL:url]];
    [scenario addStep:[KIFTestStep stepToVerifyViewWithAccessibilityLabel:@"Socialize Action View" passesTest:^BOOL(id view) {
        return CGRectEqualToRect(CGRectMake(0, 343, 320, 44), [view frame]);
    }]];
    
    // Swap tabs and make sure views increments
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:1]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Featured"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Action Bar!"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"In progress"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:2]];
    
    // Verify we can like
    [scenario addStepsFromArray:[KIFTestStep stepsToLikeOnActionBar]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarLikesAtCount:1]];

    // Make sure post comment shows the comment controller. Make sure views does not increment again
    [scenario addStepsFromArray:[KIFTestStep stepsToCommentOnActionBar]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"add comment button"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateComment:@"actionbar comment"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];
    [scenario addStep:[KIFTestStep stepToCheckAccessibilityLabel:@"comment button" hasValue:@"1"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:2]];
    
    // Post a share
    [scenario addStep:[KIFTestStep stepToEnableValidFacebookSession]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Share"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Share via Facebook"]];
//    Actual share disabled until i can get a test facebook account set up
//    [scenario addStepsFromArray:[KIFTestStep stepsToCreateShare:@"actionbar share"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Do you want to log in with Facebook?"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"No"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:2]];
    [scenario addStep:[KIFTestStep stepToDisableValidFacebookSession]];
    
    [scenario addStep:[KIFTestStep stepToEnableValidFacebookSession]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Share"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Share via Twitter"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Do you want to log in with Twitter?"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Yes"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:2]];
    [scenario addStep:[KIFTestStep stepToDisableValidFacebookSession]];


    // Verify we can show the in-app MFMailComposer
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Share"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Share via Email"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Send"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Delete Draft"]];
    

    return scenario;
}


+ (id)scenarioToTestUserProfile {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test Socialize User Profiles"];
    [scenario addStep:[KIFTestStep stepToDisableValidFacebookSession]];

    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    NSString *commentText = [NSString stringWithFormat:@"comment for %@", [SampleSdkAppKIFTestController runID]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateCommentWithControllerForEntity:url comment:commentText]];

    NSString *firstName = @"Test First Name";
    [scenario addStepsFromArray:[KIFTestStep stepsToOpenProfile]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:commentText]];
    [scenario addStepsFromArray:[KIFTestStep stepsToOpenEditProfile]];
    [scenario addStepsFromArray:[KIFTestStep stepsToEditProfileImage]];
    [scenario addStepsFromArray:[KIFTestStep stepsToSetProfileFirstName:firstName]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Save"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyProfileFirstName:firstName]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    
    return scenario;
}

+ (id)scenarioToAuthenticate {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully log in."];
    [scenario addStepsFromArray:[KIFTestStep stepsToAuthenticate]];
    return scenario;
}


@end
