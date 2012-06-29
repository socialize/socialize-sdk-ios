//
//  SZCommentsListViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZNavigationController.h"
#import "SocializeObjects.h"

@interface SZCommentsListViewController : SZNavigationController
- (id)initWithEntity:(id<SZEntity>)entity;
@property (nonatomic, copy) void (^completionBlock)();
@property (nonatomic, strong, readonly) id<SZEntity> entity;

@end
