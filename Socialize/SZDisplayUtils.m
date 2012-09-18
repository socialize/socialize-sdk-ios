//
//  SZDisplayUtils.m
//  Socialize
//
//  Created by Nathaniel Griswold on 9/10/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZDisplayUtils.h"
#import "SZNotificationHandler.h"
#import "SZWindowDisplay.h"
#import "socialize_globals.h"

static id<SZDisplay>(^globalDisplayBlock)();

@implementation SZDisplayUtils

+ (id<SZDisplay>)globalDisplay {
    
    if (globalDisplayBlock != nil) {
        
        // User-defined display block
        return globalDisplayBlock();
    } else {
        
        // Discover topmost view controller if possible
        UIWindow *appWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        UIViewController *rootController = appWindow.rootViewController;
        if (appWindow.rootViewController != nil && [UIViewController instancesRespondToSelector:@selector(presentedViewController)]) {
            UIViewController *target = rootController;
            while (target.presentedViewController != nil) {
                target = target.presentedViewController;
            }
            return target;
        }
        
        // Fall back to manual view manipulation on the main UIWindow
        return [SZWindowDisplay sharedWindowDisplay];
    }
}

+ (void)setGlobalDisplayBlock:(id<SZDisplay>(^)())displayBlock {
    [[SZNotificationHandler sharedNotificationHandler] setDisplayBlock:displayBlock];
    globalDisplayBlock = displayBlock;
}

@end
