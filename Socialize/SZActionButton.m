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
#import "SZActionBar.h"
#import "NSNumber+Additions.h"
#import "SZCommentUtils.h"
#import "SZShareUtils.h"
#import "SZUserUtils.h"
#import "UIDevice+VersionCheck.h"
#import "SZActionButtonIOS6.h"
#import "UIColor+Socialize.h"

#define PADDING_BETWEEN_TEXT_ICON 2
#define BUTTON_PADDINGS 4
#define DEFAULT_BUTTON_HEIGHT 30

@implementation SZActionButton

@synthesize actualButton = actualButton_;
@synthesize disabledImage = disabledImage_;
@synthesize icon = _icon;
@synthesize autoresizeDisabled = autoresizeDisabled_;
@synthesize image = _image;
@synthesize highlightedImage = _highlightedImage;
@synthesize actionBlock = _actionBlock;
@synthesize title = _title;
@synthesize entity = _entity;
@synthesize entityConfigurationBlock = _entityConfigurationBlock;
@synthesize actionBar = _actionBar;


+ (id)alloc {
    if([self class] == [SZActionButton class] &&
       [[UIDevice currentDevice] systemMajorVersion] < 7) {
        return [SZActionButtonIOS6 alloc];
    }
    else {
        return [super alloc];
    }
}

+ (SZActionButton*)actionButtonWithIcon:(UIImage*)icon title:(NSString*)title {
    SZActionButton *actionButton = [[SZActionButton alloc] initWithFrame:CGRectZero];
    actionButton.icon = icon;
    actionButton.title = title;
    
    return actionButton;
}

+ (SZActionButton*)commentButton {
    SZActionButton *commentButton = [self actionButtonWithIcon:[UIImage imageNamed:@"action-bar-icon-comments.png"] title:nil];
    commentButton.actualButton.accessibilityLabel = @"comment button";
    commentButton.entityConfigurationBlock = ^(SZActionButton *button, SZActionBar *actionBar, id<SZEntity> entity) {
        NSString* formattedValue = [NSNumber formatMyNumber:[NSNumber numberWithInteger:entity.comments] ceiling:[NSNumber numberWithInt:1000]]; 
        [button setTitle:formattedValue];
    };
    
    commentButton.actionBlock = ^(SZActionButton *button, SZActionBar *bar) {
        [SZCommentUtils showCommentsListWithViewController:bar.viewController entity:bar.entity completion:nil];        
    };
    
    return commentButton;
}

+ (SZActionButton*)shareButton {
    SZActionButton *shareButton = [SZActionButton actionButtonWithIcon:[UIImage imageNamed:@"action-bar-icon-share.png"] title:@"Share"];
    shareButton.actionBlock = ^(SZActionButton *button, SZActionBar *bar) {
        [SZShareUtils showShareDialogWithViewController:bar.viewController options:bar.shareOptions entity:bar.entity completion:nil cancellation:nil];
    };
    shareButton.actualButton.accessibilityLabel = @"share button";
    
    return shareButton;
}

+ (SZActionButton*)viewsButton {
    SZActionButton *viewsButton = [SZActionButton actionButtonWithIcon:[UIImage imageNamed:@"action-bar-icon-views.png"] title:nil];
    
    viewsButton.entityConfigurationBlock = ^(SZActionButton *button, SZActionBar *actionBar, id<SZEntity> entity) {

        NSString* formattedValue = [NSNumber formatMyNumber:[NSNumber numberWithInteger:entity.views] ceiling:[NSNumber numberWithInt:1000]]; 
        [button setTitle:formattedValue];
    };
    
    viewsButton.image = nil;
    viewsButton.highlightedImage = nil;
    viewsButton.actionBlock = ^(SZActionButton *button, SZActionBar *bar) {
        [SZUserUtils showUserSettingsInViewController:bar.viewController completion:nil];
    };
    viewsButton.actualButton.accessibilityLabel = @"views button";
    
    return viewsButton;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.actualButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self resetButtonsToDefaults];
        [self addSubview:self.actualButton];
        
        [self autoresize];
    }
    return self;
}

- (void)resetButtonsToDefaults {
    self.image = [[self class] defaultImage];
    self.highlightedImage = [[self class] defaultHighlightedImage];
    self.disabledImage = [[self class] defaultDisabledImage];
    [self.actualButton setTitleColor:[UIColor buttonTextHighlightColor] forState:UIControlStateHighlighted];
    [self configureButtonBackgroundImages];
}

+ (UIImage*)defaultDisabledImage {
    return nil;
}

+ (UIImage*)defaultImage {
    return nil;
}

+ (UIImage*)defaultHighlightedImage {
    return nil;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self configureButtonBackgroundImages];
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
    
    CGFloat height;
    UIImage *currentBackground = [self.actualButton backgroundImageForState:UIControlStateNormal];
    if (currentBackground != nil) {
        CGSize backgroundSize = [currentBackground size];
        height = backgroundSize.height;
    } else {
        height = DEFAULT_BUTTON_HEIGHT;
    }
    
    CGSize buttonSize = CGSizeMake(titleSize.width + (2 * BUTTON_PADDINGS) + PADDING_BETWEEN_TEXT_ICON + 5 + iconSize.width, height);
	
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
        actualButton_.titleLabel.shadowOffset = CGSizeMake(0, 0); 
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

- (void)handleButtonPress:(id)sender {
}

- (void)actualButtonPressed:(UIButton*)button {
    if (self.actionBlock != nil) {
        self.actionBlock(self, self.actionBar);
    } else {
        [self handleButtonPress:button];
    }
}

- (void)setTitle:(NSString*)title {
    _title = title;
    [self.actualButton setTitle:title forState:UIControlStateNormal];
    [self autoresize];
}

- (void)autoresize {
    if (!self.autoresizeDisabled) {
        CGRect bounds = self.bounds;
        CGSize currentSize = [self currentButtonSize];
        CGRect newBounds = CGRectMake(bounds.origin.x, bounds.origin.y, currentSize.width, currentSize.height);
        self.bounds = newBounds;
        
        NSString *currentTitle = [self.actualButton titleForState:UIControlStateNormal];
        if ([currentTitle length] == 0) {
            [actualButton_ setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
            
        } else {
            [actualButton_ setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
            [actualButton_ setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -PADDING_BETWEEN_TEXT_ICON)]; // Left inset is the negative of image width.
        }
    }
}

- (void)actionBar:(SZActionBar*)actionBar didLoadEntity:(id<SocializeEntity>)entity {
    self.entity = entity;
    
    if (self.entityConfigurationBlock != nil) {
        self.entityConfigurationBlock(self, self.actionBar, entity);
    }
    
    [self configureButtonBackgroundImages];
    [self autoresize];
    
}

- (void)actionBarDidAddAsItem:(SZActionBar*)actionBar {
    self.actionBar = actionBar;
}


@end
