//
//  KIFTestStep+SampleAdditions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "KIFTestStep+TestAppAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIScrollView-KIFAdditions.h"
#import "UITouch-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"
#import "TestAppListViewController.h"
#import "TestAppKIFTestController.h"
#import "UIApplication-KIFAdditions.h"
#import <Socialize/Socialize.h>

@interface KIFTestStep ()
+ (UIAccessibilityElement *)_accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value tappable:(BOOL)mustBeTappable traits:(UIAccessibilityTraits)traits error:(out NSError **)error;
+ (BOOL)_isUserInteractionEnabledForView:(UIView *)view;

+ (BOOL)_enterCharacter:(NSString *)characterString;
+ (BOOL)_enterCharacter:(NSString *)characterString history:(NSMutableDictionary *)history;
+ (BOOL)_enterCustomKeyboardCharacter:(NSString *)characterString;

@end

@implementation KIFTestStep (TestAppAdditions)

+ (NSArray*)stepsToPopNavigationControllerToIndex:(NSInteger)index
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObject:[KIFTestStep stepWithDescription:[NSString stringWithFormat:@"Reset nav to level %d.", index] executionBlock:^(KIFTestStep *step, NSError **error) {
        BOOL successfulReset = YES;
        
        [[[TestAppListViewController sharedSampleListViewController] navigationController] popToRootViewControllerAnimated:NO];
        // Do the actual reset for your app. Set successfulReset = NO if it fails.
        KIFTestCondition(successfulReset, error, @"Failed to reset the application.");
        return KIFTestStepResultSuccess;
    }]];
    
    return steps;
}

+ (NSArray*)stepsToReturnToList;
{
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObjectsFromArray:[self stepsToPopNavigationControllerToIndex:0]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"tableView"]];
    return steps;
}

+ (NSArray*)stepsToOpenProfile {
    NSMutableArray *steps = [NSMutableArray array];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];
    return steps;
}

+ (NSArray*)stepsToOpenEditProfile {
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Settings"]];
    return steps;
}

#import "TestAppListViewController.h"

+ (KIFTestStep*)stepToDumpAccessibilityElementsMatchingBlock:(BOOL(^)(UIAccessibilityElement*))block {
    return [KIFTestStep stepWithDescription:@"Dump" executionBlock:^(KIFTestStep *step, NSError **error) {
        [[UIApplication sharedApplication] accessibilityElementMatchingBlock:^(UIAccessibilityElement *e) {
            NSString *accessibilityLabel = [e accessibilityLabel];
            NSString *accessibilityValue = [e accessibilityValue];
            
            if (block(e) && ([accessibilityLabel length] > 0 || [accessibilityValue length] > 0)) {
                NSLog(@"Found element: %@/%@ - %@", [e accessibilityLabel], [e accessibilityValue], e);
            }
            return NO;
        }];
        
        return KIFTestStepResultSuccess;
    }];
}

+ (KIFTestStep*)stepToTapRowInTopTableViewAtIndexPath:(NSIndexPath*)indexPath {
    NSString *description = [NSString stringWithFormat:@"Tap top tableView at (%d,%d)", indexPath.section, indexPath.row];
    return [KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {

        UITableView *tableView = (UITableView*)[[UIApplication sharedApplication] accessibilityElementMatchingBlock:^(UIAccessibilityElement *e) {
            return [e isKindOfClass:[UITableView class]];
        }];
        KIFTestCondition(tableView != nil, error, @"Not a tableview");
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        CGRect cellFrame = [cell.contentView convertRect:[cell.contentView frame] toView:tableView];
        [tableView tapAtPoint:CGPointCenteredInRect(cellFrame)];
        
        return KIFTestStepResultSuccess;
    }];
}

+ (KIFTestStep*)stepToTapTopViewMatchingBlock:(BOOL(^)(UIAccessibilityElement*))block {
    NSString *description = [NSString stringWithFormat:@"Tap top view matching block"];
    return [KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
        UIView *view = (UITableView*)[[UIApplication sharedApplication] accessibilityElementMatchingBlock:block];
        KIFTestCondition(view != nil, error, @"Not a tableview");
        [view tap];
        
        return KIFTestStepResultSuccess;
    }];
}

