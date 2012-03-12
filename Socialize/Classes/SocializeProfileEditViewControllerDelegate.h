//
//  SocializeProfileEditViewControllerDelegate.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/17/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewControllerDelegate.h"

@class SocializeProfileEditViewController;
@protocol SocializeFullUser;

@protocol SocializeProfileEditViewControllerDelegate <SocializeBaseViewControllerDelegate>

- (void)profileEditViewController:(SocializeProfileEditViewController*)profileEditViewController didUpdateProfileWithUser:(id<SocializeFullUser>)user;

@end

