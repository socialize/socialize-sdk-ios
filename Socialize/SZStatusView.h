//
//  SZStatusView.h
//  Socialize
//
//  Created by Nathaniel Griswold on 8/27/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZStatusView : UIView

- (id)initWithFrame:(CGRect)frame contentNibName:(NSString*)contentNibName;
- (void)showAndHideInKeyWindow;
- (void)showAndHideInView:(UIView*)view withDuration:(NSTimeInterval)duration;
- (void)showAndHideInView:(UIView*)view;

@property (strong, nonatomic) IBOutlet UIView *centerContentView;
@property (nonatomic, strong) UIView *centerView;

+ (SZStatusView*)successStatusViewWithFrame:(CGRect)frame;


@end
