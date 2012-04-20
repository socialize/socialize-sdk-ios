//
//  SocializeLikeButton.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/16/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Socialize.h"

@interface SocializeLikeButton : UIView <SocializeServiceDelegate>

@property (nonatomic, retain) UIButton *actualButton;

@property (nonatomic, readonly) BOOL liked;

@property (nonatomic, retain) UIImage *disabledImage;

@property (nonatomic, retain) UIImage *inactiveImage;
@property (nonatomic, retain) UIImage *inactiveHighlightedImage;

@property (nonatomic, retain) UIImage *activeImage;
@property (nonatomic, retain) UIImage *activeHighlightedImage;

@property (nonatomic, retain) UIImage *likedIcon;
@property (nonatomic, retain) UIImage *unlikedIcon;

@property (nonatomic, retain) id<SocializeUIDisplay> display;

@property (nonatomic, assign) BOOL hideCount;
@property (nonatomic, assign) BOOL autoresizeDisabled;

@property (nonatomic, retain) id<SocializeEntity> entity;

- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity display:(id<SocializeUIDisplay>)display;
- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity viewController:(UIViewController*)controller;
- (void)refresh;

@property (nonatomic, retain) Socialize *socialize;


@end
