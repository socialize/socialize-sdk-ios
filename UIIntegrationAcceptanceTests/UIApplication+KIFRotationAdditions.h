//
//  UIApplication+KIFRotationAdditions.h
//  Socialize
//
//  Created by David Jedeikin on 1/30/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (KIFRotationAdditions)

@end

@interface UIApplication (Private)
- (BOOL)rotateIfNeeded:(UIDeviceOrientation)orientation;
- (UIWindow *)statusBarWindow;
@property(getter=isStatusBarHidden) BOOL statusBarHidden;
@end