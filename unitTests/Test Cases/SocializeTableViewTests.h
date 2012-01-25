//
//  SocializeTableViewTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/23/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewControllerTests.h"

@class SocializeTableViewController;

@interface SocializeTableViewTests : SocializeBaseViewControllerTests
@property (nonatomic, retain) SocializeTableViewController *tableViewController;
@property (nonatomic, retain) SocializeTableViewController *partialTableViewController;
@property (nonatomic, retain) id mockTableView;
@property (nonatomic, retain) id mockInformationView;
@property (nonatomic, retain) id mockTableBackgroundView;
@property (nonatomic, retain) id mockContent;
@property (nonatomic, retain) id mockActivityLoadingActivityIndicatorView;
@property (nonatomic, retain) id mockTableFooterView;

- (void)expectViewDidLoad;
@end
