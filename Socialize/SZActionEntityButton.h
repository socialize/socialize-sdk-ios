//
//  SZActionEntityButton.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/24/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZActionButton.h"
#import "SZActionBarItem.h"

@interface SZActionEntityButton : SZActionButton <SZActionBarItem>
+ (SZActionEntityButton*)actionEntityButtonWithFrame:(CGRect)frame entity:(id<SZEntity>)entity entityConfiguration:(void(^)(SZActionEntityButton *button, id<SZEntity> entity))entityConfigurationBlock;
- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity;

@property (nonatomic, strong) id<SZEntity> entity;
@property (nonatomic, strong) id<SZEntity> serverEntity;
@property (nonatomic, copy) void(^entityConfigurationBlock)(SZActionEntityButton *button, id<SZEntity>entity);

@end
