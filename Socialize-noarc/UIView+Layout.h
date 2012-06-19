//
//  UIView+Layout.h
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/29/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SocializeLayout)

/** this method gets the diagonal point from the origin.  This is useful for laying out views, especially when stacking views vertical/horizontally within its superview */
@property(nonatomic, readonly) CGPoint diagonalPoint;

/** this method takes the receiver and increases it's frame to fill the view.  If the receiver increases it to a point in which is smaller than it's minimum allowable size, meaning there isn't enough space to properly display the receiver then it will just make the receiver the minSize   */
-(void)fillRestOfView:(UIView *)containerView minSize:(CGSize)minSize;

/** this method change the receivers's frame to be below the given view.  Only the origin is changed on the frame not the reciever's size. */
-(void) positionBelowView:(UIView *)upperView;
@end
