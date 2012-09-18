//
//  SZUserProfileViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZNavigationController.h"
#import "SocializeObjects.h"
#import "SZViewControllerWrapper.h"

@interface SZUserProfileViewController : SZViewControllerWrapper
- (id)initWithUser:(id<SZUser>)user;
@property (nonatomic, copy) void (^completionBlock)(id<SZFullUser> user);
@property (nonatomic, readonly, strong) id<SZUser> user;
@end
