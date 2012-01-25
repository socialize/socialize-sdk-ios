//
//  UIView+Layout.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/29/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (SocializeLayout)

@dynamic diagonalPoint;

-(void) positionBelowView:(UIView *)upperView
{
    //this method should only move the view along the y coordinate
    CGFloat yCoord = upperView.frame.origin.y + upperView.frame.size.height;
    CGRect viewFrame = self.frame;
    viewFrame.origin.y = yCoord;
    self.frame = viewFrame;
}

-(CGPoint)diagonalPoint {
    CGFloat x = self.frame.size.width + self.frame.origin.x;
    CGFloat y = self.frame.size.height + self.frame.origin.y;
    return CGPointMake(x,y);
}


-(void)fillRestOfView:(UIView *)containerView minSize:(CGSize)minSize {
    CGRect viewFrame = self.frame;
    
    //calculate new height for frame
    CGFloat newHeight = containerView.frame.size.height - viewFrame.origin.y;
    if (newHeight < minSize.height) {
        newHeight = minSize.height;
    }
    viewFrame.size.height = newHeight; 
    
    //calculate new width for frame
    CGFloat newWidth = containerView.frame.size.width - viewFrame.origin.x;
    if (newWidth < minSize.width) {
        newWidth = minSize.width;
    }
    viewFrame.size.width = newWidth;     
    self.frame = viewFrame;
}

@end
