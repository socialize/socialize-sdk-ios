//
//  SocializeHorizontalContainer.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/20/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeHorizontalContainerView.h"

@implementation SocializeHorizontalContainerView
@synthesize columns = columns_;

- (void)removeAllSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)layoutColumns {
    [self removeAllSubviews];
    
    // Currently always lays out right-justified
    
    CGFloat curX = self.frame.size.width;
    
    for (UIView *view in [self.columns reverseObjectEnumerator]) {
        CGFloat x = curX - view.frame.size.width;
        view.frame = CGRectMake(x, 0, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];
        
        curX -= view.frame.size.width;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self layoutColumns];
}

@end
