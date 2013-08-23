//
//  SZComposeCommentViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZNavigationController.h"
#import "SocializeObjects.h"
#import "SZDisplay.h"
#import "SZViewControllerWrapper.h"

@class SZCommentOptions;

@interface SZComposeCommentViewController : SZViewControllerWrapper
@property (nonatomic, strong) _SZComposeCommentViewController *_composeCommentViewController;
- (id)initWithEntity:(id<SZEntity>)entity;
@property (nonatomic, copy) void (^completionBlock)(id<SZComment> comment);
@property (nonatomic, copy) void (^cancellationBlock)();
@property (nonatomic, strong, readonly) id<SZEntity> entity;
@property (nonatomic, strong) id<SZDisplay> display;
@property (nonatomic, strong) SZCommentOptions* commentOptions;

@end
