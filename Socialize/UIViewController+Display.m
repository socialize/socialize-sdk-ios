//
//  UIViewController+Display.m
//  Socialize
//
//  Created by Nathaniel Griswold on 9/10/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "UIViewController+Display.h"
#import <objc/runtime.h>
#import "SDKHelpers.h"

static char *kUIViewControllerLoadingViewKey = "kUIViewControllerLoadingViewKey";

@implementation UIViewController (Display)

- (void)presentViewController:(UIViewController *)viewControllerToPresent fromViewController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion {
    [self presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)dismissToViewController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion {
    [self dismissViewControllerAnimated:flag completion:completion];
}

- (SocializeLoadingView *)loadingView {
    return objc_getAssociatedObject(self, kUIViewControllerLoadingViewKey);
}

- (void)setLoadingView:(SocializeLoadingView *)loadingView {
    objc_setAssociatedObject(self, kUIViewControllerLoadingViewKey, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)startLoadingForContext:(SZLoadingContext)context {
    if (self.loadingView == nil) {
        self.loadingView = [SocializeLoadingView loadingViewInView:self.view];
    }
}

- (void)stopLoadingForContext:(SZLoadingContext)context {
    [self.loadingView removeView];
    self.loadingView = nil;
}

- (void)failWithError:(NSError *)error {
    SZEmitUIError(nil, error);
}

@end