+ (NSArray*)stepsToEditProfileImage {
    NSMutableArray *steps = [NSMutableArray array];
    // Tap image
    NSIndexPath *imagePath = [NSIndexPath indexPathForRow:0 inSection:0];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"edit profile" atIndexPath:imagePath]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Choose From Album"]];
    [steps addObject:[KIFTestStep stepToTapRowInTopTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    [steps addObject:[KIFTestStep stepToDumpAccessibilityElementsMatchingBlock:^(UIAccessibilityElement *e) {
        return YES;
    }]];
    [steps addObject:[KIFTestStep stepToTapTopViewMatchingBlock:^(UIAccessibilityElement *e) {
        return [e isKindOfClass:[UIImageView class]];
    }]];

    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Save"]];
    return steps;
}

+ (NSArray*)stepsToSetProfileFirstName:(NSString*)firstName {
    NSMutableArray *steps = [NSMutableArray array];
    // Tap image
    NSIndexPath *editPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"edit profile" atIndexPath:editPath]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"First name"]]; 
    [steps addObject:[KIFTestStep stepToEnterText:firstName intoViewWithAccessibilityLabel:@"First name"]]; 
//    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Edit Profile"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Save"]];
    return steps;
}

+ (NSArray*)stepsToVerifyProfileFirstName:(NSString*)firstName {
    NSMutableArray *steps = [NSMutableArray array];
    NSString *firstNameAccessibilityLabel = @"name";
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:firstNameAccessibilityLabel]];
    [steps addObject:[KIFTestStep stepToCheckAccessibilityLabel:firstNameAccessibilityLabel hasValue:firstName]];
    return steps;
}

+ (NSArray*)stepsToShowTabbedActionBarForURL:(NSString*)url {
    NSMutableArray *steps = [NSMutableArray array]; 
    
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:11 inSection:0];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Input Field"]];
    [steps addObject:[KIFTestStep stepToEnterText:url intoViewWithAccessibilityLabel:@"Input Field"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Enter"]];
//    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tests"]];
    return steps;
}


+ (NSArray*)stepsToShowButtonTestController:(NSString*)url {
    NSMutableArray *steps = [NSMutableArray array]; 
    
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:18 inSection:0];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:indexPath]];
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Input Field"]];
    [steps addObject:[KIFTestStep stepToEnterText:url intoViewWithAccessibilityLabel:@"Input Field"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Enter"]];
    //    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tests"]];
    return steps;
}


+ (NSArray*)stepsToVerifyActionBarViewsAtCount:(NSInteger)count {
    NSMutableArray *steps = [NSMutableArray array];
    NSString *countString = [NSString stringWithFormat:@"%d", count];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"view counter"]];
    [steps addObject:[KIFTestStep stepToCheckAccessibilityLabel:@"view counter" hasValue:countString]];
    
    return steps;
}

+ (NSArray*)stepsToLikeOnActionBar {
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"like button"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"like button"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Skip"]];
    return steps;
}

+ (NSArray*)stepsToCommentOnActionBar {
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"comment button"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"comment button"]];
    return steps;
}

+ (NSArray*)stepsToVerifyActionBarLikesAtCount:(NSInteger)count {
    NSMutableArray *steps = [NSMutableArray array];
    NSString *countString = [NSString stringWithFormat:@"%d", count];
    [steps addObject:[KIFTestStep stepToCheckAccessibilityLabel:@"like button" hasValue:countString]];
    
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
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Create Entity"]];    
    [steps addObject:[KIFTestStep stepToEnterText:url intoViewWithAccessibilityLabel:@"entityField"]];
    if (name != nil) {
        [steps addObject:[KIFTestStep stepToEnterText:name intoViewWithAccessibilityLabel:@"nameField"]];
    }
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"createButton"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"resultTextField" value:@"success" traits:UIAccessibilityTraitNone]];

    return steps;
}

+(NSString*)getRandomURL;
{
    int randomNum = arc4random() % 999999999999;
    NSString *randomString = [NSString stringWithFormat:@"http://www.example.com/%i", randomNum];
    return randomString;
}
+ (NSArray*)stepsToCreateEntityWithRandomURL;
{
    NSString *randomString = [KIFTestStep getRandomURL];
    return [self stepsToCreateEntityWithURL:randomString name:nil];;
}

