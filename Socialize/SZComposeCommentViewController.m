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

@end

@implementation SZComposeCommentViewController
@synthesize composeComment = _composeComment;
@dynamic completionBlock;
@dynamic cancellationBlock;

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super init]) {
        self.composeComment = [[_SZComposeCommentViewController alloc] init];
        [self pushViewController:self.composeComment animated:NO];
    }
    
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.composeComment;
}

@end
