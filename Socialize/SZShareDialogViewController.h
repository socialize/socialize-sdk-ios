//
//  SZShareDialogViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZNavigationController.h"
#import "SocializeObjects.h"

@interface SZShareDialogViewController : SZNavigationController
- (id)initWithEntity:(id<SZEntity>)entity;
@property (nonatomic, retain) NSArray *shares;
@property (nonatomic, copy) void (^completionBlock)(NSArray *shares);
@property (nonatomic, copy) void (^cancellationBlock)();
@property (nonatomic, strong) id<SZEntity> entity;
@end