+ (NSArray*)stepsToGetEntityWithURL:(NSString*)url;
{
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Get Entity"]];    
    [steps addObject:[KIFTestStep stepToEnterText:url intoViewWithAccessibilityLabel:@"entityField"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"getEntityButton"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"resultTextField" value:@"success"traits:UIAccessibilityTraitNone]];
    return steps;
}

+ (NSArray*)stepsToCreateCommentWithControllerForEntity:(NSString*)entity comment:(NSString*)comment
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:7 inSection:0];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Input Field"]];
    [steps addObject:[KIFTestStep stepToEnterText:entity intoViewWithAccessibilityLabel:@"Input Field"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Enter"]];
    [steps addObjectsFromArray:[KIFTestStep stepsToCreateComment:comment]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Tests"]];

    return steps;
}

+ (NSArray*)stepsToCreateShare:(NSString*)comment
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Comment Entry"]];
    [steps addObject:[KIFTestStep stepToEnterText:comment intoViewWithAccessibilityLabel:@"Comment Entry"]];
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Send"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Send"]];

    return steps;
}

+ (NSArray*)stepsToCreateComment:(NSString*)comment
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Comment Entry"]];
    [steps addObject:[KIFTestStep stepToEnterText:comment intoViewWithAccessibilityLabel:@"Comment Entry"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Send"]];
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"facebook"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Skip"]];

    return steps;
}
+ (NSArray*)stepsToSkipAuth {  
    NSMutableArray *steps = [NSMutableArray array];
    return steps;
}

+ (NSArray*)stepsToGetCommentsForEntity:(NSString*)entity
{
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Fetch Comment"]];    
    [steps addObject:[KIFTestStep stepToEnterText:entity intoViewWithAccessibilityLabel:@"entityField"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"getCommentsButton"]];
//    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Comments List"]];
    return steps;
}

+ (NSArray*)stepsToVerifyCommentExistsForEntity:(NSString*)entity comment:(NSString*)comment {
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    [steps addObjectsFromArray:[self stepsToGetCommentsForEntity:entity]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Comment Cell"]];
    [steps addObject:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Comments Table View" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:comment]];
    
    return steps;
}

+ (NSArray*)stepsToLikeEntity:(NSString*)entity
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:4 inSection:0];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:path]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Create a like/unlike"]];    
    [steps addObject:[KIFTestStep stepToEnterText:entity intoViewWithAccessibilityLabel:@"entityField"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"likeButton"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"resultTextField" value:@"success" traits:UIAccessibilityTraitNone]];
    return steps;
}

+ (NSArray*)stepsToUnlikeEntity:(NSString*)entity
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:4 inSection:0];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:path]];
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
    [steps addObjectsFromArray:[KIFTestStep stepsToReturnToList]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:6 inSection:0];
    [steps addObject:[KIFTestStep stepToScrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView" atIndexPath:path]];
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

+ (id)stepToCheckAccessibilityLabel:(NSString *)label hasValue:(NSString *)hasValue   {
    NSString *description = [NSString stringWithFormat:@"Check value accessibility label: %@ has value: %@", label, hasValue];
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label];
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
            *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure 
                                             userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, NSLocalizedDescriptionKey, nil]] autorelease];
            return KIFTestStepResultWait;
        }
    }];
}

+ (id)stepToNoCheckEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    NSString *description = [NSString stringWithFormat:@"Type the text \"%@\" into the view with accessibility label \"%@\"", text, label];
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
        UIAccessibilityElement *element = [KIFTestStep _accessibilityElementWithLabel:label accessibilityValue:nil tappable:YES traits:traits error:error];
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
            
            if (![self _enterCharacter:characterString]) {
                // Attempt to cheat if we couldn't find the character
                if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
                    NSLog(@"KIF: Unable to find keyboard key for %@. Inserting manually.", characterString);
                    [(UITextField *)view setText:[[(UITextField *)view text] stringByAppendingString:characterString]];
                } else {
                    KIFTestCondition(NO, error, @"Failed to find key for character \"%@\"", characterString);
                }
            }
        }
        
        return KIFTestStepResultSuccess;
    }];
}

