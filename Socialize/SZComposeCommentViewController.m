//
//  SZComposeCommentViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZComposeCommentViewController.h"
#import "_SZComposeCommentViewController.h"

@interface SZComposeCommentViewController ()
@property (nonatomic, strong) _SZComposeCommentViewController *composeComment;
@property (nonatomic, strong) id<SZEntity> entity;

@end

@implementation SZComposeCommentViewController
@synthesize composeComment = _composeComment;
@synthesize entity = _entity;
@dynamic completionBlock;
@dynamic cancellationBlock;

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super init]) {
        self.entity = entity;
        self.composeComment = [[_SZComposeCommentViewController alloc] initWithEntity:self.entity];
        [self pushViewController:self.composeComment animated:NO];
    }
    
    return self;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.composeComment;
}

@end
