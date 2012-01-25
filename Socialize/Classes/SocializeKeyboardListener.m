//
//  SocializeKeyboardListener.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/8/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeKeyboardListener.h"

@interface SocializeKeyboardListener ()
@property (nonatomic, assign) CGRect currentKeyboardFrame;
@end
@implementation SocializeKeyboardListener
@synthesize delegate = delegate_;
@synthesize currentKeyboardFrame = currentKeyboardFrame_;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (id)init {
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];        
    }
    return self;
}

+ (CGRect) convertKeyboardRect:(CGRect)rect toView:(UIView *)view {
    UIWindow *window = [view isKindOfClass:[UIWindow class]] ? (UIWindow *) view : [view window];
    return [view convertRect:[window convertRect:rect fromWindow:nil] fromView:nil];
}

- (CGRect) convertKeyboardRect:(CGRect)rect toView:(UIView *)view {
    return [[self class] convertKeyboardRect:rect toView:view];
}

- (CGRect)currentKeyboardFrameInView:(UIView*)view {
    return [[self class] convertKeyboardRect:self.currentKeyboardFrame toView:view];
}

- (void)extractKeyboardInfoFromNotification:(NSNotification*)notification intoBeginFrame:(CGRect*)beginFrame endFrame:(CGRect*)endFrame animationCurve:(UIViewAnimationCurve*)animationCurve animationDuration:(NSTimeInterval*)animationDuration {
    [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:beginFrame];
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:endFrame];
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:animationCurve];
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:animationDuration];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect beginFrame, endFrame;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    [self extractKeyboardInfoFromNotification:notification intoBeginFrame:&beginFrame endFrame:&endFrame animationCurve:&animationCurve animationDuration:&animationDuration];    
    
    if ([self.delegate respondsToSelector:@selector(keyboardListener:keyboardWillShowWithWithBeginFrame:endFrame:animationCurve:animationDuration:)]) {
        [self.delegate keyboardListener:self keyboardWillShowWithWithBeginFrame:beginFrame endFrame:endFrame animationCurve:animationCurve animationDuration:animationDuration];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification {
    CGRect beginFrame, endFrame;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    [self extractKeyboardInfoFromNotification:notification intoBeginFrame:&beginFrame endFrame:&endFrame animationCurve:&animationCurve animationDuration:&animationDuration];    
    
    self.currentKeyboardFrame = endFrame;
    if ([self.delegate respondsToSelector:@selector(keyboardListener:keyboardDidShowWithWithBeginFrame:endFrame:animationCurve:animationDuration:)]) {
        [self.delegate keyboardListener:self keyboardDidShowWithWithBeginFrame:beginFrame endFrame:endFrame animationCurve:animationCurve animationDuration:animationDuration];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect beginFrame, endFrame;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    [self extractKeyboardInfoFromNotification:notification intoBeginFrame:&beginFrame endFrame:&endFrame animationCurve:&animationCurve animationDuration:&animationDuration];    
    
    if ([self.delegate respondsToSelector:@selector(keyboardListener:keyboardWillHideWithWithBeginFrame:endFrame:animationCurve:animationDuration:)]) {
        [self.delegate keyboardListener:self keyboardWillHideWithWithBeginFrame:beginFrame endFrame:endFrame animationCurve:animationCurve animationDuration:animationDuration];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
    CGRect beginFrame, endFrame;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    [self extractKeyboardInfoFromNotification:notification intoBeginFrame:&beginFrame endFrame:&endFrame animationCurve:&animationCurve animationDuration:&animationDuration];    
    
    self.currentKeyboardFrame = CGRectZero;
    if ([self.delegate respondsToSelector:@selector(keyboardListener:keyboardDidHideWithWithBeginFrame:endFrame:animationCurve:animationDuration:)]) {
        [self.delegate keyboardListener:self keyboardDidHideWithWithBeginFrame:beginFrame endFrame:endFrame animationCurve:animationCurve animationDuration:animationDuration];
    }
}

@end
