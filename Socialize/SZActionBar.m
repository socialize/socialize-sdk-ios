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
#import "SZActionEntityButton.h"
#import "NSNumber+Additions.h"

@interface SZActionBar ()
@property (nonatomic, strong) SZHorizontalContainerView *buttonsContainerRight;
@property (nonatomic, strong) SZHorizontalContainerView *buttonsContainerLeft;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation SZActionBar
@synthesize backgroundImage = _backgroundImage;
@synthesize itemsRight = _itemsRight;
@synthesize itemsLeft = _itemsLeft;
@synthesize buttonsContainerRight = _buttonsContainerRight;
@synthesize buttonsContainerLeft = _buttonsContainerLeft;
@synthesize entity = _entity;
@synthesize serverEntity = _serverEntity;
@synthesize viewController = _viewController;
@synthesize testView = _testView;
@synthesize betweenButtonsPadding = _betweenButtonsPadding;
@synthesize activityIndicator = _activityIndicator;

+ (id)defaultActionBarWithFrame:(CGRect)frame entity:(id<SZEntity>)entity viewController:(UIViewController*)viewController {
    SZLikeButton *likeButton = [[SZLikeButton alloc] initWithFrame:CGRectZero entity:nil viewController:viewController];

    SZCommentButton *commentButton = [[SZCommentButton alloc] initWithFrame:CGRectZero entity:nil viewController:viewController];

    SZActionButton *shareButton = [SZActionButton actionButtonWithFrame:CGRectZero icon:[UIImage imageNamed:@"action-bar-icon-share.png"] title:@"Share" actionBlock:^{
        [SZShareUtils showShareDialogWithViewController:viewController entity:entity completion:nil];
    }];
                                    
    NSArray *itemsRight = [NSArray arrayWithObjects:likeButton, commentButton, shareButton, nil];
    
    SZActionEntityButton *viewsButton = [SZActionEntityButton actionEntityButtonWithFrame:CGRectZero entity:nil entityConfiguration:^(SZActionEntityButton *button, id<SZEntity> serverEntity) {
        NSString* formattedValue = [NSNumber formatMyNumber:[NSNumber numberWithInteger:serverEntity.views] ceiling:[NSNumber numberWithInt:1000]]; 
        [button setTitle:formattedValue];
    }];
    
    UIImage *icon = [UIImage imageNamed:@"action-bar-icon-views.png"];
    viewsButton.icon = icon;
    viewsButton.image = nil;
    
    NSArray *itemsLeft = [NSArray arrayWithObjects:viewsButton, nil];


    return [[self alloc] initWithFrame:frame entity:entity viewController:viewController itemsLeft:itemsLeft itemsRight:itemsRight];
}

- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity viewController:(UIViewController *)viewController itemsLeft:(NSArray*)itemsLeft itemsRight:(NSArray*)itemsRight {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.betweenButtonsPadding = [[self class] defaultBetweenButtonsPadding];
        
        _entity = entity;
        self.viewController = viewController;
        self.itemsRight = itemsRight;
        self.itemsLeft = itemsLeft;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        [self addSubview:self.buttonsContainerRight];
        [self addSubview:self.buttonsContainerLeft];
        [self addSubview:self.activityIndicator];
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
    self.buttonsContainerRight.padding = betweenButtonsPadding;
    self.buttonsContainerRight.initialPadding = betweenButtonsPadding;
    self.buttonsContainerLeft.padding = betweenButtonsPadding;
    self.buttonsContainerLeft.initialPadding = betweenButtonsPadding;
}

- (SZHorizontalContainerView*)buttonsContainerRight {
    if (_buttonsContainerRight == nil) {
        _buttonsContainerRight = [[SZHorizontalContainerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)];
        _buttonsContainerRight.centerColumns = YES;
        _buttonsContainerRight.rightJustified = YES;
    }
    
    return _buttonsContainerRight;
}

- (SZHorizontalContainerView*)buttonsContainerLeft {
    if (_buttonsContainerLeft == nil) {
        _buttonsContainerLeft = [[SZHorizontalContainerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)];
        _buttonsContainerLeft.centerColumns = YES;
    }
    
    return _buttonsContainerLeft;
}

- (void)adjustForNewFrame {
    self.buttonsContainerRight.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.buttonsContainerLeft.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.activityIndicator.frame = CGRectMake(30, roundf(self.frame.size.height / 2.f), 0, 0);
}

- (UIActivityIndicatorView*)activityIndicator {
    if (_activityIndicator == nil) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicator.hidesWhenStopped = YES;
    }
    
    return _activityIndicator;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self adjustForNewFrame];
    [self.buttonsContainerRight layoutColumns];
    [self.buttonsContainerLeft layoutColumns];
}

- (void)setItemsRight:(NSArray *)items {
    _itemsRight = items;
    [self.buttonsContainerRight setColumns:_itemsRight];
}

- (void)setItemsLeft:(NSArray *)items {
    _itemsLeft = items;
    [self.buttonsContainerLeft setColumns:_itemsLeft];
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
        for (id<SZActionBarItem> item in self.itemsRight) {
            if ([item conformsToProtocol:@protocol(SZActionBarItem)]) {
                [item actionBar:self didLoadEntity:entity];
            }
        }
        
        for (id<SZActionBarItem> item in self.itemsLeft) {
            if ([item conformsToProtocol:@protocol(SZActionBarItem)]) {
                [item actionBar:self didLoadEntity:entity];
            }
        }

        [self.buttonsContainerRight layoutColumns];
        [self.buttonsContainerLeft layoutColumns];
    }];
    
}

- (void)hideButtons {
    self.buttonsContainerLeft.hidden = YES;
    self.buttonsContainerRight.hidden = YES;
}

- (void)showButtons {
    self.buttonsContainerLeft.hidden = NO;
    self.buttonsContainerRight.hidden = NO;
}

- (void)initializeEntity {
    if (self.entity == nil) {
        return;
    }
    
    // Already initialized
    if ([[self.serverEntity key] isEqualToString:[self.entity key]]) {
        return;
    }
    
    self.serverEntity = nil;
    
    if ([self.entity isFromServer]) {
        [self configureForNewServerEntity:self.entity];
    } else {
        [self hideButtons];
        [self.activityIndicator startAnimating];
        [SZEntityUtils addEntity:self.entity success:^(id<SZEntity> entity) {
            [self.activityIndicator stopAnimating];
            [self showButtons];
            [self configureForNewServerEntity:entity];
        } failure:^(NSError *error) {
            [self.activityIndicator stopAnimating];
            [self showButtons];
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

- (void)setEntity:(id<SocializeEntity>)entity {
    _entity = entity;
    [self initializeEntity];
}

- (void)drawRect:(CGRect)rect 
{	
	[super drawRect:rect];   
	[self.backgroundImage drawInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height) blendMode:kCGBlendModeMultiply alpha:1.0];
}

@end
