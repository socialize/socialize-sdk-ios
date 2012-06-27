//
//  SocializeKeyboardListenerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/12/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeKeyboardListener.h"
#import "SocializeKeyboardListenerTests.h"

@implementation SocializeKeyboardListenerTests
@synthesize keyboardListener = keyboardListener_;
@synthesize mockDelegate = mockDelegate_;

- (BOOL)shouldRunOnMainThread {
    return YES;
}

- (void)setUp {
    self.keyboardListener = [[[SocializeKeyboardListener alloc] init] autorelease];
    self.mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeKeyboardListenerDelegate)];
    self.keyboardListener.delegate = self.mockDelegate;
}

- (void)tearDown {
    [self.mockDelegate verify];
    
    self.mockDelegate = nil;
    self.keyboardListener = nil;
}

- (NSMutableDictionary*)userInfoForBeginFrame:(CGRect)beginFrame
                                     endFrame:(CGRect)endFrame
                                        curve:(UIViewAnimationCurve)curve
                                     duration:(NSTimeInterval)duration {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    [userInfo setObject:[NSValue valueWithBytes:&beginFrame objCType:@encode(CGRect)] forKey:UIKeyboardFrameBeginUserInfoKey];
    [userInfo setObject:[NSValue valueWithBytes:&endFrame objCType:@encode(CGRect)] forKey:UIKeyboardFrameEndUserInfoKey];

    NSValue *curveValue = [NSValue valueWithBytes:&curve objCType:@encode(UIViewAnimationCurve)];
    [userInfo setObject:curveValue forKey:UIKeyboardAnimationCurveUserInfoKey];

    NSValue *durationValue = [NSValue valueWithBytes:&duration objCType:@encode(NSTimeInterval)];
    [userInfo setObject:durationValue forKey:UIKeyboardAnimationDurationUserInfoKey];
    
    return userInfo;
}

- (NSValue*)valueForRect:(CGRect)rect {
    return [NSValue valueWithBytes:&rect objCType:@encode(CGRect)];
}

- (NSValue*)valueForCurve:(UIViewAnimationCurve)curve {
    return [NSValue valueWithBytes:&curve objCType:@encode(UIViewAnimationCurve)];
}

- (NSValue*)valueForFloat:(UIViewAnimationCurve)curve {
    return [NSValue valueWithBytes:&curve objCType:@encode(UIViewAnimationCurve)];
}

CGRect testBeginFrame = { 1.f, 2.f, 3.f, 4.f };
CGRect testEndFrame = { 5.f, 6.f, 7.f, 8.f };

NSTimeInterval testDuration = 1234.f;
UIViewAnimationCurve testCurve = UIViewAnimationCurveEaseOut;

- (NSMutableDictionary*)basicTestUserInfo {
    NSMutableDictionary *userInfo = [self userInfoForBeginFrame:testBeginFrame
                                                       endFrame:testEndFrame
                                                          curve:testCurve
                                                       duration:testDuration];
    

    return userInfo;
}   

- (void)testKeyboardWillShow {
    [[self.mockDelegate expect] keyboardListener:self.keyboardListener keyboardWillShowWithWithBeginFrame:testBeginFrame endFrame:testEndFrame animationCurve:testCurve animationDuration:testDuration];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification object:nil userInfo:[self basicTestUserInfo]];
}

- (void)testKeyboardDidShow {
    [[self.mockDelegate expect] keyboardListener:self.keyboardListener keyboardDidShowWithWithBeginFrame:testBeginFrame endFrame:testEndFrame animationCurve:testCurve animationDuration:testDuration];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidShowNotification object:nil userInfo:[self basicTestUserInfo]];
}

- (void)testKeyboardWillHide {
    [[self.mockDelegate expect] keyboardListener:self.keyboardListener keyboardWillHideWithWithBeginFrame:testBeginFrame endFrame:testEndFrame animationCurve:testCurve animationDuration:testDuration];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil userInfo:[self basicTestUserInfo]];
}

- (void)testKeyboardDidHide {
    [[self.mockDelegate expect] keyboardListener:self.keyboardListener keyboardDidHideWithWithBeginFrame:testBeginFrame endFrame:testEndFrame animationCurve:testCurve animationDuration:testDuration];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification object:nil userInfo:[self basicTestUserInfo]];
}

@end
