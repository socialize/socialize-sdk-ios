//
//  SZUserSettingsViewControllerViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZNavigationController.h"
#import "SocializeObjects.h"
#import "SZViewControllerWrapper.h"

@interface SZUserSettingsViewController : SZViewControllerWrapper
- (id)init;

@property (nonatomic, assign) BOOL hideLogoutButtons;
@property (nonatomic, copy) void (^completionBlock)(BOOL didSave, id<SZFullUser> user);

@end
