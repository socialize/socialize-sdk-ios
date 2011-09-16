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
    [scenario addStep:[KIFTestStep stepToReset]];
    [scenario addStepsFromArray:[KIFTestStep stepsToAuthenticate]];
    
    return scenario;
}

@end
