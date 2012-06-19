//
//  SocializeBubbleView.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/11/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocializeBubbleView : UIView
- (id)initWithSize:(CGSize)size;
- (void)animateOutAndRemoveFromSuperview;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view offset:(CGPoint)offset animated:(BOOL)animated;

@property (nonatomic, retain) UIView *contentView;
@end
