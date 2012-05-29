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
#import "NSObject+AssociatedObjects.h"

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
    return [[[self alloc] init] autorelease];
}

+ (SZBlockDisplay*)blockDisplayWithFallback:(id<SZDisplay>)fallback {
    SZBlockDisplay *display = [self blockDisplay];
    display.fallbackDisplay = fallback;
    return display;
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


@interface SZStackDisplay ()
@property (nonatomic, retain) NSMutableArray *controllers;
@property (nonatomic, retain) id<SZDisplay> outerDisplay;
@end

@implementation SZStackDisplay
@synthesize controllers = controllers_;
@synthesize outerDisplay = outerDisplay_;

- (void)dealloc {
    self.controllers = nil;
    self.outerDisplay = nil;
    [super dealloc];
}

- (NSMutableArray*)controllers {
    if (controllers_ == nil) {
        controllers_ = [[NSMutableArray alloc] init];
    }
    return controllers_;
}

+ (SZStackDisplay*)stackDisplayForDisplay:(id<SZDisplay>)display {
    return [[[self alloc] initWithOuterDisplay:display] autorelease];
}

- (id)initWithOuterDisplay:(id<SZDisplay>)outerDisplay {
    if (self = [super init]) {
        self.outerDisplay = outerDisplay;
    }
    return self;
}

- (void)beginWithOrTransitionToViewController:(UIViewController *)viewController {
    if ([self.controllers count] > 0) {
        [self.outerDisplay socializeWillTransitionFromViewController:[self.controllers lastObject] toViewController:viewController];
    } else {
        [self.outerDisplay socializeWillBeginDisplaySequenceWithViewController:viewController];
    }
    [self.controllers addObject:viewController];
}

- (void)socializeWillBeginDisplaySequenceWithViewController:(UIViewController *)viewController {
    [self beginWithOrTransitionToViewController:viewController];
}

- (void)socializeWillEndDisplaySequence {
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

- (id<SZDisplay>)topDisplay {
    id<SZDisplay> display = [self.controllers lastObject];
    if (display == nil) {
        display = self.outerDisplay;
    }
    return display;
}

- (void)socializeWillStartLoadingWithMessage:(NSString *)message {
    [[self topDisplay] socializeWillStartLoadingWithMessage:message];
}

- (void)socializeWillStopLoading {
    [[self topDisplay] socializeWillStopLoading];
}

@end

static char *kSocializeLoadingViewKey = "kSocializeLoadingViewKey";

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
    SocializeLoadingView *loading = [SocializeLoadingView loadingViewInView:self.view];
    [self weaklyAssociateValue:loading withKey:kSocializeLoadingViewKey];
}

- (void)socializeWillStopLoading {
    UIView *view = [self associatedValueForKey:kSocializeLoadingViewKey];
    [view removeFromSuperview];
}

- (void)socializeWillShowAlertView:(UIAlertView *)alertView {
    [alertView show];
}

@end
