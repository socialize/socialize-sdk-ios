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

@end

@implementation SZShareDialogViewController
@dynamic completionBlock;
@dynamic cancellationBlock;
@dynamic headerView;
@dynamic footerView;
@dynamic continueText;
@synthesize title = __title;

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
    self._shareDialogViewController = [[_SZShareDialogViewController alloc] initWithEntity:self.entity];
    [self pushViewController:self._shareDialogViewController animated:NO];
}

- (void)setTitle:(NSString *)title {
    __title = title;
    [self._shareDialogViewController setTitle:title];
}

- (NSString*)title {
    return self._shareDialogViewController.title;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self._shareDialogViewController;
}

@end
