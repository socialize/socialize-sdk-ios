//
//  SZCommentButton.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/23/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZCommentButton.h"

@implementation SZCommentButton

- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity {
    if (self = [super initWithFrame:frame]) {
        self.icon = [UIImage imageNamed:@"action-bar-icon-comments.png"];
    }
    return self;
}

@end
