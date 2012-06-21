//
//  SZSelectNetworkViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZNavigationController.h"
#import "SocializeCommonDefinitions.h"

@interface SZSelectNetworkViewController : SZNavigationController
@property (nonatomic, copy) void (^completionBlock)(SZSocialNetwork selectedNetworks);
@property (nonatomic, copy) void (^cancellationBlock)();

@end
