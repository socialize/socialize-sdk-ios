//
//  SZDisplay.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SZDisplay <NSObject>

- (void)socializeWillBeginDisplaySequenceWithViewController:(UIViewController*)viewController;
- (void)socializeWillTransitionFromViewController:(UIViewController*)fromViewController toViewController:(UIViewController *)toViewController;
- (void)socializeWillReturnToViewController:(UIViewController*)viewController;
- (void)socializeWillShowAlertView:(UIAlertView*)alertView;
- (void)socializeWillEndDisplaySequence;
- (void)socializeWillStartLoadingWithMessage:(NSString*)message;
- (void)socializeWillStopLoading;

@end


#define SDBEGIN(d, v) [d socializeWillBeginDisplaySequenceWithViewController:v];
#define SDT(d, u, v) [d socializeWillTransitionFromViewController:u toViewController:v];
#define SDRET(d, v) [d socializeWillReturnToViewController:v]
#define SDEND(d) [d socializeWillEndDisplaySequence]

@interface SZBlockDisplay : NSObject <SZDisplay>

+ (SZBlockDisplay*)blockDisplay;
+ (SZBlockDisplay*)blockDisplayWrappingDisplay:(id<SZDisplay>)fallback;
+ (SZBlockDisplay*)blockDisplayWrappingDisplay:(id<SZDisplay>)fallback beginSequence:(void(^)(UIViewController*))beginSequence endSequence:(void(^)())endSequence;
@property (nonatomic, copy) void (^beginBlock)(UIViewController *viewController);
@property (nonatomic, copy) void (^transitionBlock)(UIViewController *a, UIViewController *b);
@property (nonatomic, copy) void (^returnBlock)(UIViewController *viewController);
@property (nonatomic, copy) void (^endBlock)();
@property (nonatomic, copy) void (^alertBlock)(UIAlertView *alertView);
@property (nonatomic, copy) void (^startLoadingBlock)(NSString *message);
@property (nonatomic, copy) void (^stopLoadingBlock)();

@property (nonatomic, retain) id<SZDisplay> fallbackDisplay;

@end

@interface SZDisplayWrapper : NSObject <SZDisplay>
- (id)initWithDisplay:(id<SZDisplay>)outerDisplay continueBlock:(void(^)(UIViewController*))continueBlock existingStack:(NSArray*)existingStack;
+ (SZDisplayWrapper*)displayWrapperWithDisplay:(id<SZDisplay>)display;
+ (SZDisplayWrapper*)displayWrapperWithDisplay:(id<SZDisplay>)display continueBlock:(void(^)(UIViewController*))continueBlock;
+ (SZDisplayWrapper*)displayWrapperWithDisplay:(id<SZDisplay>)display continueBlock:(void(^)(UIViewController*))continueBlock existingStack:(NSArray*)existingStack;
- (void)pop;
- (void)pushViewController:(UIViewController*)viewController;
- (void)beginWithOrTransitionToViewController:(UIViewController *)viewController;
- (void)beginSequenceWithViewController:(UIViewController*)viewController;
- (void)transitionFromViewController:(UIViewController*)fromViewController toViewController:(UIViewController*)toViewController;
- (void)endSequence;
- (void)returnToViewController:(UIViewController*)viewController;
- (UIViewController*)topController;
- (void)startLoadingInTopControllerWithMessage:(NSString*)message;
- (void)stopLoadingInTopController;
- (void)showAlertView:(UIAlertView*)alertView;

@property (nonatomic, copy) void (^continueBlock)();
@property (nonatomic, copy) void (^endBlock)();
@property (nonatomic, assign) BOOL running;
@end

@interface UIViewController (SZDisplay) <SZDisplay>
@end