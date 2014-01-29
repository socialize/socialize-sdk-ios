//
//  SZActionButton.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/23/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZActionBarItem.h"

@class SZActionBar;

@interface SZActionButton : UIView <SZActionBarItem>

@property (nonatomic, strong) UIButton *actualButton;

@property (nonatomic, strong) UIImage *disabledImage;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, strong) UIImage *icon;

@property (nonatomic, assign) BOOL autoresizeDisabled;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) id<SZEntity> entity;
@property (nonatomic, unsafe_unretained) SZActionBar *actionBar;
@property (nonatomic, copy) void(^entityConfigurationBlock)(SZActionButton *actionButton, SZActionBar *actionBar, id<SZEntity>newEntity);
@property (nonatomic, copy) void(^actionBlock)(SZActionButton *actionButton, SZActionBar *actionBar);


+ (SZActionButton*)actionButtonWithIcon:(UIImage*)icon title:(NSString*)title;

// Some default buttons
+ (SZActionButton*)commentButton;
+ (SZActionButton*)shareButton;
+ (SZActionButton*)viewsButton;

- (void)autoresize;
- (void)resetButtonsToDefaults;

+ (UIImage*)defaultDisabledImage;
+ (UIImage*)defaultImage;
+ (UIImage*)defaultHighlightedImage;

@end
