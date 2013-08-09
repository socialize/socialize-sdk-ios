//
//  SZCommentsListViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZNavigationController.h"
#import "SocializeObjects.h"
#import "_SZCommentsListViewController.h"
#import "SZViewControllerWrapper.h"

@interface SZCommentsListViewController : SZViewControllerWrapper
- (id)initWithEntity:(id<SZEntity>)entity;
@property (nonatomic, copy) void (^completionBlock)();
@property (nonatomic, strong, readonly) id<SZEntity> entity;
@property (nonatomic, strong) _SZCommentsListViewController *_commentsListViewController;
@property (nonatomic, strong) SZCommentOptions* commentOptions;

@end
