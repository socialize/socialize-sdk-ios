//
//  SZLinkDialogViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZNavigationController.h"
#import "SocializeObjects.h"
#import "SZViewControllerWrapper.h"

@interface SZLinkDialogViewController : SZViewControllerWrapper
@property (nonatomic, copy) void (^completionBlock)(SZSocialNetwork selectedNetwork);
@property (nonatomic, copy) void (^cancellationBlock)();

@end
