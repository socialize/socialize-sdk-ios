//
//  UIBarButtonItem+Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/29/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "UIBarButtonItem+Socialize.h"
#import "socialize_globals.h"
#import <SZBlocksKit/BlocksKit+UIKit.h>

@implementation UIBarButtonItem (Socialize)

- (void)changeTitleOnCustomButtonToText:(NSString*)text {
    UIButton *button = (UIButton*)[self customView];
    if ([button isKindOfClass:[UIButton class]]) {
        [button configureWithTitle:text];
    }
}

- (void)changeTitleOnCustomButtonToText:(NSString*)text type:(AMSocializeButtonType)type {
    UIButton *button = (UIButton*)[self customView];
    if ([button isKindOfClass:[UIButton class]]) {
        [button configureWithTitle:text type:type];
    }
}

+ (UIBarButtonItem*)redSocializeBarButtonWithTitle:(NSString*)title handler:(void(^)(id sender))handler {
    UIButton *button = [UIButton redSocializeNavBarButtonWithTitle:title];
    [button bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+ (UIBarButtonItem*)blueSocializeBarButtonWithTitle:(NSString*)title handler:(void(^)(id sender))handler {
    UIButton *button = [UIButton blueSocializeNavBarButtonWithTitle:title];
    [button bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}


@end
