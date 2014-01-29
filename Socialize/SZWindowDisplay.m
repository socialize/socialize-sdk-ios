//
//  SZWindowDisplay.m
//  Socialize
//
//  Created by Nathaniel Griswold on 9/8/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZWindowDisplay.h"
#import "socialize_globals.h"
#import "SDKHelpers.h"
#import "SZStatusView.h"

static NSTimeInterval ModalTransitionInterval = 0.3;

static SZWindowDisplay *sharedWindowDisplay;

@implementation SZWindowDisplay

- (id)init {
    if (self = [super init]) {
    }
    
    return self;
}

+ (SZWindowDisplay*)sharedWindowDisplay {
    if (sharedWindowDisplay == nil) {
        sharedWindowDisplay = [[SZWindowDisplay alloc] init];
    }
    
    return sharedWindowDisplay;
}

- (CGFloat)rotationForCurrentOrientation {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            return 0;
        case UIDeviceOrientationPortraitUpsideDown:
            return 0;
        case UIDeviceOrientationLandscapeLeft:
            return -M_PI_2;
        case UIDeviceOrientationLandscapeRight:
            return M_PI_2;
        default:
            return 0;
    }
}

- (UIWindow*)window {
    if (_window == nil) {
        _window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    }
    return _window;
}

- (void)socializeRequiresPresentModalViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    self.rootViewController = viewControllerToPresent;
    CGRect statusFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];

    CGRect startFrame = CGRectMake(0, statusFrame.size.height + applicationFrame.size.height, applicationFrame.size.width, applicationFrame.size.height);
    CGRect endFrame = CGRectMake(0, statusFrame.size.height, applicationFrame.size.width, applicationFrame.size.height);
    self.rootViewController.view.frame = startFrame;
    [self.window addSubview:self.rootViewController.view];

    [UIView animateWithDuration:ModalTransitionInterval
                     animations:^{
                         self.rootViewController.view.frame = endFrame;
                     } completion:^(BOOL finished) {
                         BLOCK_CALL(completion);
                     }];
}

- (void)socializeRequiresDismissModalViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if (self.rootViewController == nil) {
        return;
    }
    
    [self.rootViewController dismissViewControllerAnimated:NO completion:nil];
    [UIView animateWithDuration:ModalTransitionInterval
                     animations:^{
                         CGRect frame = self.rootViewController.view.frame;
                         frame.origin.y = frame.origin.y + frame.size.height;
                         self.rootViewController.view.frame = frame;
                     } completion:^(BOOL finished) {
                         self.rootViewController = nil;
                         BLOCK_CALL(completion);
                     }];
    self.rootViewController = nil;
}

- (void)socializeDidStartLoadingForContext:(SZLoadingContext)context {
    if (self.loadingView == nil) {
        self.loadingView = [SocializeLoadingView loadingViewInView:self.window];
    }
}

- (void)socializeDidStopLoadingForContext:(SZLoadingContext)context {
    [self.loadingView removeView];
    self.loadingView = nil;
}

- (void)socializeRequiresIndicationOfFailureForError:(NSError *)error {
    SZEmitUIError(nil, error);
}

- (void)socializeRequiresIndicationOfStatusForContext:(SZStatusContext)context {
    SZStatusView *status = nil;
    CGRect frame = CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height);
    switch (context) {
        case SZStatusContextCommentPostSucceeded:
        case SZStatusContextSocializeShareCompleted:
            status = [SZStatusView successStatusViewWithFrame:frame];
            break;
    }
    
    [status showAndHideInKeyWindow];
}

@end
