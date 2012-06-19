//
//  _SZUserSettingsViewControllerDelegate.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/17/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewControllerDelegate.h"

@class _SZUserSettingsViewController;
@protocol SocializeFullUser;

@protocol _SZUserSettingsViewControllerDelegate <SocializeBaseViewControllerDelegate>

@optional
- (void)profileEditViewController:(_SZUserSettingsViewController*)profileEditViewController didUpdateProfileWithUser:(id<SocializeFullUser>)user;

@end

