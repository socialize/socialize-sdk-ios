//
//  SZActionEntityButton.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/24/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZActionEntityButton.h"
#import "SDKHelpers.h"
#import "SZEntityUtils.h"
#import "SZActionButton_Private.h"

@implementation SZActionEntityButton
@synthesize entity = _entity;
@synthesize serverEntity = _serverEntity;
@synthesize entityConfigurationBlock = _entityConfigurationBlock;

+ (SZActionEntityButton*)actionEntityButtonWithFrame:(CGRect)frame entity:(id<SZEntity>)entity entityConfiguration:(void(^)(SZActionEntityButton *button, id<SZEntity> entity))entityConfigurationBlock {
    SZActionEntityButton *button = [[SZActionEntityButton alloc] initWithFrame:frame entity:entity];
    button.entityConfigurationBlock = entityConfigurationBlock;
    return button;
}

- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity {
    if (self = [super initWithFrame:frame]) {
        self.entity = entity;
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

- (void)configureForEntity:(id<SZEntity>)entity {
}

- (void)configureForNewServerEntity:(id<SZEntity>)serverEntity {
    self.serverEntity = serverEntity;
    
    if (self.entityConfigurationBlock != nil) {
        self.entityConfigurationBlock(self, serverEntity);
    } else {
        [self configureForEntity:serverEntity];
    }
    
    [self configureButtonBackgroundImages];
    [self autoresize];
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

@end
