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
@synthesize rightJustified = _rightJustified;
@synthesize initialPadding = _initialPadding;
@synthesize padding = _padding;

- (void)removeUnneededSubviews {
    for (UIView *subview in self.subviews) {
        if (![self.columns containsObject:subview]) {
            [subview removeFromSuperview];
        }
    }
}

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (hitView == self) return nil;
    else return hitView;
}

- (void)layoutColumnsRight {
    [self removeUnneededSubviews];
    
    CGFloat curX = self.frame.size.width - self.initialPadding;
    
    for (UIView *view in [self.columns reverseObjectEnumerator]) {
        CGFloat x = curX - view.frame.size.width;
        
        CGFloat y = roundf(self.centerColumns ? self.frame.size.height / 2.f - view.frame.size.height / 2.f : 0);
        
        view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];
        
        curX -= view.frame.size.width + self.padding;
    }
}

- (void)layoutColumnsLeft {
    [self removeUnneededSubviews];
    
    CGFloat curX = self.initialPadding;
    
    for (UIView *view in self.columns) {
        CGFloat x = curX;
        CGFloat y = roundf(self.centerColumns ? self.frame.size.height / 2.f - view.frame.size.height / 2.f : 0);
        
        view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];
        
        curX += view.frame.size.width + self.padding;
    }
}

- (void)layoutColumns {
    if (self.isRightJustied) {
        [self layoutColumnsRight];
    } else {
        [self layoutColumnsLeft];
    }
}

- (void)setColumns:(NSArray *)columns {
    _columns = columns;
    [self layoutColumns];
}

- (void)setRightJustified:(BOOL)rightJustified {
    _rightJustified = rightJustified;
    [self layoutColumns];
}

@end
