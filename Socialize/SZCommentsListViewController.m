//
//  SZCommentsListViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZCommentsListViewController.h"
#import "_SZCommentsListViewController.h"
#import "SZCommentsListViewControllerIOS6.h"
#import "UIDevice+VersionCheck.h"

@interface SZCommentsListViewController ()
@property (nonatomic, strong) id<SZEntity> entity;

@end

@implementation SZCommentsListViewController
@dynamic completionBlock;

//class cluster impl
//used for navbar as this class is a subclass of SZNavigationBar
+ (id)alloc {
    if([self class] == [SZCommentsListViewController class] &&
       [[UIDevice currentDevice] systemMajorVersion] < 7) {
        return [SZCommentsListViewControllerIOS6 alloc];
    }
    else {
        return [super alloc];
    }
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super init]) {
        self.entity = entity;
        self._commentsListViewController = [[_SZCommentsListViewController alloc] initWithEntity:self.entity];
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self._commentsListViewController.commentOptions = self.commentOptions;
    [self pushViewController:self._commentsListViewController animated:NO];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self._commentsListViewController;
}

@end
