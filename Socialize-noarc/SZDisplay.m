//
//  SZDisplay.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZDisplay.h"
#import "SZNavigationController.h"
#import "SocializeLoadingView.h"
#import <BlocksKit/BlocksKit.h>
#import "SocializeBaseViewController.h"

@implementation SZBlockDisplay
@synthesize beginBlock = beginSequenceBlock_;
@synthesize transitionBlock = transitionBlock_;
@synthesize returnBlock = returnBlock_;
@synthesize endBlock = endSequenceBlock_;
@synthesize alertBlock = alertBlock_;
@synthesize startLoadingBlock = startLoadingBlock_;
@synthesize stopLoadingBlock = stopLoadingBlock_;
@synthesize fallbackDisplay = fallbackDisplay_;

- (void)dealloc {
    self.beginBlock = nil;
    self.transitionBlock = nil;
    self.returnBlock = nil;
    self.endBlock = nil;
    self.alertBlock = nil;
    self.startLoadingBlock = nil;
    self.stopLoadingBlock = nil;
    self.fallbackDisplay = nil;
    
    [super dealloc];
}

+ (SZBlockDisplay*)blockDisplay {
    return [self blockDisplayWrappingDisplay:nil beginSequence:nil endSequence:nil];
}

+ (SZBlockDisplay*)blockDisplayWrappingDisplay:(id<SZDisplay>)fallback {
    return [self blockDisplayWrappingDisplay:fallback beginSequence:nil endSequence:nil];
}

+ (SZBlockDisplay*)blockDisplayWrappingDisplay:(id<SZDisplay>)fallback beginSequence:(void(^)(UIViewController*))beginSequence endSequence:(void(^)())endSequence {
    SZBlockDisplay *blockDisplay = [[[self alloc] init] autorelease]; 
    blockDisplay.fallbackDisplay = fallback;
    blockDisplay.beginBlock = beginSequence;
    blockDisplay.endBlock = endSequence;
    
    return blockDisplay;
}

#define FALLBACK(blk) do { if (blk != nil) blk(); else [self.fallbackDisplay performSelector:_cmd]; } while (0)
#define FALLBACK_1(blk, arg1) do { if (blk != nil) blk(arg1); else [self.fallbackDisplay performSelector:_cmd withObject:arg1]; } while (0)
#define FALLBACK_2(blk, arg1, arg2) do { if (blk != nil) blk(arg1, arg2); else [self.fallbackDisplay performSelector:_cmd withObject:arg1 withObject:arg2]; } while (0)
    
- (void)socializeWillBeginDisplaySequenceWithViewController:(UIViewController *)viewController {
    FALLBACK_1(self.beginBlock, viewController);
}

- (void)socializeWillEndDisplaySequence {
    FALLBACK(self.endBlock);
}

- (void)socializeWillTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    FALLBACK_2(self.transitionBlock, fromViewController, toViewController);
}

- (void)socializeWillReturnToViewController:(UIViewController *)viewController {
    FALLBACK_1(self.returnBlock, viewController);
}

- (void)socializeWillStartLoadingWithMessage:(NSString *)message {
    FALLBACK_1(self.startLoadingBlock, message);
}

- (void)socializeWillStopLoading {
    FALLBACK(self.stopLoadingBlock);
}

- (void)socializeWillShowAlertView:(UIAlertView *)alertView {
    FALLBACK_1(self.alertBlock, alertView);
}

@end


@interface SZDisplayWrapper ()
@property (nonatomic, retain) NSMutableArray *controllers;
@property (nonatomic, retain) id<SZDisplay> outerDisplay;
@end

@implementation SZDisplayWrapper
@synthesize controllers = controllers_;
@synthesize outerDisplay = outerDisplay_;
@synthesize continueBlock = continueBlock_;
@synthesize endBlock = endBlock_;
@synthesize running = running_;

- (void)dealloc {
    self.controllers = nil;
    self.outerDisplay = nil;
    self.continueBlock = nil;
    self.endBlock = nil;
    
    [super dealloc];
}

- (NSMutableArray*)controllers {
    if (controllers_ == nil) {
        controllers_ = [[NSMutableArray alloc] init];
    }
    return controllers_;
}

+ (SZDisplayWrapper*)displayWrapperWithDisplay:(id<SZDisplay>)display {
    return [self displayWrapperWithDisplay:display continueBlock:nil existingStack:nil];
}

+ (SZDisplayWrapper*)displayWrapperWithDisplay:(id<SZDisplay>)display continueBlock:(void(^)(UIViewController*))continueBlock {
    return [self displayWrapperWithDisplay:display continueBlock:continueBlock existingStack:nil];
}

+ (SZDisplayWrapper*)displayWrapperWithDisplay:(id<SZDisplay>)display continueBlock:(void(^)(UIViewController*))continueBlock existingStack:(NSArray*)existingStack {
    return [[[self alloc] initWithDisplay:display continueBlock:continueBlock existingStack:existingStack] autorelease];
}

- (id)initWithDisplay:(id<SZDisplay>)outerDisplay continueBlock:(void(^)(UIViewController*))continueBlock existingStack:(NSArray*)existingStack {
    if (self = [super init]) {
        self.outerDisplay = outerDisplay;
        self.continueBlock = continueBlock;
        
        if ([outerDisplay isKindOfClass:[SZDisplayWrapper class]]) {
            NSAssert(existingStack == nil, @"Cannot both wrap a wrapper and specify an existing stack");

            SZDisplayWrapper *outerWrapper = (SZDisplayWrapper*)outerDisplay;
            self.running = outerWrapper.running;
            [self.controllers addObjectsFromArray:[outerWrapper controllers]];
        }

        if (existingStack != nil) {
            self.running = YES;
            [self.controllers addObjectsFromArray:existingStack];
        }
        
    }
    return self;
}

