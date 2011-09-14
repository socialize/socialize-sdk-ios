//
//  SampleKIFTestController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SampleKIFTestController.h"

@implementation SampleKIFTestController

- (void)initializeScenarios;
{
    [self addScenario:[KIFTestScenario scenarioToAuthenticate]];
    // Add additional scenarios you want to test here
}

@end
