//
//  UIColor+Socialize.m
//  Socialize
//
//  Created by David Jedeikin on 1/14/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "UIColor+Socialize.h"

@implementation UIColor (Socialize)

+ (UIColor *)navigationBarBackgroundColor {
    return [UIColor colorWithRed:(17.0f/255.0f)
                           green:(97.0/255.0f)
                            blue:(153.0f/255.0f)
                           alpha:1.0f];
}

+ (UIColor *)actionBarBackgroundColor {
    return [UIColor colorWithRed:(31.0f/255.0f)
                           green:(43.0f/255.0f)
                            blue:(51.0f/255.0f)
                           alpha:1.0f];
}

+ (UIColor *)buttonTextHighlightColor {
    return [UIColor colorWithRed:(187.0f/255.0f)
                           green:(191.0f/255.0f)
                            blue:(191.0f/255.0f)
                           alpha:1.0f];
}

@end
