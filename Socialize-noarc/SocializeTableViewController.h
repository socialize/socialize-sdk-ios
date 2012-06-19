//
//  SocializePaginatedTableViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/23/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewController.h"

@class SocializeTableBGInfoView;

extern NSInteger SocializeTableViewControllerDefaultPageSize;

@interface SocializeTableViewController : SocializeBaseViewController  <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSMutableArray *content;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign, readonly) BOOL waitingForContent;
@property (nonatomic, assign, readonly) BOOL loadedAllContent;
@property (nonatomic, assign, readonly, getter=isInitialized) BOOL initialized;
@property (nonatomic, retain) IBOutlet UIView *tableFooterView;
@property (nonatomic, retain) IBOutlet UIView *tableBackgroundView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityLoadingActivityIndicatorView;
@property (nonatomic, retain) IBOutlet UILabel *activityLoadingLabel;
@property (nonatomic, retain) SocializeTableBGInfoView *informationView;
- (void)loadContentForNextPageAtOffset:(NSInteger)offset;
- (void)receiveNewContent:(NSArray*)content;
- (void)failLoadingContent;
- (void)scrollToTop;
- (void)initializeContent;
- (void)insertContentAtHead:(NSArray*)array;
@end