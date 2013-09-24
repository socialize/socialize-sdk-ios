//
//  KIFUITestActor+TestApp.m
//  Socialize
//
//  Created by Sergey Popenko on 9/23/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "KIFUITestActor+TestApp.h"
#import "TestAppListViewController.h"
#import <KIF/UIApplication-KIFAdditions.h>
#import <KIF/UIAccessibilityElement-KIFAdditions.h>
#import <KIF/CGGeometry-KIFAdditions.h>

@interface KIFUITestActor(private)
- (void)popNavigationControllerToIndex:(NSInteger)index;
- (void)checkAccessibilityLabel:(NSString *)label hasValue:(NSString *)hasValue;
@end

@implementation KIFUITestActor (TestApp)
- (void)popNavigationControllerToIndex:(NSInteger)index
{
    NSLog(@"Reset nav to level %d.", index);
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        BOOL successfulReset = YES;
        
        [[[TestAppListViewController sharedSampleListViewController] navigationController] popToRootViewControllerAnimated:NO];
        // Do the actual reset for your app. Set successfulReset = NO if it fails.
        KIFTestCondition(successfulReset, error, @"Failed to reset the application.");
        return KIFTestStepResultSuccess;
    }];
}

- (void)checkAccessibilityLabel:(NSString *)label hasValue:(NSString *)hasValue
{
    NSLog(@"Check value accessibility label: %@ has value: %@", label, hasValue);

    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:nil traits:UIAccessibilityTraitNone];
        UIView *view = (UIView*)[UIAccessibilityElement viewContainingAccessibilityElement:element];
        NSString *elementValue = nil;
        if ([view isKindOfClass:[UIButton class]]) {
            elementValue = [(UIButton *)view currentTitle];
        } else {
            //assume it's a UILabel
            elementValue = ((UILabel *)view).text;
        }
        if ( [elementValue isEqualToString:hasValue] ) {
            return KIFTestStepResultSuccess;
        } else {
            NSString *description = [NSString stringWithFormat:@"View with accessibility label \"%@\" has value \"%@\" but expected \"%@\"", label, elementValue, hasValue];
            *error = [[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure
                                             userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, NSLocalizedDescriptionKey, nil]];
            return KIFTestStepResultWait;
        }
    }];
}

- (void)initializeTest
{
    [self popNavigationControllerToIndex:0];
    [self waitForViewWithAccessibilityLabel:@"tableView"];
}

- (void)scrollAndTapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tap row %d in tableView with label %@", [indexPath row], tableViewLabel);

    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:tableViewLabel accessibilityValue:nil traits:UIAccessibilityTraitNone];
        
        KIFTestCondition(element, error, @"View with label %@ not found", tableViewLabel);
        UITableView *tableView = (UITableView*)[UIAccessibilityElement viewContainingAccessibilityElement:element];
        
        KIFTestCondition([tableView isKindOfClass:[UITableView class]], error, @"Specified view is not a UITableView");
        
        KIFTestCondition(tableView, error, @"Table view with label %@ not found", tableViewLabel);
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        CGRect cellFrame = [cell.contentView convertRect:[cell.contentView frame] toView:tableView];
        [tableView tapAtPoint:CGPointCenteredInRect(cellFrame)];
        
        return KIFTestStepResultSuccess;
    }];
}

- (void)verifyActionBarLikesAtCount:(NSInteger)count
{
    NSString *countString = [NSString stringWithFormat:@"%d", count];
    [self checkAccessibilityLabel:@"like button" hasValue:countString];
}

- (void)openActionBarExample
{
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowActionBarExampleRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showUserProfile
{
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowUserProfileRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)openEditProfile
{
    [self tapViewWithAccessibilityLabel:@"Settings"];
}

- (void)showButtonExample
{
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowButtonsExampleRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showLinkToFacebook
{
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kLinkToFacebookRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)wipeAuthData
{
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:@"Wipe Auth Data"];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

@end
