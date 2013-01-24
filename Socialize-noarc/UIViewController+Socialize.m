//
//  UIViewController+Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "UIViewController+Socialize.h"
#import "UINavigationController+Socialize.h"
#import "SDKHelpers.h"

static NSTimeInterval ModalDismissDelayHack = 0.5;

@implementation UIViewController (Socialize)

- (UINavigationController*)wrappingSocializeNavigationController {
    UINavigationController *nav = [UINavigationController socializeNavigationControllerWithRootViewController:self];
    return nav;
}

- (UIViewController*)SZPresentingViewController {
    return (([self parentViewController] != nil || ![self respondsToSelector:@selector(presentingViewController)]) ? [self parentViewController] : [self presentingViewController]);
}

- (void)SZDismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if (SZOSGTE(@"5.0")) {
        [self dismissViewControllerAnimated:flag completion:completion];
    } else {
        [self dismissModalViewControllerAnimated:flag];
        double delayInSeconds = ModalDismissDelayHack;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            BLOCK_CALL(completion);
        });
    }
}

- (void)SZPresentViewController:(UIViewController*)viewController animated:(BOOL)flag completion:(void (^)(void))completion {
    if (SZOSGTE(@"5.0")) {
        [self presentViewController:viewController animated:flag completion:completion];
    } else {
        [self presentModalViewController:viewController animated:flag];
        double delayInSeconds = ModalDismissDelayHack;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            BLOCK_CALL(completion);
        });
    }

}

@end