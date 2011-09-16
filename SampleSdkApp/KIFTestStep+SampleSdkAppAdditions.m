//
//  KIFTestStep+SampleAdditions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "KIFTestStep+SampleSdkAppAdditions.h"
#import "SampleSdkAppAppDelegate.h"
@implementation KIFTestStep (SampleSdkAppAdditions)

+ (id)stepToReset;
{
    return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
        BOOL successfulReset = YES;
        
        SampleSdkAppAppDelegate* appDelegate = (SampleSdkAppAppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *testListController = [appDelegate.rootController.viewControllers objectAtIndex:1];
        [appDelegate.rootController popToViewController:testListController animated:NO];
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
    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Test create an Entity" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Create Entity"]];    
    int randomNum = arc4random() % 999999999999;
    NSString *randomString = [NSString stringWithFormat:@"http://www.example.com/%i", randomNum];
    [steps addObject:[KIFTestStep stepToEnterText:randomString intoViewWithAccessibilityLabel:@"entityField"]];
    [steps addObject:[KIFTestStep stepToEnterText:@"Google" intoViewWithAccessibilityLabel:@"nameField"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"createButton"]];
    return steps;
}

+ (NSArray*)stepsToGetEntity;
{
    NSMutableArray *steps = [NSMutableArray array];
    //add steps
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Test get an Entity" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Get Entity"]];    
    [steps addObject:[KIFTestStep stepToEnterText:@"http://www.google.com" intoViewWithAccessibilityLabel:@"entityField"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"getEntityButton"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"resultTextField" value:@"success"traits:UIAccessibilityTraitNone]];
    return steps;
}

@end
