//
//  SZShareDialogViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZNavigationController.h"
#import "SocializeObjects.h"
#import "_SZShareDialogViewController.h"
#import "SZDisplay.h"
#import "SZViewControllerWrapper.h"

@interface SZShareDialogViewController : SZViewControllerWrapper
- (id)initWithEntity:(id<SZEntity>)entity;
@property (nonatomic, retain) NSArray *shares;
@property (nonatomic, copy) void (^completionBlock)(NSArray *shares);
@property (nonatomic, copy) void (^cancellationBlock)();
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) id<SZEntity> entity;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, copy) NSString *continueText;
@property (nonatomic, strong) _SZShareDialogViewController *_shareDialogViewController;
@property (nonatomic, strong) id<SZDisplay> display;

@end
