//
//  KIFTestScenario+SampleAdditions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "KIFTestScenario+SampleSdkAppAdditions.h"

@implementation KIFTestScenario (SampleSdkAppAdditions)

+ (id)scenarioToAuthenticate;
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully log in."];
    [scenario addStepsFromArray:[KIFTestStep stepsToAuthenticate]];
    return scenario;
}

+ (id)scenarioToGetEntity;
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"entity get scenario."];
    [scenario addStep:[KIFTestStep stepToReset]];
    [scenario addStepsFromArray:[KIFTestStep stepsToGetEntity]];
    
    return scenario;
}
+ (id)scenarioToCreateEntity;
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"entity create scenario."];
    [scenario addStep:[KIFTestStep stepToReset]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateEntity]];
    return scenario;
}
@end
