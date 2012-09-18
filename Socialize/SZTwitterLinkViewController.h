//
//  SZTwitterLinkViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZNavigationController.h"
#import "SZViewControllerWrapper.h"

@interface SZTwitterLinkViewController : SZViewControllerWrapper
- (id)initWithConsumerKey:(NSString*)consumerKey consumerSecret:(NSString*)consumerSecret;
@property (nonatomic, copy) void (^completionBlock)();
@property (nonatomic, copy) void (^cancellationBlock)();
@end
