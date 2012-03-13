//
//  SocializeUIDisplayProxyDelegate.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/6/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SocializeUIDisplayProxy;

@protocol SocializeUIDisplayProxyDelegate <NSObject>
@optional
- (void)displayProxy:(SocializeUIDisplayProxy*)proxy willDisplayViewController:(UIViewController*)controller;
- (BOOL)displayProxy:(SocializeUIDisplayProxy*)proxy shouldDisplayActionSheet:(UIActionSheet*)actionSheet;
@end
