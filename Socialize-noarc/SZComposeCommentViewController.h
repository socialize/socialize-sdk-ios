//
//  SZComposeCommentViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZNavigationController.h"
#import "SocializeObjects.h"

@interface SZComposeCommentViewController : SZNavigationController
- (id)initWithEntity:(id<SZEntity>)entity;

@property (nonatomic, retain) id<SZEntity> entity;
@property (nonatomic, copy) void (^successBlock)(id<SZComment> comment);
@property (nonatomic, copy) void (^cancellationBlock)();

@end
