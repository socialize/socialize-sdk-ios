//
//  SocializeRichPushNotificationDisplayController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/27/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeNotificationDisplayController.h"
#import "SocializeRichPushNotificationViewController.h"
#import "SocializeBaseViewControllerDelegate.h"

@interface SocializeDirectURLNotificationDisplayController : SocializeNotificationDisplayController <SocializeBaseViewControllerDelegate>

@property (nonatomic, retain) UINavigationController *navigationController;

@end
