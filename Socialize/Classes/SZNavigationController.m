//
//  SZNavigationController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/27/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZNavigationController.h"
#import "UINavigationBarBackground.h"

@interface SZNavigationController ()

@end

@implementation SZNavigationController

- (id)init {
    if (self = [super init]) {
        UIImage * socializeNavBarBackground = [UIImage imageNamed:@"socialize-navbar-bg.png"];
        [self.navigationBar setBackgroundImage:socializeNavBarBackground];
    }
    
    return self;
}

@end
