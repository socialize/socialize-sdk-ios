//
//  KIFTestStep+SampleAdditions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "KIFTestStep+SampleSdkAppAdditions.h"

@implementation KIFTestStep (SampleSdkAppAdditions)

+ (id)stepToReset;
{
    return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
        BOOL successfulReset = YES;
        
        // Do the actual reset for your app. Set successfulReset = NO if it fails.
        
        KIFTestCondition(successfulReset, error, @"Failed to reset the application.");
        
        return KIFTestStepResultSuccess;
    }];
}

+ (NSArray*)stepsToAuthenticate;
{
    NSMutableArray *steps = [NSMutableArray array];
    
    // Tap the "I already have an account" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"authenticate"]];
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Test List"]];
    
    return steps;
}

+ (NSArray*)stepsToCreateEntity;
{
    NSMutableArray *steps = [NSMutableArray array];
    
    // Tap the "I already have an account" button
//    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Test create and Entity"]];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Test get an Entity" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Get Entity"]];
    
    return steps;
}

@end
