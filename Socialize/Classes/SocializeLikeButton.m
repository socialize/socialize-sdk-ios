//
//  SocializeLikeButton.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/16/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeLikeButton.h"
#import "SocializeUserService.h"
#import "SocializeEntityService.h"
#import "SocializeLikeService.h"
#import "NSTimer+BlocksKit.h"
#import "SocializeUILikeCreator.h"
#import "NSNumber+Additions.h"

static NSTimeInterval SocializeLikeButtonRecoveryTimerInterval = 5.0;

@interface SocializeLikeButton ()

@property (nonatomic, assign) SocializeRequestState likeGetRequestState;
@property (nonatomic, assign) SocializeRequestState entityCreateRequestState;
@property (nonatomic, assign) SocializeRequestState likeCreateRequestState;
@property (nonatomic, assign) SocializeRequestState likeDeleteRequestState;

@property (nonatomic, retain) id<SocializeLike> like;
@property (nonatomic, retain) NSTimer *recoveryTimer;
@property (nonatomic, retain) id<SocializeEntity> serverEntity;


@end

@implementation SocializeLikeButton
@synthesize actualButton = actualButton_;
@synthesize disabledImage = disabledImage_;
@synthesize inactiveImage = inactiveImage_;
@synthesize inactiveHighlightedImage = inactiveHighlightedImage_;
@synthesize activeImage = activeImage_;
@synthesize activeHighlightedImage = activeHighlightedImage_;
@synthesize likedIcon = likedIcon_;
@synthesize unlikedIcon = unlikedIcon_;
@synthesize display = display_;
@synthesize entity = entity_;
@synthesize socialize = socialize_;
@synthesize like = like_;
@synthesize recoveryTimer = recoveryTimer_;
@synthesize serverEntity = serverEntity_;

@synthesize initialized = initialized_;
@synthesize hideCount = hideCount_;

@synthesize likeGetRequestState = likeGetRequestState_;
@synthesize likeCreateRequestState = likeCreateRequestState_;
@synthesize likeDeleteRequestState = likeDeleteRequestState_;
@synthesize entityCreateRequestState = entityCreateRequestState_;

