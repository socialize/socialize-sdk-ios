//
//  SZSelectNetworkViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZSelectNetworkViewController.h"
#import "_SZSelectNetworkViewController.h"

@interface SZSelectNetworkViewController ()
@end

@implementation SZSelectNetworkViewController
@dynamic completionBlock;
@dynamic cancellationBlock;
@synthesize selectNetwork = _selectNetwork;
@dynamic continueText;

- (id)init {
    if (self = [super init]) {
        self.selectNetwork = [[_SZSelectNetworkViewController alloc] init];
        [self pushViewController:self.selectNetwork animated:NO];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title {
    [self.selectNetwork setTitle:title];
}
     
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.selectNetwork;
}

@end
