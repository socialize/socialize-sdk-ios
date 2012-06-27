//
//  SocializeProfileEditValueViewControllerTest.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/9/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeProfileEditValueViewController.h"
#import "SocializeBaseViewControllerTests.h"

@interface SocializeProfileEditValueViewControllerTest : SocializeBaseViewControllerTests
@property (nonatomic, retain) SocializeProfileEditValueViewController *profileEditValueViewController;
@property (nonatomic, retain) id mockTableView;
@property (nonatomic, retain) id mockBundle;
@property (nonatomic, retain) id mockSaveButton;
@end