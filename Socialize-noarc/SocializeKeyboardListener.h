//
//  SocializeKeyboardListener.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/8/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SocializeKeyboardListenerDelegate;

@interface SocializeKeyboardListener : NSObject
@property (nonatomic, assign) id<SocializeKeyboardListenerDelegate> delegate;
@property (nonatomic, assign, readonly) CGRect currentKeyboardFrame;

- (CGRect)currentKeyboardFrameInView:(UIView*)view;
// Keyboard rects are given in screen coordinates
+ (CGRect)convertKeyboardRect:(CGRect)rect toView:(UIView *)view;
- (CGRect) convertKeyboardRect:(CGRect)rect toView:(UIView *)view;
@end

@protocol SocializeKeyboardListenerDelegate <NSObject>
@optional
- (void)keyboardListener:(SocializeKeyboardListener*)keyboardListener keyboardWillShowWithWithBeginFrame:(CGRect)beginFrame endFrame:(CGRect)endFrame animationCurve:(UIViewAnimationCurve)animationCurve animationDuration:(NSTimeInterval)animationDuration;
- (void)keyboardListener:(SocializeKeyboardListener*)keyboardListener keyboardDidShowWithWithBeginFrame:(CGRect)beginFrame endFrame:(CGRect)endFrame animationCurve:(UIViewAnimationCurve)animationCurve animationDuration:(NSTimeInterval)animationDuration;
- (void)keyboardListener:(SocializeKeyboardListener*)keyboardListener keyboardWillHideWithWithBeginFrame:(CGRect)beginFrame endFrame:(CGRect)endFrame animationCurve:(UIViewAnimationCurve)animationCurve animationDuration:(NSTimeInterval)animationDuration;
- (void)keyboardListener:(SocializeKeyboardListener*)keyboardListener keyboardDidHideWithWithBeginFrame:(CGRect)beginFrame endFrame:(CGRect)endFrame animationCurve:(UIViewAnimationCurve)animationCurve animationDuration:(NSTimeInterval)animationDuration;

@end