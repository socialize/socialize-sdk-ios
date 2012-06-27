//
//  UIAlertView+Observer.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/13/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "UIAlertView+Observer.h"
#import "JRSwizzle.h"

NSString *const UIAlertViewDidShowNotification = @"UIAlertViewDidShowNotification";

@implementation UIAlertView (Observer)

+ (void)load {
    NSError *error = nil;
    [self jr_swizzleMethod:@selector(show) withMethod:@selector(observerShow_) error:&error];
    NSAssert(error == nil, @"error swizzling");
}

- (void)observerShow_ {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIAlertViewDidShowNotification object:self];
}

@end
