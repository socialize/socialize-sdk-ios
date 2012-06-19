//
//  UIViewController+Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "UIViewController+Socialize.h"
#import "UINavigationController+Socialize.h"

@implementation UIViewController (Socialize)

- (UINavigationController*)wrappingSocializeNavigationController {
    UINavigationController *nav = [UINavigationController socializeNavigationControllerWithRootViewController:self];
    return nav;
}

@end