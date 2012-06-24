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

static NSTimeInterval SZLikeButtonRecoveryTimerInterval = 5.0;

typedef enum {
    SZLikeButtonInitStateInitNotStarted,
    SZLikeButtonInitStateRequestedEntityCreate,
    SZLikeButtonInitStateCompletedEntityCreate,
    SZLikeButtonInitStateCompleted,
} SZLikeButtonInitState;

@interface SZLikeButton ()

@property (nonatomic, assign) SZLikeButtonInitState initState;

@property (nonatomic, strong) id<SocializeEntity> serverEntity;
@property (nonatomic, strong) NSTimer *recoveryTimer;
@property (nonatomic, getter=isLiked) BOOL liked;

@end

@implementation SZLikeButton
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
@synthesize liked = liked_;

@synthesize initState = initState_;
@synthesize hideCount = hideCount_;

- (void)dealloc {
    if (recoveryTimer_ != nil) {
        [recoveryTimer_ invalidate];
    }
}

- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity viewController:(UIViewController*)viewController {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureButtonBackgroundImages];

        entity_ = entity;
        self.viewController = viewController;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)updateButtonTitle:(NSString*)title {
    [self.actualButton setTitle:title forState:UIControlStateNormal];
    [self autoresize];
}

- (void)updateViewFromServerEntity:(id<SocializeEntity>)serverEntity {
    if (!self.hideCount) {
        NSString* formattedValue = [NSNumber formatMyNumber:[NSNumber numberWithInteger:serverEntity.likes] ceiling:[NSNumber numberWithInt:1000]]; 
        [self updateButtonTitle:formattedValue];
    }
}

- (UIImage*)icon {
    if (self.isLiked) {
        return self.likedIcon;
    } else {
        return self.unlikedIcon;
    }
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

- (void)createEntityOnServer {
    [SZEntityUtils addEntity:self.entity success:^(id<SZEntity> entity) {
        [self configureForNewServerEntity:entity];
        self.initState = SZLikeButtonInitStateCompletedEntityCreate;
        [self tryToFinishInitializing];
    } failure:^(NSError *error) {
        self.initState = SZLikeButtonInitStateInitNotStarted;
        [self startRecoveryTimer];
    }];
}

- (BOOL)initialized {
    return self.initState == SZLikeButtonInitStateCompleted;
}

- (void)tryToFinishInitializing {
    if ([self initialized]) {
        return;
    }

    if (self.entity == nil) {
        return;
    }
    
    if (self.initState < SZLikeButtonInitStateRequestedEntityCreate) {
        if ([self.entity isFromServer]) {
            
            // Already a server entity -- set state and continue
            [self configureForNewServerEntity:self.entity];
            self.initState = SZLikeButtonInitStateCompletedEntityCreate;

        } else {
            
            // Not a server entity - go fetch it
            self.initState = SZLikeButtonInitStateRequestedEntityCreate;
            [self createEntityOnServer];
            return;
        }
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
    [self autoresize];
    
    if (![self initialized]) {
        self.actualButton.enabled = NO;
        [self tryToFinishInitializing];
    }
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
    likedIcon_ = likedIcon;
    [self configureButtonBackgroundImages];
}

- (UIImage*)likedIcon {
    if (likedIcon_ == nil) {
        likedIcon_ = [[self class] defaultLikedIcon];
    }
    
    return likedIcon_;
}

- (void)setUnlikedIcon:(UIImage*)unlikedIcon {
    unlikedIcon_ = unlikedIcon;
    [self configureButtonBackgroundImages];
}

- (UIImage*)unlikedIcon {
    if (unlikedIcon_ == nil) {
        unlikedIcon_ = [[self class] defaultUnlikedIcon];
    }
    
    return unlikedIcon_;
}

- (UIImage*)inactiveImage {
    if (inactiveImage_ == nil) {
        inactiveImage_ = [[self class] defaultInactiveImage];
    }
    
    return inactiveImage_;
}

- (void)setInactiveImage:(UIImage *)inactiveImage {
    inactiveImage_ = inactiveImage;
    [self configureButtonBackgroundImages];
}

- (UIImage*)inactiveHighlightedImage {
    if (inactiveHighlightedImage_ == nil) {
        inactiveHighlightedImage_ = [[self class] defaultInactiveHighlightedImage];
    }
    
    return inactiveHighlightedImage_;
}

- (void)setInactiveHighlightedImage:(UIImage *)inactiveHighlightedImage {
    inactiveHighlightedImage_ = inactiveHighlightedImage;
    [self configureButtonBackgroundImages];
}

- (UIImage*)activeImage {
    if (activeImage_ == nil) {
        activeImage_ = [[self class] defaultActiveImage];
    }
    
    return activeImage_;
}

- (void)setActiveImage:(UIImage *)activeImage {
    activeImage_ = activeImage;
    [self configureButtonBackgroundImages];
}

- (UIImage*)activeHighlightedImage {
    if (activeHighlightedImage_ == nil) {
        activeHighlightedImage_ = [[self class] defaultActiveHighlightedImage];
    }
    
    return activeHighlightedImage_;
}

- (void)setActiveHighlightedImage:(UIImage *)activeHighlightedImage {
    activeHighlightedImage_ = activeHighlightedImage;
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

- (void)unlikeOnServer {
    self.actualButton.enabled = NO;
    
    [SZLikeUtils unlike:self.entity success:^(id<SZLike> like) {
        self.liked = NO;
        [self configureForNewServerEntity:like.entity];
        self.actualButton.enabled = YES;
        [self configureButtonBackgroundImages];
        [[NSNotificationCenter defaultCenter] postNotificationName:SZLikeButtonDidChangeStateNotification object:self];
    } failure:^(NSError *error) {
        self.actualButton.enabled = YES;
        [self failWithError:error];
    }];
}

- (void)configureForNewServerEntity:(id<SZEntity>)entity {
    NSAssert([entity isFromServer], @"Not a server entity");
    self.serverEntity = entity;
    [self configureButtonBackgroundImages];
    [self updateViewFromServerEntity:self.serverEntity];
    
    if ([entity userActionSummary] != nil) {
        self.liked = SZEntityIsLiked(entity);
    }
}

- (void)likeOnServer {
    self.actualButton.enabled = NO;

    [SZLikeUtils likeWithViewController:self.viewController options:nil entity:self.entity success:^(id<SZLike> like) {

        // Like succeeded
        self.liked = YES;
        self.actualButton.enabled = YES;
        [self configureForNewServerEntity:like.entity];
        [[NSNotificationCenter defaultCenter] postNotificationName:SZLikeButtonDidChangeStateNotification object:self];
        
    } failure:^(NSError *error) {
        
        // Like failed
        self.actualButton.enabled = YES;
        
        if (![error isSocializeErrorWithCode:SocializeErrorLikeCancelledByUser]) {
            [self failWithError:error];
        }
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
    entity_ = entity;
    
    // This is the user-set entity property. The server entity is always stored in self.serverEntity
    [self refresh];
}

- (void)refresh {
    self.initState = SZLikeButtonInitStateInitNotStarted;
    self.serverEntity = nil;
    self.actualButton.enabled = NO;
    self.liked = NO;
    
    [self tryToFinishInitializing];
}

@end
