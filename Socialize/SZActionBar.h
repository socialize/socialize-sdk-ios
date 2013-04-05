//
//  SZActionBar.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/15/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZLikeButton.h"
#import "SZShareOptions.h"
#import "SZLikeOptions.h"

@interface SZActionBar : UIView

+ (id)defaultActionBarWithFrame:(CGRect)frame entity:(id<SZEntity>)entity viewController:(UIViewController*)viewController;
- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity viewController:(UIViewController *)viewController;

- (void)refresh;

+ (CGFloat)defaultHeight;
+ (CGFloat)defaultBetweenButtonsPadding;

@property (nonatomic, strong) id<SZEntity> entity;
@property (nonatomic, strong) id<SZEntity> serverEntity;
@property (nonatomic, unsafe_unretained) UIViewController *viewController;
@property (nonatomic, strong) NSArray *itemsRight;
@property (nonatomic, strong) NSArray *itemsLeft;
@property (nonatomic, strong) UIView *testView;

// Visual customization
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) CGFloat betweenButtonsPadding;

@property (nonatomic, strong) SZShareOptions *shareOptions;
@property (nonatomic, strong) SZLikeOptions *likeOptions;

@end
