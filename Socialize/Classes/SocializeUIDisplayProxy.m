//
//  Socializeobject.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeUIDisplayProxy.h"
#import "SocializeLoadingView.h"
#import "SocializeUIDisplayProxyDelegate.h"

@interface SocializeUIDisplayProxy ()
@property (nonatomic, retain) SocializeLoadingView *loadingView;
@property (nonatomic, assign) BOOL loading;
@end

@implementation SocializeUIDisplayProxy
@synthesize display = displayHandler_;
@synthesize object = object_;
@synthesize loadingView = loadingView;
@synthesize loading = loading_;

- (void)dealloc {
    self.loadingView = nil;
    [super dealloc];
}

+ (id)UIDisplayProxyWithObject:(id)object display:(id)display {
    return [[[self alloc] initWithObject:object display:display] autorelease];
}

- (id)initWithObject:(id) object display:(id)display {
    if (self = [super init]) {
        self.object = object;
        self.display = display;
    }
    return self;
}

- (void)presentModalViewController:(UIViewController*)controller {
    if ([self.object respondsToSelector:@selector(displayProxy:willDisplayViewController:)]) {
        [self.object displayProxy:self willDisplayViewController:controller];
    }
         
    if ([self.display respondsToSelector:@selector(socializeObject:requiresDisplayOfViewController:)]) {
        [self.display socializeObject:self.object requiresDisplayOfViewController:controller];
    } else if ([self.display respondsToSelector:@selector(presentModalViewController:animated:)]) {
        [self.display presentModalViewController:controller animated:YES];
    } else {
        NSAssert(NO, @"ui display implementation must respond to either socializeObject:requiresDisplayOfViewController or presentModalViewController:animated");
    }
}

- (void)dismissModalViewController:(UIViewController*)controller {
    if ([self.display respondsToSelector:@selector(socializeObject:requiresDismissOfViewController:)]) {
        [self.display socializeObject:self.object requiresDismissOfViewController:controller];
    } else if ([self.display respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [self.display dismissModalViewControllerAnimated:YES];
    } else {
        NSAssert(NO, @"ui display implementation must respond to either socializeObject:requiresDismissOfViewController or presentModalViewController:animated");
    }
}

- (void)showActionSheet:(UIActionSheet*)actionSheet {
    if ([self.object respondsToSelector:@selector(displayProxy:shouldDisplayActionSheet:)]) {
        if (![self.object displayProxy:self shouldDisplayActionSheet:actionSheet]) {
            return;
        }
    }

    if ([self.display respondsToSelector:@selector(socializeObject:requiresDisplayOfActionSheet:)]) {
        [self.display socializeObject:self.object requiresDisplayOfActionSheet:actionSheet];
    } else if ([self.display isKindOfClass:[UITabBarController class]]) {
        [actionSheet showFromTabBar:[(UITabBarController*)self.display tabBar]];
    } else if ([self.display respondsToSelector:@selector(view)]) {
        UIView *view = [self.display view];
        NSAssert([view isKindOfClass:[UIView class]], @"ui display implementation view is not a UIView. Please implement socializeObject:requiresDisplayOfActionSheet");
        [actionSheet showInView:view];
    } else {
        NSAssert(NO, @"ui display implementation must either respond to socializeObject:requiresDisplayOfActionSheet or respond to `view` with a UIView");
    }
}

- (void)showAlertView:(UIAlertView *)alertView {
    if ([self.display respondsToSelector:@selector(socializeObject:requiresDisplayOfAlertView:)]) {
        [self.display socializeObject:self.object requiresDisplayOfAlertView:alertView];
    } else {
        [alertView show];
    }
}

- (void)startLoading {
    if (self.loading)
        return;
    
    self.loading = YES;
    if ([self.display respondsToSelector:@selector(socializeObjectWillStartLoading:)]) {
        [self.display socializeObjectWillStartLoading:self.object];
    } else if ([self.display respondsToSelector:@selector(view)]) {
        UIView *view = [self.display view];
        NSAssert([view isKindOfClass:[UIView class]], @"displayHandler view is not a UIView. Please implement socializeObject:requiresDisplayOfobjectSheet");
        self.loadingView = [SocializeLoadingView loadingViewInView:view];
    }
}

- (void)stopLoading {
    if (!self.loading)
        return;
    
    self.loading = NO;
    if ([self.display respondsToSelector:@selector(socializeObjectWillStopLoading:)]) {
        [self.display socializeObjectWillStopLoading:self.object];
    } else if (self.loadingView != nil) {
        [self.loadingView removeView];
        self.loadingView = nil;
    }
}

@end
