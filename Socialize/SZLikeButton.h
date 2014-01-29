//
//  SZLikeButton.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/16/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeObjects.h"
#import "SZActionButton.h"
#import "SZActionBarItem.h"
#import "SZLikeOptions.h"

@interface SZLikeButton : SZActionButton <SZActionBarItem>

- (id)initWithFrame:(CGRect)frame
             entity:(id<SocializeEntity>)entity
     viewController:(UIViewController*)controller
        tabBarStyle:(BOOL)buttonStyle;
- (void)refresh;

@property (nonatomic, readonly) BOOL initialized;
@property (nonatomic, readonly, getter=isLiked) BOOL liked;
@property (nonatomic, getter=isTabBarStyle) BOOL tabBarStyle;

// begin-image-properties

@property (nonatomic, strong) UIImage *inactiveImage;
@property (nonatomic, strong) UIImage *inactiveHighlightedImage;

@property (nonatomic, strong) UIImage *activeImage;
@property (nonatomic, strong) UIImage *activeHighlightedImage;

@property (nonatomic, strong) UIImage *likedIcon;
@property (nonatomic, strong) UIImage *unlikedIcon;

// end-image-properties

@property (nonatomic, unsafe_unretained) UIViewController *viewController;
@property (nonatomic, assign) BOOL hideCount;
@property (nonatomic, retain) id<SZEntity> entity;
@property (nonatomic, assign) NSTimeInterval failureRetryInterval;
@property (nonatomic, strong) SZLikeOptions *likeOptions;

+ (UIImage *)defaultDisabledImage;
+ (UIImage *)defaultInactiveImage;
+ (UIImage *)defaultInactiveHighlightedImage;
+ (UIImage *)defaultNonTabBarInactiveImage;
+ (UIImage *)defaultNonTabBarInactiveHighlightedImage;
+ (UIImage *)defaultActiveImage;
+ (UIImage *)defaultActiveHighlightedImage;
+ (UIImage *)defaultLikedIcon;
+ (UIImage *)defaultUnlikedIcon;

+ (NSTimeInterval)defaultFailureRetryInterval;

@end
