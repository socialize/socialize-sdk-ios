//
//  SZActionButton.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/23/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZActionButton.h"
#import "SZActionButton_Private.h"
#import "SZEntityUtils.h"

#define PADDING_BETWEEN_TEXT_ICON 2
#define BUTTON_PADDINGS 4

@implementation SZActionButton
@synthesize failureRetryInterval = _failureRetryInterval;
@synthesize actualButton = actualButton_;
@synthesize disabledImage = disabledImage_;
@synthesize icon = _icon;
@synthesize autoresizeDisabled = autoresizeDisabled_;
@synthesize image = _image;
@synthesize highlightedImage = _highlightedImage;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.actualButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.actualButton];

        [self autoresize];
    }
    return self;
}

+ (NSTimeInterval)defaultFailureRetryInterval {
    return 10;
}

+ (UIImage*)defaultDisabledImage {
    return nil;
}

- (UIImage*)disabledImage {
    if (disabledImage_ == nil) {
        disabledImage_ = [[self class] defaultDisabledImage];
    }
    
    return disabledImage_;
}

+ (UIImage*)defaultImage {
    return [[UIImage imageNamed:@"action-bar-button-black.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultHighlightedImage {
    return [[UIImage imageNamed:@"action-bar-button-black-hover.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

- (UIImage*)image {
    if (_image == nil) {
        _image = [[self class] defaultImage];
    }
    
    return _image;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self configureButtonBackgroundImages];
}

- (UIImage*)highlightedImage {
    if (_highlightedImage == nil) {
        _highlightedImage = [[self class] defaultHighlightedImage];
    }
    
    return _highlightedImage;
}

- (void)highlightedImage:(UIImage *)highlightedImage {
    _highlightedImage = highlightedImage;
    [self configureButtonBackgroundImages];
}

- (void)setIcon:(UIImage*)icon {
    _icon = icon;
    [self configureButtonBackgroundImages];
}

- (void)setDisabledImage:(UIImage *)disabledImage {
    disabledImage_ = disabledImage;
}

- (CGSize)currentButtonSize {
    NSString *currentTitle = [self.actualButton titleForState:UIControlStateNormal];
	CGSize titleSize = [currentTitle sizeWithFont:self.actualButton.titleLabel.font];
    CGSize iconSize = [[self icon] size];
    
    UIImage *currentBackground = [self.actualButton backgroundImageForState:UIControlStateNormal];
    CGSize backgroundSize = [currentBackground size];
    
    CGSize buttonSize = CGSizeMake(titleSize.width + (2 * BUTTON_PADDINGS) + PADDING_BETWEEN_TEXT_ICON + 5 + iconSize.width, backgroundSize.height);
	
	return buttonSize;
}

- (UIButton*)actualButton {
    if (actualButton_ == nil) {
        actualButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
        actualButton_.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [actualButton_ addTarget:self action:@selector(actualButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [actualButton_.titleLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
        
        [actualButton_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        actualButton_.titleLabel.shadowColor = [UIColor blackColor]; 
        actualButton_.titleLabel.shadowOffset = CGSizeMake(0, -1); 
    }
    
    return actualButton_;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self autoresize];
}

- (void)configureButtonBackgroundImages {
    [self.actualButton setBackgroundImage:self.disabledImage forState:UIControlStateDisabled];
    
    [self.actualButton setBackgroundImage:self.image forState:UIControlStateNormal];
    [self.actualButton setBackgroundImage:self.highlightedImage forState:UIControlStateHighlighted];
    [self.actualButton setImage:self.icon forState:UIControlStateNormal];
}

- (void)actualButtonPressed:(UIButton*)button {
}

- (void)setTitle:(NSString*)title {
    [self.actualButton setTitle:title forState:UIControlStateNormal];
    [self autoresize];
}

- (void)autoresize {
    if (!self.autoresizeDisabled) {
        CGRect frame = self.frame;
        CGSize currentSize = [self currentButtonSize];
        CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, currentSize.width, currentSize.height);
        self.frame = newFrame;
        
        NSString *currentTitle = [self.actualButton titleForState:UIControlStateNormal];
        if ([currentTitle length] == 0) {
            [actualButton_ setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
            
        } else {
            [actualButton_ setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
            [actualButton_ setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -PADDING_BETWEEN_TEXT_ICON)]; // Left inset is the negative of image width.
        }
    }
}

@end
