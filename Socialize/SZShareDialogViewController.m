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
@dynamic headerView;
@dynamic footerView;
@synthesize title = __title;
@synthesize shareDialog = _shareDialog;
@synthesize shares = _shares;
@synthesize entity = entity_;
@dynamic continueText;

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

- (void)setTitle:(NSString *)title {
    __title = title;
    [self.shareDialog setTitle:title];
}

- (NSString*)title {
    return self.shareDialog.title;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.shareDialog;
}

@end
