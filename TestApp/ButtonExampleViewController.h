//
//  ButtonExampleViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/24/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Socialize/Socialize.h>

@interface ButtonExampleViewController : UIViewController
- (id)initWithEntity:(id<SZEntity>)entity;
@property (nonatomic, strong) id<SZEntity> entity;

@property (nonatomic, strong) SZLikeButton *likeButton;

@end