- (void)socializeWillBeginDisplaySequenceWithViewController:(UIViewController *)viewController {
    self.running = YES;
    
    if ([self.controllers count] > 0) {
        if (self.continueBlock != nil) {
            [self.controllers addObject:viewController];
            self.continueBlock(viewController);
        } else {
            [self pushViewController:viewController];
        }
    } else {
        [self.controllers addObject:viewController];
        [self.outerDisplay socializeWillBeginDisplaySequenceWithViewController:viewController];
    }
}

- (void)socializeWillEndDisplaySequence {
    BLOCK_CALL(self.endBlock);
}

- (void)socializeWillTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    [self.controllers addObject:toViewController];
    
    [self.outerDisplay socializeWillTransitionFromViewController:fromViewController toViewController:toViewController];
}

- (void)socializeWillReturnToViewController:(UIViewController *)viewController {
    [self.controllers removeObjectsAfterObject:viewController];
    [self.outerDisplay socializeWillReturnToViewController:viewController];
}

- (void)socializeWillShowAlertView:(UIAlertView *)alertView {
    [self.outerDisplay socializeWillShowAlertView:alertView];
}

- (void)beginWithOrTransitionToViewController:(UIViewController *)viewController {
    UIViewController *topController = [self.controllers lastObject];
    
    if (topController != nil) {
        [self transitionFromViewController:topController toViewController:viewController];
    } else {
        [self beginSequenceWithViewController:viewController];
    }
}

- (UIViewController*)topController {
    return [self.controllers lastObject];
}

- (id<SZDisplay>)topDisplay {
    id<SZDisplay> display = [self.controllers lastObject];
    if (display == nil) {
        display = self.outerDisplay;
    }
    return display;
}

- (void)socializeWillStartLoadingWithMessage:(NSString *)message {
    [self.outerDisplay socializeWillStartLoadingWithMessage:message];
}

- (void)socializeWillStopLoading {
    [self.outerDisplay socializeWillStopLoading];
}

- (void)pop {
    UIViewController *controller = [self.controllers objectAtIndex:[self.controllers count] - 2];
    [self socializeWillReturnToViewController:controller];
}

- (void)pushViewController:(UIViewController*)viewController {
    UIViewController *topController = [self.controllers objectAtIndex:[self.controllers count] - 1];
    [self transitionFromViewController:topController toViewController:viewController];
}

- (void)beginSequenceWithViewController:(UIViewController*)viewController {
    if ([viewController isKindOfClass:[SocializeBaseViewController class]]) {
        [(SocializeBaseViewController*)viewController setDisplay:self];
    }

    [self socializeWillBeginDisplaySequenceWithViewController:viewController];
}

- (void)transitionFromViewController:(UIViewController*)fromViewController toViewController:(UIViewController*)toViewController {
    [self.controllers addObject:toViewController];
    
    SDT(self.outerDisplay, fromViewController, toViewController);
}

- (void)returnToViewController:(UIViewController*)viewController {
    [self.controllers removeObjectsAfterObject:viewController];
    SDRET(self.outerDisplay, viewController);
}

- (void)startLoadingInTopControllerWithMessage:(NSString*)message {
    UIViewController *topController = [self.controllers lastObject];
    if (topController != nil) {
        if ([topController isKindOfClass:[SocializeBaseViewController class]]) {
            [(SocializeBaseViewController*)topController startLoading];
        } else {
            [topController showSocializeLoadingViewInSubview:nil];
        }
    } else {
        [self.outerDisplay socializeWillStartLoadingWithMessage:message];
    }
}

- (void)stopLoadingInTopController {
    UIViewController *topController = [self.controllers lastObject];
    if (topController != nil) {
        if ([topController isKindOfClass:[SocializeBaseViewController class]]) {
            [(SocializeBaseViewController*)topController stopLoading];
        } else {
            [topController showSocializeLoadingViewInSubview:nil];
        }
    } else {
        [self.outerDisplay socializeWillStopLoading];
    }
}

- (void)showAlertView:(UIAlertView*)alertView {
    [self.outerDisplay socializeWillShowAlertView:alertView];
}


- (void)endSequence {
    if (self.running) {
        self.running = NO;
        SDEND(self.outerDisplay);
    }
}

@end

@implementation UIViewController (SZDisplay)
- (void)socializeWillBeginDisplaySequenceWithViewController:(UIViewController *)viewController {
    
    SZNavigationController *navigationController = [[[SZNavigationController alloc] initWithRootViewController:viewController] autorelease];
    [self presentModalViewController:navigationController animated:YES];
}

- (void)socializeWillEndDisplaySequence {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)socializeWillTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    [fromViewController.navigationController pushViewController:toViewController animated:YES];
}

- (void)socializeWillReturnToViewController:(UIViewController *)viewController {
    [viewController.navigationController popToViewController:viewController animated:YES];
}

- (void)socializeWillStartLoadingWithMessage:(NSString*)message {
    [self showSocializeLoadingViewInSubview:self.view];
}

- (void)socializeWillStopLoading {
    [self hideSocializeLoadingView];
}

- (void)socializeWillShowAlertView:(UIAlertView *)alertView {
    [alertView show];
}

@end
