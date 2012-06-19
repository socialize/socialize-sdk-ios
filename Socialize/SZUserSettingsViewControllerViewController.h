//
//  SZUserSettingsViewControllerViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZUserSettingsViewControllerViewController : UINavigationController
- (id)init;

@property (nonatomic, copy) void (^completionBlock)(BOOL didSave, id<SZFullUser> user);

@end
