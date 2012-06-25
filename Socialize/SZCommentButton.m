//
//  SZCommentButton.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/23/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZCommentButton.h"
#import "NSNumber+Additions.h"
#import "SDKHelpers.h"
#import "SZEntityUtils.h"
#import "SZCommentUtils.h"

@implementation SZCommentButton
@synthesize entity = _entity;
@synthesize serverEntity = _serverEntity;
@synthesize viewController = _viewController;

- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity viewController:(UIViewController*)viewController {
    if (self = [super initWithFrame:frame]) {
        
        self.icon = [UIImage imageNamed:@"action-bar-icon-comments.png"];
        self.actualButton.accessibilityLabel = @"comment button";
        self.entity = entity;
        self.viewController = viewController;
    }
    return self;
}

- (void)setEntity:(id<SocializeEntity>)entity {
    _entity = entity;
    
    if (_entity == nil) {
        return;
    }
    
    // This is the user-set entity property. The server entity is always stored in self.serverEntity
    if (![entity isFromServer]) {
        [self refresh];
    } else {
        [self configureForNewServerEntity:entity];
    }
}

- (void)actionBar:(SZActionBar *)actionBar didLoadEntity:(id<SocializeEntity>)entity {
    self.entity = entity;
}

- (void)configureForNewServerEntity:(id<SZEntity>)serverEntity {
    NSString* formattedValue = [NSNumber formatMyNumber:[NSNumber numberWithInteger:serverEntity.likes] ceiling:[NSNumber numberWithInt:1000]]; 
    [self setTitle:formattedValue];
}

- (void)refresh {
    self.serverEntity = nil;
    self.actualButton.enabled = NO;
    
    SZAttemptAction(self.failureRetryInterval, ^(void(^didFail)(NSError*)) {
        [SZEntityUtils addEntity:self.entity success:^(id<SZEntity> entity) {
            self.actualButton.enabled = YES;
            [self configureForNewServerEntity:entity];
        } failure:didFail];
    });
}

- (void)handleButtonPress:(id)sender {
    [SZCommentUtils showCommentsListWithViewController:self.viewController entity:self.entity completion:nil];
}

@end
