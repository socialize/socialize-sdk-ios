//
//  SocializeHorizontalContainer.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/20/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZHorizontalContainerView.h"

@implementation SZHorizontalContainerView
@synthesize columns = _columns;
@synthesize centerColumns = _centerColumns;
@synthesize initialPadding = _initialPadding;
@synthesize padding = _padding;

- (void)removeUnneededSubviews {
    for (UIView *subview in self.subviews) {
        if (![self.columns containsObject:subview]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)layoutColumns {
    [self removeUnneededSubviews];
    
    // Currently always lays out right-justified
    
    CGFloat curX = self.frame.size.width - self.initialPadding;
    
    for (UIView *view in [self.columns reverseObjectEnumerator]) {
        CGFloat x = curX - view.frame.size.width;
        
        CGFloat y = roundf(self.centerColumns ? self.frame.size.height / 2.f - view.frame.size.height / 2.f : 0);
        
        view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];
        
        curX -= view.frame.size.width + self.padding;
    }
}

- (void)setColumns:(NSArray *)columns {
    _columns = columns;
    [self layoutColumns];
}

@end
