//
//  SZNavigationControllerIOS6.m
//  Socialize
//
//  Created by David Jedeikin on 1/5/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "SZNavigationControllerIOS6.h"
#import "UINavigationBarBackground.h"

@implementation SZNavigationControllerIOS6

- (id)init {
    if (self = [super init]) {
        [SZNavigationControllerIOS6 initNavigationBar:self];
    }
    
    return self;
}

//available to other subclasses of SZNavigationController
+ (void)initNavigationBar:(UINavigationController *)controller {
    UIImage * socializeNavBarBackground = [UIImage imageNamed:@"socialize-navbar-bg.png"];
    [controller.navigationBar setBackgroundImage:socializeNavBarBackground];
}

@end
