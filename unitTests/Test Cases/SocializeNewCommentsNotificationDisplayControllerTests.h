//
//  SocializeNewCommentsNotificationDisplayControllerTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/10/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

@class SocializeNewCommentsNotificationDisplayController;

@interface SocializeNewCommentsNotificationDisplayControllerTests : GHAsyncTestCase
@property (nonatomic, retain) SocializeNewCommentsNotificationDisplayController *commentsNotificationDisplayController;
@property (nonatomic, retain) id mockNavigationController;
@property (nonatomic, retain) id mockActivityDetailsViewController;
@property (nonatomic, retain) id mockCommentsTableViewController;
@property (nonatomic, retain) id mockDelegate;

@end
