//
//  SZCommentsListViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZCommentsListViewController.h"
#import "_SZCommentsListViewController.h"

@interface SZCommentsListViewController ()
@property (nonatomic, strong) _SZCommentsListViewController *commentsList;
@property (nonatomic, strong) id<SZEntity> entity;

@end

@implementation SZCommentsListViewController
@synthesize commentsList = _commentsList;
@synthesize entity = _entity;
@dynamic completionBlock;

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super init]) {
        self.entity = entity;
        self.commentsList = [[_SZCommentsListViewController alloc] initWithEntity:self.entity];
        [self pushViewController:self.commentsList animated:NO];
    }
    
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.commentsList;
}

@end
