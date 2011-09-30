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

+ (id)scenarioToCreateComment {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a comment can be created."];

    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateEntityWithURL:url name:nil]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateCommentForEntity:url comment:@"A comment!"]];
    
    return scenario;
}

+ (id)scenarioToGetComments {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a comment can be fetched once created."];
    
    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateEntityWithURL:url name:nil]];
    NSString *commentString = [NSString stringWithFormat:@"Comment from %s", _cmd];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateCommentForEntity:url comment:commentString]];
    [scenario addStepsFromArray:[KIFTestStep stepsToGetCommentsForEntity:url]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyCommentExistsForEntity:url comment:commentString]];
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

+ (id)scenarioToTestCreateCommentViewController {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a comment can created through the socialize comment creation controller."];
    
    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateEntityWithURL:url name:nil]];
    NSString *commentString = [NSString stringWithFormat:@"Comment from %s", _cmd];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateCommentWithControllerForEntity:url comment:commentString]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyCommentExistsForEntity:url comment:commentString]];
    return scenario;
}


@end
