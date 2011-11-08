//
//  SocializeProfileEditViewControllerTest.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/3/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

@class SocializeProfileEditViewController;

@interface SocializeProfileEditViewControllerTest : GHTestCase
@property (nonatomic, retain) SocializeProfileEditViewController *origProfileEditViewController;
@property (nonatomic, retain) SocializeProfileEditViewController *profileEditViewController;
@property (nonatomic, retain) id mockDelegate;
@property (nonatomic, retain) id mockTableView;
@property (nonatomic, retain) id mockBundle;
@end
