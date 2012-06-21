//
//  SZLikeButton.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/16/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZLikeButton.h"
#import "SocializeUserService.h"
#import "SocializeEntityService.h"
#import "SocializeLikeService.h"
#import <BlocksKit/BlocksKit.h>
#import "NSNumber+Additions.h"
#import "SZEntityUtils.h"
#import "SDKHelpers.h"
#import "SZLikeUtils.h"

#define BUTTON_PADDINGS 4
#define PADDING_IN_BETWEEN_BUTTONS 10
#define PADDING_BETWEEN_TEXT_ICON 2

static NSTimeInterval SZLikeButtonRecoveryTimerInterval = 5.0;

typedef enum {
    SZLikeButtonInitStateInitNotStarted,
    SZLikeButtonInitStateRequestedEntityCreate,
    SZLikeButtonInitStateCompletedEntityCreate,
    SZLikeButtonInitStateCompleted,
} SZLikeButtonInitState;

@interface SZLikeButton ()

@property (nonatomic, assign) SZLikeButtonInitState initState;

@property (nonatomic, retain) id<SocializeEntity> serverEntity;
@property (nonatomic, retain) NSTimer *recoveryTimer;

@end

@implementation SZLikeButton
@synthesize actualButton = actualButton_;
@synthesize disabledImage = disabledImage_;
@synthesize inactiveImage = inactiveImage_;
@synthesize inactiveHighlightedImage = inactiveHighlightedImage_;
@synthesize activeImage = activeImage_;
@synthesize activeHighlightedImage = activeHighlightedImage_;
@synthesize likedIcon = likedIcon_;
@synthesize unlikedIcon = unlikedIcon_;
@synthesize viewController = viewController_;
@synthesize entity = entity_;
@synthesize recoveryTimer = recoveryTimer_;
@synthesize serverEntity = serverEntity_;

@synthesize initState = initState_;
@synthesize hideCount = hideCount_;
@synthesize autoresizeDisabled = autoresizeDisabled_;

- (void)dealloc {
    self.actualButton = nil;
    self.disabledImage = nil;
    self.inactiveImage = nil;
    self.inactiveHighlightedImage = nil;
    self.activeImage = nil;
    self.activeHighlightedImage = nil;
    self.likedIcon = nil;
    self.unlikedIcon = nil;
    self.viewController = nil;
    entity_ = nil; [entity_ release];
    self.serverEntity = nil;
    
    if (recoveryTimer_ != nil) {
        [recoveryTimer_ invalidate];
    }
    self.recoveryTimer = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity viewController:(UIViewController*)viewController {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureButtonBackgroundImages];

        NonatomicRetainedSetToFrom(entity_, entity);
        self.viewController = viewController;
        
        self.actualButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.actualButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)updateButtonTitle:(NSString*)title {
    [self.actualButton setTitle:title forState:UIControlStateNormal];
    [self resizeButton];
}

- (void)updateViewFromServerEntity:(id<SocializeEntity>)serverEntity {
    if (!self.hideCount) {
        NSString* formattedValue = [NSNumber formatMyNumber:[NSNumber numberWithInteger:serverEntity.likes] ceiling:[NSNumber numberWithInt:1000]]; 
        [self updateButtonTitle:formattedValue];
    }
}

- (UIImage*)currentIcon {
    if ([self liked]) {
        return self.likedIcon;
    } else {
        return self.unlikedIcon;
    }
}

- (void)setServerEntity:(id<SocializeEntity>)serverEntity {
    NonatomicRetainedSetToFrom(serverEntity_, serverEntity);
    [self updateViewFromServerEntity:self.serverEntity];
}

- (void)attemptRecovery {
    if (self.initState < SZLikeButtonInitStateCompleted) {
        [self tryToFinishInitializing];
    } else {
        [self stopRecoveryTimer];
    }
}

- (void)startRecoveryTimer {
    if (self.recoveryTimer == nil) {
        __block __typeof__(self) weakSelf = self;
        self.recoveryTimer = [NSTimer scheduledTimerWithTimeInterval:SZLikeButtonRecoveryTimerInterval
                                                               block:^(NSTimeInterval interval) {
                                                                   [weakSelf attemptRecovery];
                                                               } repeats:YES];
    }
}

- (void)stopRecoveryTimer {
    if (self.recoveryTimer != nil) {
        [self.recoveryTimer invalidate];
        self.recoveryTimer = nil;
    }
}

- (BOOL)isLiked {
    return SZEntityIsLiked(self.serverEntity);
}

- (BOOL)liked {
    return [self isLiked];
}

