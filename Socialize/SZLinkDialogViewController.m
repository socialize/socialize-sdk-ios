//
//  SZLinkDialogViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZLinkDialogViewController.h"
#import "_SZLinkDialogViewController.h"

@interface SZLinkDialogViewController ()
@property (nonatomic, strong) _SZLinkDialogViewController *linkDialog;

@end

@implementation SZLinkDialogViewController
@synthesize linkDialog = _linkDialog;
@dynamic completionBlock;
@dynamic cancellationBlock;

- (id)init {
    if (self = [super init]) {
        self.linkDialog = [[_SZLinkDialogViewController alloc] initWithDelegate:nil];
        [self pushViewController:self.linkDialog animated:NO];
    }
    
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.linkDialog;
}

@end
