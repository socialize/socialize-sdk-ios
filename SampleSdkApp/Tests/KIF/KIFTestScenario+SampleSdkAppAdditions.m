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

+ (id)scenarioToTestCommentsViewControllerWithAutoAuth {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that test that socialize UI views work even when not logged in."];
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
    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [scenario addStepsFromArray:[KIFTestStep stepsToShowTabbedActionBarForURL:url]];
    [scenario addStep:[KIFTestStep stepToVerifyViewWithAccessibilityLabel:@"Socialize Action View" passesTest:^BOOL(id view) {
        return CGRectEqualToRect(CGRectMake(0, 343, 320, 44), [view frame]);
    }]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:1]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Featured"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Action Bar!"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"In progress"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:2]];
    
    [scenario addStepsFromArray:[KIFTestStep stepsToLikeOnActionBar]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarLikesAtCount:1]];

    [scenario addStepsFromArray:[KIFTestStep stepsToCommentOnActionBar]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"add comment button"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateComment:@"actionbar comment"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];
    [scenario addStep:[KIFTestStep stepToCheckAccessibilityLabel:@"comment button" hasValue:@"1"]];

    return scenario;
}


+ (id)scenarioToTestUserProfile {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test Socialize User Profiles"];
    [scenario addStepsFromArray:[KIFTestStep stepsToTestUserProfile]];
    return scenario;
}

+ (id)scenarioToAuthenticate {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully log in."];
    [scenario addStepsFromArray:[KIFTestStep stepsToAuthenticate]];
    return scenario;
}

+ (id)scenarioToCreateEntity {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"entity create scenario."];
    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateEntityWithURL:url name:nil]];
    return scenario;
}

+ (id)scenarioToGetEntity {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a an entity can be created and that it exists on the server after creation."];

    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateEntityWithURL:url name:nil]];
    [scenario addStepsFromArray:[KIFTestStep stepsToGetEntityWithURL:url]];
    return scenario;
}

+ (id)scenarioToLikeAndUnlikeEntity {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that an entity can be liked"];
    
    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateEntityWithURL:url name:nil]];
    [scenario addStepsFromArray:[KIFTestStep stepsToLikeEntity:url]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyLikesForEntity:url areAtCount:1]];
    [scenario addStepsFromArray:[KIFTestStep stepsToUnlikeEntity:url]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyLikesForEntity:url areAtCount:0]];

    return scenario;
}

+ (id)scenarioToViewEntity {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that an entity can be viewed"];
    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateEntityWithURL:url name:nil]];
    [scenario addStepsFromArray:[KIFTestStep stepsToViewEntityWithURL:url]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyViewsForEntity:url areAtCount:1]];

    return scenario;
}




@end
