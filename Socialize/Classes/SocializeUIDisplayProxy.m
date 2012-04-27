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
@synthesize controllers = controllers_;

- (void)dealloc {
    self.loadingView = nil;
    self.controllers = nil;
    
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

- (NSMutableArray*)controllers {
    if (controllers_ == nil) {
        controllers_ = [[NSMutableArray alloc] init];
    }
    
    return controllers_;
}

- (id<SocializeUIDisplay>)displayAtIndexFromEnd:(NSUInteger)offset {
    id<SocializeUIDisplay> display;
    NSUInteger controllerCount = [self.controllers count];
    if (controllerCount > offset) {
        // Grab a controller, which conforms to SocializeUIDisplay
        display = [self.controllers objectAtIndex:controllerCount - 1 - offset];
    } else {
        // Fall back to root display, which is a SocializeUIDisplay
        display = self.display;
    }
    
    return display;
}

- (id<SocializeUIDisplay>)topDisplay {
    return [self displayAtIndexFromEnd:0];
}

- (void)presentModalViewController:(UIViewController*)controller {
    if ([self.object respondsToSelector:@selector(displayProxy:willDisplayViewController:)]) {
        [self.object displayProxy:self willDisplayViewController:controller];
    }
    
    id<SocializeUIDisplay> topDisplay = [self topDisplay];
    
    [self.controllers addObject:controller];

    if ([self.display respondsToSelector:@selector(socializeObject:requiresDisplayOfViewController:)]) {
        [self.display socializeObject:self.object requiresDisplayOfViewController:controller];
    } else if ([topDisplay respondsToSelector:@selector(presentModalViewController:animated:)]) {
        [topDisplay presentModalViewController:controller animated:YES];
    } else {
        NSAssert(NO, @"ui display implementation must respond to either socializeObject:requiresDisplayOfViewController or presentModalViewController:animated");
    }
}

- (void)dismissModalViewController {
    UIViewController *topController = [self.controllers lastObject];
    id<SocializeUIDisplay> secondFromTopDisplay = [self displayAtIndexFromEnd:1];
    
    [self.controllers removeLastObject];

    if ([self.display respondsToSelector:@selector(socializeObject:requiresDismissOfViewController:)]) {
        [self.display socializeObject:self.object requiresDismissOfViewController:(UIViewController*)topController];
    } else if ([secondFromTopDisplay respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [secondFromTopDisplay dismissModalViewControllerAnimated:YES];
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
