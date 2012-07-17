//
//  SZShareDialogViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZShareDialogViewController.h"
#import "_SZShareDialogViewController.h"

@interface SZShareDialogViewController ()
@property (nonatomic, strong) _SZShareDialogViewController *shareDialog;

@end

@implementation SZShareDialogViewController
@dynamic completionBlock;
@dynamic cancellationBlock;
@synthesize shareDialog = _shareDialog;
@synthesize shares = _shares;
@synthesize entity = entity_;

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super init]) {
        self.entity = entity;
        [self createShareDialog];
    }
    
    return self;
}

- (void)createShareDialog {
    self.shareDialog = [[_SZShareDialogViewController alloc] initWithEntity:self.entity];
    [self pushViewController:self.shareDialog animated:NO];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.shareDialog;
}

@end
