//
//  UINavigationController+Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/1/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "UINavigationController+Socialize.h"
#import "UINavigationBarBackground.h"

@implementation UINavigationController (Socialize)
+ (UINavigationController*)socializeNavigationControllerWithRootViewController:(UIViewController*)viewController {
    UIImage * socializeNavBarBackground = [UIImage imageNamed:@"socialize-navbar-bg.png"];
    
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    [nav.navigationBar setBackgroundImage:socializeNavBarBackground];
    return nav;
}


@end