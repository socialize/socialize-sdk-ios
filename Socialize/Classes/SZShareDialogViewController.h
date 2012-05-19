//
//  SZShareDialogViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewController.h"

@class SZShareDialogView;

@interface SZShareDialogViewController : SocializeBaseViewController <UITableViewDelegate, UITableViewDataSource>

- (id)initWithEntity:(id<SZEntity>)entity;
- (IBAction)continueButtonPressed:(id)sender;

@property (nonatomic, retain) id<SZEntity> entity;
@property (nonatomic, retain) IBOutlet SZShareDialogView *shareDialogView;
@property (nonatomic, readonly) SZSocialNetwork selectedNetworks;
@property (nonatomic, assign) BOOL showOtherShareTypes;
@property (nonatomic, assign) BOOL disableAutopostSelection;

@property (nonatomic, copy) void (^completionBlock)(SZSocialNetwork selectedNetworks);
@end
