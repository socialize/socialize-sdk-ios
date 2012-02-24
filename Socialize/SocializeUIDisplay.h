//
//  SocializeActionDisplayHandler.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/** All methods are optional if the display handler acts like a UIViewController. Override as needed.
 * If your display handler does not act like a UIViewController, you must implement all methods.
 */
@interface NSObject (SocializeUIDisplay)

- (void)socializeObject:(id)object requiresDisplayOfViewController:(UIViewController*)controller;
- (void)socializeObject:(id)object requiresDismissOfViewController:(UIViewController*)controller;
- (void)socializeObject:(id)object requiresDisplayOfActionSheet:(UIActionSheet*)actionSheet;
- (void)socializeObjectWillStartLoading:(id)object;
- (void)socializeObjectWillStopLoading:(id)object;
@end
