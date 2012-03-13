//
//  SocializeActionDisplayHandler.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/** All socializeObject* methods are optional if the display handler acts like a UIViewController. Override as needed.
 * If your display handler does not act like a UIViewController, you must implement all socializeObject* methods.
 */
@protocol SocializeUIDisplay <NSObject>

@optional
- (void)socializeObject:(id)object requiresDisplayOfViewController:(UIViewController*)controller;
- (void)socializeObject:(id)object requiresDismissOfViewController:(UIViewController*)controller;
- (void)socializeObject:(id)object requiresDisplayOfActionSheet:(UIActionSheet*)actionSheet;
- (void)socializeObject:(id)object requiresDisplayOfAlertView:(UIAlertView*)alertView;
- (void)socializeObjectWillStartLoading:(id)object;
- (void)socializeObjectWillStopLoading:(id)object;

// These are fallbacks, used only if the above are not implemented. This allows UIViewController instances to
// be used unmodified if custom behavior is not needed
- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;
- (void)dismissModalViewController:(UIViewController*)controller;
- (UIView*)view;

@end
