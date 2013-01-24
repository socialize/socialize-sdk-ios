//
//  UIBarButtonItem+Socialize.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/29/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Socialize.h"

@interface UIBarButtonItem (Socialize)

+ (UIBarButtonItem*)redSocializeBarButtonWithTitle:(NSString*)title handler:(void(^)(id sender))handler;
+ (UIBarButtonItem*)blueSocializeBarButtonWithTitle:(NSString*)title handler:(void(^)(id sender))handler;

- (void)changeTitleOnCustomButtonToText:(NSString*)text;
- (void)changeTitleOnCustomButtonToText:(NSString*)text type:(AMSocializeButtonType)type;

@end