- (void)dealloc {
    self.actualButton = nil;
    self.disabledImage = nil;
    self.inactiveImage = nil;
    self.inactiveHighlightedImage = nil;
    self.activeImage = nil;
    self.activeHighlightedImage = nil;
    self.likedIcon = nil;
    self.unlikedIcon = nil;
    self.display = nil;
    entity_ = nil; [entity_ release];
    self.serverEntity = nil;
    self.like = nil;
    
    if (recoveryTimer_ != nil) {
        [recoveryTimer_ invalidate];
    }
    self.recoveryTimer = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity display:(id<SocializeUIDisplay>)display {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureButtonBackgroundImages];

        NonatomicRetainedSetToFrom(entity_, entity);
        self.display = display;
        
        self.actualButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.actualButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity viewController:(UIViewController*)controller {
    return [self initWithFrame:frame entity:entity display:(id<SocializeUIDisplay>)controller];
}


- (id)initWithFrame:(CGRect)frame {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)updateViewFromServerEntity:(id<SocializeEntity>)serverEntity {
    if (!self.hideCount) {
        NSString* formattedValue = [NSNumber formatMyNumber:[NSNumber numberWithInteger:serverEntity.likes] ceiling:[NSNumber numberWithInt:1000]]; 
        [self.actualButton setTitle:formattedValue forState:UIControlStateNormal];
    }
}

- (void)setServerEntity:(id<SocializeEntity>)serverEntity {
    NonatomicRetainedSetToFrom(serverEntity_, serverEntity);
    [self updateViewFromServerEntity:self.serverEntity];
}

- (void)attemptRecovery {
    if (!self.initialized) {
        [self tryToFinishInitializing];
    } else if (self.likeCreateRequestState == SocializeRequestStateFailed) {
        [self likeOnServer];
    } else if (self.likeDeleteRequestState == SocializeRequestStateFailed) {
        [self unlikeOnServer];
    } else {
        [self stopRecoveryTimer];
    }
}

- (void)startRecoveryTimer {
    if (self.recoveryTimer == nil) {
        __block __typeof__(self) weakSelf = self;
        self.recoveryTimer = [NSTimer scheduledTimerWithTimeInterval:SocializeLikeButtonRecoveryTimerInterval
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

- (BOOL)liked {
    return self.like != nil;
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    return socialize_;
}

- (void)getLikeFromServer {
    self.likeGetRequestState = SocializeRequestStateSent;
    [self.socialize getLikesForUser:[self.socialize authenticatedUser] entity:self.entity first:nil last:[NSNumber numberWithInteger:1]];
}

- (void)createEntityOnServer {
    self.entityCreateRequestState = SocializeRequestStateSent;
    [self.socialize createEntity:self.entity];
}

- (void)tryToFinishInitializing {
    if (self.initialized) {
        return;
    }
    
    if (self.entity == nil) {
        return;
    }
    
    if (self.likeGetRequestState <= SocializeRequestStateNotStarted) {
        [self getLikeFromServer];
        return;
    } else if (self.likeGetRequestState < SocializeRequestStateFinished) {
        // Still waiting for response
        return;
    }
    
    if (self.like == nil) {
        // Could not fetch an existing like from server -- we need to get the entity
        
        if (self.entityCreateRequestState <= SocializeRequestStateNotStarted) {
            // We know the entity is not liked. Just make sure the entity exists.
            [self createEntityOnServer];
            return;
        } else if (self.entityCreateRequestState < SocializeRequestStateFinished) {
            // Still waiting for entity -- initialization not complete
            return;
        }
    } 

    [self stopRecoveryTimer];
    self.initialized = YES;
    [self configureButtonBackgroundImages];
    self.actualButton.enabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeLikeButtonDidChangeStateNotification object:self];
}

- (void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray {
    if ([service isKindOfClass:[SocializeUserService class]]) {
        // Get likes for user
        if ([dataArray count] > 0) {
            self.like = [dataArray objectAtIndex:0];
            self.serverEntity = self.like.entity;
        } else {
            // the like did not exist, which is ok. Continue on, anyway
        }
        
        self.likeGetRequestState = SocializeRequestStateFinished;
        [self tryToFinishInitializing];
        
    }
}

- (void)service:(SocializeService *)service didCreate:(id)objectOrObjects {
    if ([service isKindOfClass:[SocializeEntityService class]]) {
        
        // Finished creating entity (initialization)
        self.serverEntity = objectOrObjects;
        self.entityCreateRequestState = SocializeRequestStateFinished;
        [self tryToFinishInitializing];
    }
}

- (void)service:(SocializeService *)service didDelete:(id<SocializeObject>)object {
    if ([service isKindOfClass:[SocializeLikeService class]]) {
        id<SocializeLike> serverLike = (id<SocializeLike>)object;
        self.serverEntity = serverLike.entity;
        
        self.likeDeleteRequestState = SocializeRequestStateFinished;
        self.like = nil;
        self.actualButton.enabled = YES;
        [self configureButtonBackgroundImages];
        [[NSNotificationCenter defaultCenter] postNotificationName:SocializeLikeButtonDidChangeStateNotification object:self];
    }
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    if ([service isKindOfClass:[SocializeUserService class]]) {
        self.likeGetRequestState = SocializeRequestStateFailed;
    } else if ([service isKindOfClass:[SocializeEntityService class]]) {
        self.entityCreateRequestState = SocializeRequestStateFailed;
    } else if ([service isKindOfClass:[SocializeLikeService class]]) {
        if (self.likeDeleteRequestState == SocializeRequestStateSent) {
            self.likeDeleteRequestState = SocializeRequestStateFailed;
        }
    }
    
    [self startRecoveryTimer];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.actualButton.enabled = NO;
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
    
    if (self.like != nil) {
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
    }
    
    return actualButton_;
}

- (void)unlikeOnServer {
    if (self.likeDeleteRequestState != SocializeRequestStateSent) {
        self.likeDeleteRequestState = SocializeRequestStateSent;
        [self.socialize unlikeEntity:self.like];
    }
}

- (void)likeOnServer {
    if (self.likeCreateRequestState != SocializeRequestStateSent) {
        self.likeCreateRequestState = SocializeRequestStateSent;
        
        SocializeLike *like = [SocializeLike likeWithEntity:self.entity];
        [SocializeUILikeCreator createLike:like options:nil display:self.display success:^(id<SocializeLike> serverLike) {
            // Like has been successfully created
            self.likeCreateRequestState = SocializeRequestStateFinished;
            self.like = serverLike;
            self.actualButton.enabled = YES;
            self.serverEntity = serverLike.entity;
            [self configureButtonBackgroundImages];
            [[NSNotificationCenter defaultCenter] postNotificationName:SocializeLikeButtonDidChangeStateNotification object:self];

        } failure:^(NSError *error) {
            self.likeCreateRequestState = SocializeRequestStateFailed;
            [self startRecoveryTimer];
        }];
    }
}

- (void)toggleLikeState {
    if (self.like == nil) {
        [self likeOnServer];
    } else {
        [self unlikeOnServer];
    }
}

- (void)actualButtonPressed:(UIButton*)button {
    self.actualButton.enabled = NO;
    [self toggleLikeState];
}

- (void)setEntity:(id<SocializeEntity>)entity {
    NonatomicRetainedSetToFrom(entity_, entity);
    
    [self refresh];
}

- (void)refresh {
    [self.socialize cancelAllRequests];
    self.initialized = NO;
    self.likeGetRequestState = SocializeRequestStateNotStarted;
    self.likeDeleteRequestState = SocializeRequestStateNotStarted;
    self.likeCreateRequestState = SocializeRequestStateNotStarted;
    self.entityCreateRequestState = SocializeRequestStateNotStarted;
    self.like = nil;
    self.serverEntity = nil;
    [self stopRecoveryTimer];
    self.actualButton.enabled = NO;
    
    [self tryToFinishInitializing];
}

@end
