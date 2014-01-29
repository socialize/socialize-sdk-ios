//
//  SZLikeButtonIOS6.m
//  Socialize
//
//  Created by David Jedeikin on 1/14/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "SZLikeButtonIOS6.h"

@implementation SZLikeButtonIOS6

+ (UIImage*)defaultDisabledImage {
    return [[UIImage imageNamed:@"action-bar-button-black.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultInactiveImage {
    return [[UIImage imageNamed:@"action-bar-button-black.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultInactiveHighlightedImage {
    return [[UIImage imageNamed:@"action-bar-button-black-hover.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultActiveImage {
    return [[UIImage imageNamed:@"action-bar-button-red.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultActiveHighlightedImage {
    return [[UIImage imageNamed:@"action-bar-button-red-hover.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

- (void)resetButtonsToDefaults {
    [super resetButtonsToDefaults];
    self.actualButton.backgroundColor = [UIColor clearColor];
}

@end
