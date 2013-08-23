//
//  SZComposeCommentViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZComposeCommentViewController.h"
#import "_SZComposeCommentViewController.h"
#import "SZCommentUtils.h"

@interface SZComposeCommentViewController ()
@property (nonatomic, strong) id<SZEntity> entity;

@end

@implementation SZComposeCommentViewController
@dynamic completionBlock;
@dynamic cancellationBlock;
@dynamic display;

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (SZCommentOptions*)optionsForComments {
    SZCommentOptions *commentOptions = self.commentOptions;

    if (commentOptions == nil) commentOptions = [SZCommentUtils userCommentOptions];
    
    return commentOptions;
}


- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super init]) {
        self.entity = entity;
        self._composeCommentViewController = [[_SZComposeCommentViewController alloc] initWithEntity:self.entity];
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
   
    SZCommentOptions *options = [self optionsForComments];
    
    if ([options.text length] > 0) {
        self._composeCommentViewController.initialText = options.text;
    }
    
    [self pushViewController:self._composeCommentViewController animated:NO];
}


- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self._composeCommentViewController;
}

@end
