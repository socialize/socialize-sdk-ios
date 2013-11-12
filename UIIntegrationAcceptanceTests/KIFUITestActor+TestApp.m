//
//  KIFUITestActor+TestApp.m
//  Socialize
//
//  Created by Sergey Popenko on 9/23/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "KIFUITestActor+TestApp.h"
#import "TestAppListViewController.h"
#import "SZTestHelper.h"
#import <KIF/UIApplication-KIFAdditions.h>
#import <KIF/UIAccessibilityElement-KIFAdditions.h>
#import <KIF/CGGeometry-KIFAdditions.h>
#import <KIF/UIWindow-KIFAdditions.h>

@interface KIFUITestActor(private)
- (void)popNavigationControllerToIndex:(NSInteger)index;
- (void)checkAccessibilityLabel:(NSString *)label hasValue:(NSString *)hasValue;
- (UIView*)viewWithAccessibilityLabel:(NSString*)label;
@end

@implementation KIFUITestActor (TestApp)

- (void)popNavigationControllerToIndex:(NSInteger)index {
    NSLog(@"Reset nav to level %d.", index);
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        BOOL successfulReset = YES;
        
        [[[TestAppListViewController sharedSampleListViewController] navigationController] popToRootViewControllerAnimated:NO];
        // Do the actual reset for your app. Set successfulReset = NO if it fails.
        KIFTestCondition(successfulReset, error, @"Failed to reset the application.");
        return KIFTestStepResultSuccess;
    }];
}

- (void)checkAccessibilityLabel:(NSString *)label hasValue:(NSString *)hasValue {
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

- (void)initializeTest {

    [self popNavigationControllerToIndex:0];
    [self waitForViewWithAccessibilityLabel:@"tableView"];
    

    [[SZTestHelper sharedTestHelper] removeAuthenticationInfo];
    [SZTwitterUtils unlink];
    [SZFacebookUtils unlink];
    [[TestAppListViewController sharedSampleListViewController] setEntity:nil];
}

//toggles between portrait and landscape modes
- (void)rotateDevice {
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    UIInterfaceOrientation newOrientation = currentOrientation == UIInterfaceOrientationLandscapeLeft ?
                                            UIInterfaceOrientationPortrait :
                                            UIInterfaceOrientationLandscapeLeft;
    UIDevice* device = [UIDevice currentDevice];
    SEL message = NSSelectorFromString(@"setOrientation:");
    
    if( [device respondsToSelector: message] ) {
        NSMethodSignature* signature = [UIDevice instanceMethodSignatureForSelector: message];
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature: signature];
        [invocation setTarget: device];
        [invocation setSelector: message];
        [invocation setArgument: &newOrientation atIndex: 2];
        [invocation invoke];
    }
}

- (void)authWithTwitter {
    [self waitForViewWithAccessibilityLabel:@"Twitter"];
    [self waitForTappableViewWithAccessibilityLabel:@"Username or email"];
    [self waitForAbsenceOfViewWithAccessibilityLabel:@"In progress"];
    
    NSLog(@"Waiting for web view");
    [self waitForTimeInterval:1];
    [self noCheckEnterText:@"mr_socialize"  intoViewWithAccessibilityLabel:@"Username or email" traits:UIAccessibilityTraitNone];
    [self waitForTimeInterval:10];
    
    [self tapViewWithAccessibilityLabel:@"Password"];
    [self tapViewWithAccessibilityLabel:@"Password"];
    [self noCheckEnterText:@"supersecret" intoViewWithAccessibilityLabel:@"Password" traits:UIAccessibilityTraitNone];
    [self tapViewWithAccessibilityLabel:@"Authorize app"];
}

