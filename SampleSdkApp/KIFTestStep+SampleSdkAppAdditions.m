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

+ (id)stepToReturnToList;
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

+ (NSArray*)stepsToWaitForActionCompleted {
    NSMutableArray *steps = [NSMutableArray array];

    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Socialize Action View"]];
    [steps addObject:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Socialize Action View"]];
    
    return steps;
}

+ (NSArray*)stepsToCreateEntityWithURL:(NSString*)url name:(NSString*)name;
{
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObject:[KIFTestStep stepToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Test create an Entity" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Create Entity"]];    
    [steps addObject:[KIFTestStep stepToEnterText:url intoViewWithAccessibilityLabel:@"entityField"]];
    if (name != nil) {
        [steps addObject:[KIFTestStep stepToEnterText:name intoViewWithAccessibilityLabel:@"nameField"]];
    }
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"createButton"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"resultTextField" value:@"success"traits:UIAccessibilityTraitNone]];

    return steps;
}

+ (NSArray*)stepsToCreateEntityWithRandomURL;
{
    int randomNum = arc4random() % 999999999999;
    NSString *randomString = [NSString stringWithFormat:@"http://www.example.com/%i", randomNum];
    return [self stepsToCreateEntityWithURL:randomString name:nil];;
}

+ (NSArray*)stepsToGetEntityWithURL:(NSString*)url;
{
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObject:[KIFTestStep stepToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Test get an Entity" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Get Entity"]];    
    [steps addObject:[KIFTestStep stepToEnterText:url intoViewWithAccessibilityLabel:@"entityField"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"getEntityButton"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"resultTextField" value:@"success"traits:UIAccessibilityTraitNone]];
    return steps;
}

+ (NSArray*)stepsToCreateCommentForEntity:(NSString*)entity comment:(NSString*)comment
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObject:[KIFTestStep stepToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Test create a comment" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Create Comment"]];    
    [steps addObject:[KIFTestStep stepToEnterText:entity intoViewWithAccessibilityLabel:@"entityField"]];
    [steps addObject:[KIFTestStep stepToEnterText:comment intoViewWithAccessibilityLabel:@"commentField"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"createButton"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"resultTextField" value:@"success"traits:UIAccessibilityTraitNone]];
    return steps;
}

+ (NSArray*)stepsToCreateCommentWithControllerForEntity:(NSString*)entity comment:(NSString*)comment
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObject:[KIFTestStep stepToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:7 inSection:0];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Test create comment view controller" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Enter"]];
    [steps addObject:[KIFTestStep stepToEnterText:entity intoViewWithAccessibilityLabel:@"Input Field"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Enter"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Comment Entry"]];
    [steps addObject:[KIFTestStep stepToEnterText:comment intoViewWithAccessibilityLabel:@"Comment Entry"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Send"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Facebook?"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"No"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Anonymous?"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Ok"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Tests"]];
    return steps;
}


+ (NSArray*)stepsToGetCommentsForEntity:(NSString*)entity
{
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObject:[KIFTestStep stepToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Test get comments for an entity" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Fetch Comment"]];    
    [steps addObject:[KIFTestStep stepToEnterText:entity intoViewWithAccessibilityLabel:@"entityField"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"getCommentsButton"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Comments List"]];
    return steps;
}

+ (NSArray*)stepsToVerifyCommentExistsForEntity:(NSString*)entity comment:(NSString*)comment {
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObject:[KIFTestStep stepToReturnToList]];
    [steps addObjectsFromArray:[self stepsToGetCommentsForEntity:entity]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Comment Cell"]];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Comments Table View" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:comment]];
    
    return steps;
}

+ (NSArray*)stepsToLikeEntity:(NSString*)entity
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObject:[KIFTestStep stepToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:4 inSection:0];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Test like/unlike" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Create a like/unlike"]];    
    [steps addObject:[KIFTestStep stepToEnterText:entity intoViewWithAccessibilityLabel:@"entityField"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"likeButton"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"resultTextField" value:@"success" traits:UIAccessibilityTraitNone]];
    return steps;
}

+ (NSArray*)stepsToUnlikeEntity:(NSString*)entity
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObject:[KIFTestStep stepToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:4 inSection:0];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Test like/unlike" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Create a like/unlike"]];    
    [steps addObject:[KIFTestStep stepToEnterText:entity intoViewWithAccessibilityLabel:@"entityField"]];
    
    // FIXME: The test UI currently does not allow unlike to be the first action, so like before unliking
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"likeButton"]];
//    [steps addObjectsFromArray:[KIFTestStep stepsToWaitForActionCompleted]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"resultTextField" value:@"success" traits:UIAccessibilityTraitNone]];
    
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"unlikeButton"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"unlikeButton"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"resultTextField" value:@"success" traits:UIAccessibilityTraitNone]];
    return steps;
}


+ (NSArray*)stepsToVerifyLikesForEntity:(NSString*)entity areAtCount:(NSInteger)count
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[KIFTestStep stepsToGetEntityWithURL:entity]];
    NSString *countString = [NSString stringWithFormat:@"%d", count];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"likesCount" value:countString traits:UIAccessibilityTraitNone]];
    return steps;
}

+ (NSArray*)stepsToViewEntityWithURL:(NSString*)url;
{
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObject:[KIFTestStep stepToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:6 inSection:0];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Test create view" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Test create a view"]];    
    [steps addObject:[KIFTestStep stepToEnterText:url intoViewWithAccessibilityLabel:@"entityField"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"createViewButton"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"resultTextField" value:@"success"traits:UIAccessibilityTraitNone]];
    return steps;
}

+ (NSArray*)stepsToVerifyViewsForEntity:(NSString*)entity areAtCount:(NSInteger)count
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[KIFTestStep stepsToGetEntityWithURL:entity]];
    NSString *countString = [NSString stringWithFormat:@"%d", count];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"viewsCount" value:countString traits:UIAccessibilityTraitNone]];
    return steps;
}


@end