+ (id)stepToScrollAndTapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath
{
    NSString *description = [NSString stringWithFormat:@"Step to tap row %d in tableView with label %@", [indexPath row], tableViewLabel];
    return [KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:tableViewLabel];
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

+ (id)stepToExecuteBlock:(void (^)())block {
    return [KIFTestStep stepWithDescription:@"Execute generic block" executionBlock:^(KIFTestStep *step, NSError **error) {
        block();
        return KIFTestStepResultSuccess;
    }];
}

+ (id)stepToWipeAuthenticationInfo {
    return [self stepToExecuteBlock:^{
        [[Socialize sharedSocialize] removeAuthenticationInfo];
    }];
}
            

+ (id)stepToVerifyViewWithAccessibilityLabel:(NSString*)label passesTest:(BOOL (^)(id view))testBlock {
    NSString *description = [NSString stringWithFormat:@"Step to test view with label %@ passes block test", label];
    return [KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label];
        KIFTestCondition(element != nil, error, @"View with label %@ not found", label);
        UIView *view = (UIView*)[UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestCondition(view != nil, error, @"View with label %@ not found", label);
        
        BOOL result = testBlock(view);
        KIFTestCondition(result, error, @"View with label %@ did not pass block test!", label);

        return KIFTestStepResultSuccess;
    }];
}

+ (id)stepToVerifyElementWithAccessibilityLabelDoesNotExist:(NSString*)label {
    NSString *description = [NSString stringWithFormat:@"Step to test view with label %@ not on screen", label];
    return [KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label];
        KIFTestCondition(element == nil, error, @"Element with label %@ found", label);
        UIView *view = (UIView*)[UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestCondition(view == nil, error, @"View with label %@ found", label);
        
        return KIFTestStepResultSuccess;
    }];

}

+ (UIView*)viewWithAccessibilityLabel:(NSString*)label {
    UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label];
    UIView *view = (UIView*)[UIAccessibilityElement viewContainingAccessibilityElement:element];
    return view;
}

+ (id)stepToScrollScrollViewWithAccessibilityLabel:(NSString*)scrollViewLabel toViewWithAcccessibilityLabel:(NSString*)viewLabel {
    NSString *description = [NSString stringWithFormat:@"Scroll UIScrollView %@ to view %@", scrollViewLabel, viewLabel];
    return [KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        UIScrollView *scrollView = (UIScrollView*)[self viewWithAccessibilityLabel:scrollViewLabel];
        KIFTestCondition([scrollView isKindOfClass:[UIScrollView class]], error, @"Element with label %@ not UIScrollView", scrollViewLabel);
        UIView *view = [self viewWithAccessibilityLabel:viewLabel];
        KIFTestCondition([view isKindOfClass:[UIView class]], error, @"Element with label %@ not UIView", scrollViewLabel);
        [scrollView scrollViewToVisible:view animated:YES];
        
        return KIFTestStepResultSuccess;
    }];
    
}

+ (id)stepToScrollTableViewWithAccessibilityLabel:(NSString*)label toRowAtIndexPath:(NSIndexPath*)indexPath scrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    NSString *description = [NSString stringWithFormat:@"Scroll UITableView %@ to indexPath %@", label, indexPath];
    return [KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        UITableView *tableView = (UITableView*)[self viewWithAccessibilityLabel:label];
        KIFTestCondition([tableView isKindOfClass:[UITableView class]], error, @"Element with label %@ not UITableView", label);
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
        
        return KIFTestStepResultSuccess;
    }];
}

+ (NSArray*)stepsToAuthWithTestTwitterInfo {
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Twitter"]];
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Username or email"]];
    [steps addObject:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"In progress"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:1 description:@"Waiting for web view"]];

    [steps addObject:[KIFTestStep stepToNoCheckEnterText:@"mr_socialize" intoViewWithAccessibilityLabel:@"Username or email" traits:UIAccessibilityTraitNone]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Password"]];
    [steps addObject:[KIFTestStep stepToNoCheckEnterText:@"supersecret" intoViewWithAccessibilityLabel:@"Password" traits:UIAccessibilityTraitNone]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Sign In"]];
    
    return steps;
}

@end
