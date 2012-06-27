//
//  AuthViewControllerTests.h
//  SocializeSDK
//
//  Created by Isaac Mosquera on 11/9/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "_SZLinkDialogViewController.h"
#import <GHUnitIOS/GHUnit.h>

@interface AuthViewControllerTests : GHTestCase

@property(nonatomic,retain) _SZLinkDialogViewController *authViewController;
@property(nonatomic,retain) id mockAuthTableViewCell;
@property(nonatomic,retain) id mockTableView;
@property(nonatomic,retain) id partialMockAuthViewController;
@property(nonatomic,retain) id mockSocialize;
@end
