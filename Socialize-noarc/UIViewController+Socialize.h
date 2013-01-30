//
//  UIViewController+Socialize.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Socialize)

- (UINavigationController*)wrappingSocializeNavigationController;
- (void)SZDismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
- (void)SZPresentViewController:(UIViewController*)viewController animated:(BOOL)flag completion:(void (^)(void))completion;
- (UIViewController*)SZPresentingViewController;

- (UIViewController*)SZPresentationTarget;

@end
