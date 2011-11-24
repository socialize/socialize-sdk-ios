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
@property (nonatomic, assign) id mockTableView;
@property (nonatomic, assign) id mockInformationView;
@property (nonatomic, assign) id mockTableBackgroundView;
@property (nonatomic, assign) id mockContent;
@property (nonatomic, assign) id mockActivityLoadingActivityIndicatorView;
@end
