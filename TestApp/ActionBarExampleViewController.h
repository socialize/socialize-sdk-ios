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

@property (nonatomic, strong) SocializeActionBar *oldActionBar;
@property (nonatomic, strong) SZActionBar *actionBar;
@property (nonatomic, strong) id<SZEntity> entity;
@end
