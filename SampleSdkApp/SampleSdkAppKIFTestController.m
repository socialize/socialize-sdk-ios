//
//  SampleKIFTestController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SampleSdkAppKIFTestController.h"

@implementation SampleSdkAppKIFTestController

- (void)initializeScenarios;
{
    [self addScenario:[KIFTestScenario scenarioToAuthenticate]];
    [self addScenario:[KIFTestScenario scenarioToGetEntity]];
    [self addScenario:[KIFTestScenario scenarioToCreateEntity]];

    // Add additional scenarios you want to test here
}

@end
