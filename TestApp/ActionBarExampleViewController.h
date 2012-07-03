//
//  ActionBarExampleViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/15/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Socialize/Socialize.h>

@interface ActionBarExampleViewController : UIViewController
- (id)initWithEntity:(id<SZEntity>)entity;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
@property (nonatomic, strong) SocializeActionBar *oldActionBar;
#pragma GCC diagnostic pop
@property (nonatomic, strong) SZActionBar *actionBar;
@property (nonatomic, strong) id<SZEntity> entity;
@end
