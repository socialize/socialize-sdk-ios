//
//  SZCommentButton.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/23/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZActionButton.h"
#import "SZActionBarItem.h"

@interface SZCommentButton : SZActionButton <SZActionBarItem>
- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity viewController:(UIViewController*)viewController;

@property (nonatomic, strong) id<SZEntity> entity;
@property (nonatomic, strong) id<SZEntity> serverEntity;
@property (nonatomic, strong) UIViewController *viewController;

@end
