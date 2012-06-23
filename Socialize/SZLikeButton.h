//
//  SZLikeButton.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/16/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeObjects.h"

@interface SZLikeButton : UIView

@property (nonatomic, readonly) BOOL initialized;

@property (nonatomic, strong) UIButton *actualButton;

@property (nonatomic, readonly) BOOL liked;
@property (nonatomic, readonly) BOOL isLiked;

// begin-image-properties

@property (nonatomic, strong) UIImage *disabledImage;

@property (nonatomic, strong) UIImage *inactiveImage;
@property (nonatomic, strong) UIImage *inactiveHighlightedImage;

@property (nonatomic, strong) UIImage *activeImage;
@property (nonatomic, strong) UIImage *activeHighlightedImage;

@property (nonatomic, strong) UIImage *likedIcon;
@property (nonatomic, strong) UIImage *unlikedIcon;

// end-image-properties

@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, assign) BOOL hideCount;
@property (nonatomic, assign) BOOL autoresizeDisabled;

@property (nonatomic, strong) id<SocializeEntity> entity;

- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity viewController:(UIViewController*)controller;
- (void)refresh;
- (void)autoresize;


@end
