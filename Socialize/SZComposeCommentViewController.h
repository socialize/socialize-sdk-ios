//
//  SZComposeCommentViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZNavigationController.h"
#import "SocializeObjects.h"

@interface SZComposeCommentViewController : SZNavigationController
@property (nonatomic, strong) _SZComposeCommentViewController *composeComment;
- (id)initWithEntity:(id<SZEntity>)entity;
@property (nonatomic, copy) void (^completionBlock)(id<SZComment> comment);
@property (nonatomic, copy) void (^cancellationBlock)();
@property (nonatomic, strong, readonly) id<SZEntity> entity;
@end
