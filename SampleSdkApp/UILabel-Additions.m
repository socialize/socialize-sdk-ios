//
//  UILabel-Additions.m
//  appbuildr
//
//  Created by Fawad Haider  on 1/21/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "UILabel-Additions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UILabel(UIAdditions)

-(void)applyBlurAndShadow
{
    [self applyBlurAndShadowWithOffset:1.0];
}


-(void)applyBlurAndShadowWithOffset:(CGFloat) offset;
{
	self.layer.shadowRadius = 0.0;
	self.layer.shadowOpacity = 1.0;
	self.layer.shadowOffset = CGSizeMake(0, offset);
	self.layer.shadowColor = [UIColor blackColor].CGColor; 
}
@end
	