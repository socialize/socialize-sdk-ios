//
//  SocializeBaseViewControllerDelegate.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/16/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

@class SocializeBaseViewController;

@protocol SocializeBaseViewControllerDelegate <NSObject>

@optional

- (void)baseViewControllerDidCancel:(SocializeBaseViewController*)baseViewController;
- (void)baseViewControllerDidFinish:(SocializeBaseViewController*)baseViewController;

@end

