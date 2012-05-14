//
//  SocializeVerticalLayoutContainerView.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeVerticalLayoutContainerView.h"

@implementation SocializeVerticalLayoutContainerView
@synthesize rows = rows_;

- (void)removeAllSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)layoutRows {
    
    // Currently always lays out right-justified
    
    CGFloat curY = 0;
    
    [self removeAllSubviews];

    for (UIView *view in self.rows) {
        CGFloat centeredStart = self.frame.size.width / 2.f - view.frame.size.width / 2.f;
        view.frame = CGRectMake(centeredStart, curY, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];

        curY += view.frame.size.height;
    }
}

@end
