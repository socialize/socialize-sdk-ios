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
@property (nonatomic, strong) _SZSelectNetworkViewController *selectNetwork;
@end

@implementation SZSelectNetworkViewController
@synthesize completionBlock = _completionBlock;
@synthesize selectNetwork = _selectNetwork;

- (id)init {
    if (self = [super init]) {
    }
    
    return self;
}

- (_SZSelectNetworkViewController*)settings {
    if (_selectNetwork == nil) {
        _selectNetwork = [[_SZSelectNetworkViewController alloc] initWithEntity:nil];
    }
    return _selectNetwork;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setCompletionBlock:(void (^)(SZSocialNetwork selectedNetworks))completionBlock {
    _completionBlock = completionBlock;
    self.selectNetwork.completionBlock = completionBlock;
}

@end
