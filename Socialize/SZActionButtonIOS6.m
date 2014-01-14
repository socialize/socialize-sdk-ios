//
//  SZActionButtonIOS6.m
//  Socialize
//
//  Created by David Jedeikin on 1/14/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "SZActionButtonIOS6.h"

@implementation SZActionButtonIOS6

+ (UIImage*)defaultDisabledImage {
    return nil;
}

+ (UIImage*)defaultImage {
    return [[UIImage imageNamed:@"action-bar-button-black.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultHighlightedImage {
    return [[UIImage imageNamed:@"action-bar-button-black-hover.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

@end
