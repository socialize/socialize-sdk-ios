//
//  SocializeActivityDetailsViewControllerDelegate.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/17/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

@class SocializeActivityDetailsViewController;

@protocol SocializeActivityDetailsViewControllerDelegate <SocializeBaseViewControllerDelegate>
@optional
- (void)activityDetailsViewController:(SocializeActivityDetailsViewController*)activityDetailsViewController didLoadActivity:(id<SocializeActivity>)activity;

@end
