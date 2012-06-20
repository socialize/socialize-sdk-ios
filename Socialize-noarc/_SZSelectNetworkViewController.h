//
//  _SZSelectNetworkViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZBaseShareViewController.h"

@interface _SZSelectNetworkViewController : SZBaseShareViewController

@property (nonatomic, copy) void (^completionBlock)(SZSocialNetwork selectedNetworks);

@end
