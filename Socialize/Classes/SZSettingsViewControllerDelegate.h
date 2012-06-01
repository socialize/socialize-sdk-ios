//
//  SZSettingsViewControllerDelegate.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/17/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewControllerDelegate.h"

@class SZSettingsViewController;
@protocol SocializeFullUser;

@protocol SZSettingsViewControllerDelegate <SocializeBaseViewControllerDelegate>

@optional
- (void)profileEditViewController:(SZSettingsViewController*)profileEditViewController didUpdateProfileWithUser:(id<SocializeFullUser>)user;

@end

