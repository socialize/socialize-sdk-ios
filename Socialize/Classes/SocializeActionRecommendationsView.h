//
//  SocializeRecommendationsView.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/4/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RECOMMENDATIONS_RAISE_OFFSET 210
#define RECOMMENDATIONS_HEADER_HEIGHT 30

#define RECOMMENDATIONS_HEIGHT 240
#define RECOMMENDATIONS_WIDTH 320

@interface SocializeActionRecommendationsView : UIView
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, assign) BOOL raised;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) id<UITableViewDelegate, UITableViewDataSource> delegate;

- (void)show;
- (void)hide;

@end
