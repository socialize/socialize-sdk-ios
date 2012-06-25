//
//  SZActionBar.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/15/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZActionBar.h"
#import "SZHorizontalContainerView.h"
#import "SZLikeButton.h"
#import "SZCommentButton.h"
#import "SZEntityUtils.h"
#import "SDKHelpers.h"
#import "SZActionBarItem.h"
#import "SZShareUtils.h"

@interface SZActionBar ()
@property (nonatomic, strong) SZHorizontalContainerView *buttonsContainer;
@end

@implementation SZActionBar
@synthesize backgroundImage = _backgroundImage;
@synthesize items = _items;
@synthesize buttonsContainer = _buttonsContainer;
@synthesize entity = _entity;
@synthesize serverEntity = _serverEntity;
@synthesize viewController = _viewController;
@synthesize testView = _testView;
@synthesize betweenButtonsPadding = _betweenButtonsPadding;

+ (id)defaultActionBarWithFrame:(CGRect)frame entity:(id<SZEntity>)entity viewController:(UIViewController*)viewController {
    SZLikeButton *likeButton = [[SZLikeButton alloc] initWithFrame:CGRectZero entity:nil viewController:viewController];

    SZCommentButton *commentButton = [[SZCommentButton alloc] initWithFrame:CGRectZero entity:nil viewController:viewController];

    SZActionButton *shareButton = [SZActionButton actionButtonWithFrame:CGRectZero icon:[UIImage imageNamed:@"action-bar-icon-share.png"] title:@"Share" actionBlock:^{
        [SZShareUtils showShareDialogWithViewController:viewController entity:entity completion:nil];
    }];
                                    
    NSArray *items = [NSArray arrayWithObjects:likeButton, commentButton, shareButton, nil];
    return [[self alloc] initWithFrame:frame entity:entity viewController:viewController items:items];
}

- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity viewController:(UIViewController *)viewController items:(NSArray*)items {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.betweenButtonsPadding = [[self class] defaultBetweenButtonsPadding];
        
        self.entity = entity;
        self.viewController = viewController;
        self.items = items;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        [self addSubview:self.buttonsContainer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (CGFloat)defaultHeight {
    return 44;
}

+ (CGFloat)defaultBetweenButtonsPadding {
    return 10;
}

- (void)setBetweenButtonsPadding:(CGFloat)betweenButtonsPadding {
    _betweenButtonsPadding = betweenButtonsPadding;
    self.buttonsContainer.padding = betweenButtonsPadding;
    self.buttonsContainer.initialPadding = betweenButtonsPadding;
}

- (SZHorizontalContainerView*)buttonsContainer {
    if (_buttonsContainer == nil) {
        _buttonsContainer = [[SZHorizontalContainerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)];
        _buttonsContainer.centerColumns = YES;
    }
    
    return _buttonsContainer;
}

- (void)layoutSubviews {
    self.buttonsContainer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.buttonsContainer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.buttonsContainer layoutColumns];
}

- (void)setItems:(NSArray *)items {
    _items = items;
    [self.buttonsContainer setColumns:_items];
}

- (UIImage*)backgroundImage {
    if (_backgroundImage == nil) {
        _backgroundImage = [[UIImage imageNamed:@"action-bar-bg.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:0.5];
    }
    
    return _backgroundImage;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self setNeedsDisplay];
}

- (void)autoresizeForSuperview:(UIView*)superview {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, superview.frame.size.width, [[self class] defaultHeight]);    
}

- (void)autoresize {
    [self autoresizeForSuperview:self.superview];
}

- (void)configureForNewServerEntity:(id<SZEntity>)entity {
    self.serverEntity = entity;

    [UIView animateWithDuration:0.3 animations:^{
        for (id<SZActionBarItem> item in self.items) {
            if ([item conformsToProtocol:@protocol(SZActionBarItem)]) {
                [item actionBar:self didLoadEntity:entity];
            }
        }
        [self.buttonsContainer layoutColumns];
    }];
    
}

- (void)initializeEntity {
    if (self.entity == nil) {
        return;
    }
    
    if ([self.entity isFromServer]) {
        [self configureForNewServerEntity:self.entity];
    } else {
        [SZEntityUtils addEntity:self.entity success:^(id<SZEntity> entity) {
            [self configureForNewServerEntity:entity];
        } failure:^(NSError *error) {
            SZEmitUIError(self, error);
        }];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    // Autosize if we don't yet have a nonzero frame
    if (CGRectIsEmpty(self.frame)) {
        [self autoresizeForSuperview:newSuperview];
    }
    
    [self initializeEntity];
}

- (void)drawRect:(CGRect)rect 
{	
	[super drawRect:rect];   
	[self.backgroundImage drawInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height) blendMode:kCGBlendModeMultiply alpha:1.0];
}

@end
