//
//  SocializeAction.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeUIDisplay.h"

@interface SocializeUIDisplayProxy : NSObject
/** Informal SocializeActionDisplayHandler */
@property (nonatomic, assign) id display;
@property (nonatomic, assign) id object;
@property (nonatomic, assign, readonly) BOOL loading;

+ (id)UIDisplayProxyWithObject:(id)object display:(id)display;
- (id)initWithObject:(id) object display:(id)display;
- (void)presentModalViewController:(UIViewController*)controller;
- (void)dismissModalViewController:(UIViewController*)controller;
- (void)showActionSheet:(UIActionSheet*)actionSheet;
- (void)showAlertView:(UIAlertView*)alertView;
- (void)startLoading;
- (void)stopLoading;
@end