- (void)createEntityOnServer {
    [SZEntityUtils addEntity:self.entity success:^(id<SZEntity> entity) {
        self.serverEntity = entity;
        self.initState = SZLikeButtonInitStateCompletedEntityCreate;
        [self tryToFinishInitializing];
    } failure:^(NSError *error) {
        [self startRecoveryTimer];
    }];
}

- (BOOL)initialized {
    return self.initState == SZLikeButtonInitStateCompleted;
}

- (void)tryToFinishInitializing {
    if (self.initState == SZLikeButtonInitStateCompleted) {
        return;
    }
    
    if (self.entity == nil) {
        return;
    }
    
    if (self.initState < SZLikeButtonInitStateInitNotStarted) {
        [self createEntityOnServer];
        return;
    }
    
    if (self.initState < SZLikeButtonInitStateCompletedEntityCreate) {
        return;
    }

    self.initState = SZLikeButtonInitStateCompleted;
    
    [self configureButtonBackgroundImages];
    self.actualButton.enabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:SZLikeButtonDidChangeStateNotification object:self];
}

- (void)postErrorNotificationForError:(NSError*)error {
    NSDictionary *userInfo = nil;
    if (error != nil) {
        userInfo = [NSDictionary dictionaryWithObject:error forKey:SocializeUIControllerErrorUserInfoKey];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeUIControllerDidFailWithErrorNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)failWithError:(NSError*)error {
    SZEmitUIError(self, error);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.actualButton.enabled = NO;
    [self resizeButton];
    [self tryToFinishInitializing];
}

+ (UIImage*)defaultDisabledImage {
    return nil;
}

+ (UIImage*)defaultInactiveImage {
    return [[UIImage imageNamed:@"action-bar-button-black.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultInactiveHighlightedImage {
    return [[UIImage imageNamed:@"action-bar-button-black-hover.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultActiveImage {
    return [[UIImage imageNamed:@"action-bar-button-red.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultActiveHighlightedImage {
    return [[UIImage imageNamed:@"action-bar-button-red-hover.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

+ (UIImage*)defaultLikedIcon {
    return [UIImage imageNamed:@"action-bar-icon-liked.png"];
}

+ (UIImage*)defaultUnlikedIcon {
    return [UIImage imageNamed:@"action-bar-icon-like.png"];
}

- (void)setLikedIcon:(UIImage*)likedIcon {
    NonatomicRetainedSetToFrom(likedIcon_, likedIcon);
    [self configureButtonBackgroundImages];
}

- (UIImage*)likedIcon {
    if (likedIcon_ == nil) {
        likedIcon_ = [[[self class] defaultLikedIcon] retain];
    }
    
    return likedIcon_;
}

- (void)setUnlikedIcon:(UIImage*)unlikedIcon {
    NonatomicRetainedSetToFrom(unlikedIcon_, unlikedIcon);
    [self configureButtonBackgroundImages];
}

- (UIImage*)unlikedIcon {
    if (unlikedIcon_ == nil) {
        unlikedIcon_ = [[[self class] defaultUnlikedIcon] retain];
    }
    
    return unlikedIcon_;
}

- (UIImage*)disabledImage {
    if (disabledImage_ == nil) {
        disabledImage_ = [[[self class] defaultDisabledImage] retain];
    }
    
    return disabledImage_;
}

- (void)setDisabledImage:(UIImage *)disabledImage {
    NonatomicCopySetToFrom(disabledImage_, disabledImage);
    [self configureButtonBackgroundImages];
}

- (UIImage*)inactiveImage {
    if (inactiveImage_ == nil) {
        inactiveImage_ = [[[self class] defaultInactiveImage] retain];
    }
    
    return inactiveImage_;
}

- (void)setInactiveImage:(UIImage *)inactiveImage {
    NonatomicCopySetToFrom(inactiveImage_, inactiveImage);
    [self configureButtonBackgroundImages];
}

- (UIImage*)inactiveHighlightedImage {
    if (inactiveHighlightedImage_ == nil) {
        inactiveHighlightedImage_ = [[[self class] defaultInactiveHighlightedImage] retain];
    }
    
    return inactiveHighlightedImage_;
}

- (void)setInactiveHighlightedImage:(UIImage *)inactiveHighlightedImage {
    NonatomicCopySetToFrom(inactiveHighlightedImage_, inactiveHighlightedImage);
    [self configureButtonBackgroundImages];
}

- (UIImage*)activeImage {
    if (activeImage_ == nil) {
        activeImage_ = [[[self class] defaultActiveImage] retain];
    }
    
    return activeImage_;
}

- (void)setActiveImage:(UIImage *)activeImage {
    NonatomicCopySetToFrom(activeImage_, activeImage);
    [self configureButtonBackgroundImages];
}

- (UIImage*)activeHighlightedImage {
    if (activeHighlightedImage_ == nil) {
        activeHighlightedImage_ = [[[self class] defaultActiveHighlightedImage] retain];
    }
    
    return activeHighlightedImage_;
}

- (void)setActiveHighlightedImage:(UIImage *)activeHighlightedImage {
    NonatomicCopySetToFrom(activeHighlightedImage_, activeHighlightedImage);
    [self configureButtonBackgroundImages];
}

- (void)configureButtonBackgroundImages {
    [self.actualButton setBackgroundImage:self.disabledImage forState:UIControlStateDisabled];
    
    if (self.isLiked) {
        [self.actualButton setBackgroundImage:self.activeImage forState:UIControlStateNormal];
        [self.actualButton setBackgroundImage:self.activeHighlightedImage forState:UIControlStateHighlighted];
        [self.actualButton setImage:self.likedIcon forState:UIControlStateNormal];
    } else {
        [self.actualButton setBackgroundImage:self.inactiveImage forState:UIControlStateNormal];
        [self.actualButton setBackgroundImage:self.inactiveHighlightedImage forState:UIControlStateHighlighted];        
        [self.actualButton setImage:self.unlikedIcon forState:UIControlStateNormal];
    }
    
}

- (UIButton*)actualButton {
    if (actualButton_ == nil) {
        actualButton_ = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        actualButton_.accessibilityLabel = @"like button";
        actualButton_.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [actualButton_ addTarget:self action:@selector(actualButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [actualButton_.titleLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
        
        [actualButton_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        actualButton_.titleLabel.shadowColor = [UIColor blackColor]; 
        actualButton_.titleLabel.shadowOffset = CGSizeMake(0, -1); 
    }
    
    return actualButton_;
}

- (void)unlikeOnServer {
    self.actualButton.enabled = NO;
    
    [SZLikeUtils unlike:self.entity success:^(id<SZLike> like) {
        self.serverEntity = like.entity;
        self.actualButton.enabled = YES;
        [self configureButtonBackgroundImages];
        [[NSNotificationCenter defaultCenter] postNotificationName:SZLikeButtonDidChangeStateNotification object:self];
    } failure:^(NSError *error) {
        self.actualButton.enabled = YES;
        [self failWithError:error];
    }];
}

- (void)likeOnServer {
    self.actualButton.enabled = NO;

    [SZLikeUtils likeWithViewController:self.viewController options:nil entity:self.entity success:^(id<SZLike> like) {

        // Like succeeded
        self.actualButton.enabled = YES;
        self.serverEntity = like.entity;
        [self configureButtonBackgroundImages];
        [[NSNotificationCenter defaultCenter] postNotificationName:SZLikeButtonDidChangeStateNotification object:self];
        
    } failure:^(NSError *error) {
        
        // Like failed
        self.actualButton.enabled = YES;
        [self failWithError:error];
    }];
}

- (void)toggleLikeState {
    if (self.isLiked) {
        [self unlikeOnServer];
    } else {
        [self likeOnServer];
    }
}

- (void)actualButtonPressed:(UIButton*)button {
    [self toggleLikeState];
}

- (void)setEntity:(id<SocializeEntity>)entity {
    NonatomicRetainedSetToFrom(entity_, entity);
    
    // This is the user-set entity property. The server entity is always stored in self.serverEntity
    [self refresh];
}

- (void)refresh {
    self.initState = SZLikeButtonInitStateInitNotStarted;
    self.serverEntity = nil;
    self.actualButton.enabled = NO;
    
    [self tryToFinishInitializing];
}

- (CGSize)currentButtonSize {
    NSString *currentTitle = [self.actualButton titleForState:UIControlStateNormal];
	CGSize titleSize = [currentTitle sizeWithFont:self.actualButton.titleLabel.font];
    CGSize iconSize = [[self currentIcon] size];
    
    UIImage *currentBackground = [self.actualButton backgroundImageForState:UIControlStateNormal];
    CGSize backgroundSize = [currentBackground size];
    
    CGSize buttonSize = CGSizeMake(titleSize.width + (2 * BUTTON_PADDINGS) + PADDING_BETWEEN_TEXT_ICON + 5 + iconSize.width, backgroundSize.height);
	
	return buttonSize;
}

- (void)resizeButton {
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
