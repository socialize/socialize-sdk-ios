//
//  SZActionBar.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/15/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZActionBar.h"

@interface SZActionBar ()
@end

@implementation SZActionBar
@synthesize backgroundImage = _backgroundImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

+ (CGFloat)defaultHeight {
    return 44;
}

- (void)layoutSubviews {
    
}

- (UIImage*)backgroundImage {
    if (_backgroundImage == nil) {
        _backgroundImage = [[UIImage imageNamed:@"action-bar-bg.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:0.5];
    }
    
    return _backgroundImage;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    NonatomicRetainedSetToFrom(_backgroundImage, backgroundImage);
    [self setNeedsDisplay];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (CGRectIsEmpty(self.frame)) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newSuperview.frame.size.width, [[self class] defaultHeight]);
    }
}

- (void)drawRect:(CGRect)rect 
{	
	[super drawRect:rect];   
	[self.backgroundImage drawInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height) blendMode:kCGBlendModeMultiply alpha:1.0];
}

@end
