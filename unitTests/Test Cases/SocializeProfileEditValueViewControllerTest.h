//
//  SocializeProfileEditValueViewControllerTest.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/9/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeProfileEditValueViewController.h"

@interface SocializeProfileEditValueViewControllerTest : GHTestCase
@property (nonatomic, retain) SocializeProfileEditValueViewController *origProfileEditValueViewController;
@property (nonatomic, retain) SocializeProfileEditValueViewController *profileEditValueViewController;
@property (nonatomic, retain) id mockDelegate;
@property (nonatomic, retain) id mockNavigationItem;
@property (nonatomic, retain) id mockNavigationController;
@property (nonatomic, retain) id mockTableView;
@property (nonatomic, retain) id mockBundle;
@end