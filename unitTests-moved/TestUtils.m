//
//  TestUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/9/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "TestUtils.h"
#import <objc/runtime.h>

@implementation UIControl (TestUtils)
- (void)simulateControlEvent:(UIControlEvents)event {
    for (id target in [self allTargets]) {
        NSArray *actions = [self actionsForTarget:target forControlEvent:event];
        for (NSString *selName in actions) {
            SEL sel = NSSelectorFromString(selName);
            [target performSelector:sel withObject:self];
        }
    }

}
@end
void RunOnMainThread(void (^blk)()) {
    if ([NSThread isMainThread]) {
        NSLog(@"Running block directly");
        blk();
    } else {
        NSLog(@"Adding block to queue");
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"Running block on queue");
            blk();
        });
    }
}

@implementation UIActionSheet (TestUtils)
- (void)simulateButtonPressAtIndex:(int)index {
    [self _buttonClicked:[self buttonAtIndex:index]];

}
@end

@implementation UIAlertView (TestUtils)
- (void)simulateButtonPressAtIndex:(int)index {
    [self _buttonClicked:[self buttonAtIndex:index]];

}
@end


