//
//  SZSelectNetworkViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZNavigationController.h"
#import "SocializeCommonDefinitions.h"
#import "SZViewControllerWrapper.h"

@class _SZSelectNetworkViewController;

@interface SZSelectNetworkViewController : SZViewControllerWrapper
@property (nonatomic, strong) _SZSelectNetworkViewController *selectNetwork;
@property (nonatomic, copy) void (^completionBlock)(SZSocialNetwork selectedNetworks);
@property (nonatomic, copy) void (^cancellationBlock)();
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *continueText;

@end