- (void)noCheckEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits {
    NSLog(@"Type the text \"%@\" into the view with accessibility label \"%@\"", text, label);
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        
//        UIAccessibilityElement *element = [KIFTestStep _accessibilityElementWithLabel:label accessibilityValue:nil tappable:YES traits:traits error:error];
                UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:Nil traits:traits];
        if (!element) {
            return KIFTestStepResultWait;
        }
        
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(view, error, @"Cannot find view with accessibility label \"%@\"", label);
        
        CGRect elementFrame = [view.window convertRect:element.accessibilityFrame toView:view];
        CGPoint tappablePointInElement = [view tappablePointInRect:elementFrame];
        
        // This is mostly redundant of the test in _accessibilityElementWithLabel:
        KIFTestCondition(!isnan(tappablePointInElement.x), error, @"The element with accessibility label %@ is not tappable", label);
        [view tapAtPoint:tappablePointInElement];
        
        KIFTestWaitCondition([view isDescendantOfFirstResponder], error, @"Failed to make the view with accessibility label \"%@\" the first responder. First responder is %@", label, [[[UIApplication sharedApplication] keyWindow] firstResponder]);
        
        // Wait for the keyboard
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
        
        for (NSUInteger characterIndex = 0; characterIndex < [text length]; characterIndex++) {
            NSString *characterString = [text substringWithRange:NSMakeRange(characterIndex, 1)];
            [self enterTextIntoCurrentFirstResponder:characterString];
//            if (![self enterTextIntoCurrentFirstResponder:characterString]) {
//                // Attempt to cheat if we couldn't find the character
//                if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
//                    NSLog(@"KIF: Unable to find keyboard key for %@. Inserting manually.", characterString);
//                    [(UITextField *)view setText:[[(UITextField *)view text] stringByAppendingString:characterString]];
//                } else {
//                    KIFTestCondition(NO, error, @"Failed to find key for character \"%@\"", characterString);
//                }
//            }
        }
        
        return KIFTestStepResultSuccess;
    }];
}

- (void)openSocializeDirectURLNotificationWithURL:(NSString*)url {
    NSLog(@"Open direct url");
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        NSDictionary *socializeInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       url, @"url",
                                       @"developer_direct_url", @"notification_type",
                                       nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:socializeInfo forKey:@"socialize"];
        
        [Socialize handleNotification:userInfo];
        
        return KIFTestStepResultSuccess;
    }];
}

- (UIView*)viewWithAccessibilityLabel:(NSString*)label {
    UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:nil traits:UIAccessibilityTraitNone];
    UIView *view = (UIView*)[UIAccessibilityElement viewContainingAccessibilityElement:element];
    return view;
}

- (void)scrollTableViewWithAccessibilityLabel:(NSString*)label
                             toRowAtIndexPath:(NSIndexPath*)indexPath
                               scrollPosition:(UITableViewScrollPosition)scrollPosition
                                     animated:(BOOL)animated {
    NSLog(@"Scroll UITableView %@ to indexPath %@", label, indexPath);
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        UITableView *tableView = (UITableView*)[self viewWithAccessibilityLabel:label];
        KIFTestCondition([tableView isKindOfClass:[UITableView class]], error, @"Element with label %@ not UITableView", label);
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
        
        return KIFTestStepResultSuccess;
    }];
}


- (void)scrollAndTapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath {
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

- (void)verifyActionBarLikesAtCount:(NSInteger)count {
    NSString *countString = [NSString stringWithFormat:@"%d", count];
    [self checkAccessibilityLabel:@"like button" hasValue:countString];
}

- (void)openLinkDialogExample {
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowLinkDialogRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)openActionBarExample {
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowActionBarExampleRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showUserProfile {
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowUserProfileRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)openEditProfile {
    [self tapViewWithAccessibilityLabel:@"Settings"];
}

- (void)showButtonExample {
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowButtonsExampleRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showLinkToFacebook {
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kLinkToFacebookRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)wipeAuthData {
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:@"Wipe Auth Data"];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showLinkToTwitter {
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kLinkToTwitterRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showLikeEntityRow {
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kLikeEntityRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showDirectUrlNotifications {
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kHandleDirectURLSmartAlertRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showCommentComposer {
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowCommentComposerRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showCommentsList {
    NSIndexPath *indexPath = [[TestAppListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowCommentsListRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}
@end
