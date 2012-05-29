//
//  SZDisplay.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SZDisplay <NSObject>

- (void)socializeWillBeginDisplaySequenceWithViewController:(UIViewController*)viewController;
- (void)socializeWillTransitionFromViewController:(UIViewController*)fromViewController toViewController:(UIViewController *)toViewController;
- (void)socializeWillReturnToViewController:(UIViewController*)viewController;
- (void)socializeWillEndDisplaySequence;
- (void)socializeWillStartLoadingWithMessage:(NSString*)message;
- (void)socializeWillStopLoading;

@end

@interface SZBlockDisplay : NSObject <SZDisplay>

+ (SZBlockDisplay*)blockDisplay;
+ (SZBlockDisplay*)blockDisplayWithFallback:(id<SZDisplay>)fallback;

@property (nonatomic, copy) void (^beginBlock)(UIViewController *viewController);
@property (nonatomic, copy) void (^transitionBlock)(UIViewController *a, UIViewController *b);
@property (nonatomic, copy) void (^returnBlock)(UIViewController *viewController);
@property (nonatomic, copy) void (^endBlock)();
@property (nonatomic, copy) void (^startLoadingBlock)(NSString *message);
@property (nonatomic, copy) void (^stopLoadingBlock)();

@property (nonatomic, retain) id<SZDisplay> fallbackDisplay;

@end

@interface SZStackDisplay : NSObject <SZDisplay>
- (void)beginWithOrTransitionToViewController:(UIViewController *)viewController;
+ (SZStackDisplay*)stackDisplayForDisplay:(id<SZDisplay>)display;
@end

@interface UIViewController (SZDisplay) <SZDisplay>
@end