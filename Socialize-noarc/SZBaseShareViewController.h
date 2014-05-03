//
//  SZBaseShareViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewController.h"
#import "SZShareOptions.h"

#define SHARE_DIALOG_BUCKET @"SHARE_DIALOG"

@class SZShareDialogView;

@interface SZBaseShareViewController : SocializeBaseViewController <UITableViewDelegate, UITableViewDataSource>

- (id)initWithEntity:(id<SZEntity>)entity;
- (IBAction)continueButtonPressed:(id)sender;
- (void)persistSelection;
- (void)trackShareEventsForNetworks:(SZSocialNetwork)networks;
- (void)trackShareEventsForNetworkNames:(NSArray*)networkNames;
- (SZShareOptions*)optionsForShare;
- (void)deselectSelectedRow;

@property (nonatomic, retain) NSMutableArray *createdShares;
@property (nonatomic, retain) id<SZEntity> entity;
@property (nonatomic, retain) IBOutlet SZShareDialogView *shareDialogView;
@property (nonatomic, readonly) SZSocialNetwork selectedNetworks;
@property (nonatomic, assign) BOOL showOtherShareTypes;
@property (nonatomic, assign) BOOL disableAutopostSelection;
@property (nonatomic, assign) BOOL hideUnlinkedNetworks;
@property (nonatomic, assign) BOOL dontRequireNetworkSelection;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, copy) NSString *continueText;
@property (nonatomic, retain) SZShareOptions *shareOptions;

@property (nonatomic, assign) BOOL hideSMS;
@property (nonatomic, assign) BOOL hideEmail;
@property (nonatomic, assign) BOOL hideFacebook;
@property (nonatomic, assign) BOOL hideTwitter;
@property (nonatomic, assign) BOOL hidePinterest;
@property (nonatomic, assign) BOOL hideWhatsApp;

@end
