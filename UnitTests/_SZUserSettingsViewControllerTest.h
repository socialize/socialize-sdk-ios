//
//  _SZUserSettingsViewControllerTest.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/3/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeBaseViewControllerTests.h"

@class _SZUserSettingsViewController;

@interface _SZUserSettingsViewControllerTest : SocializeBaseViewControllerTests
@property (nonatomic, retain) _SZUserSettingsViewController *profileEditViewController;
@property (nonatomic, retain) id mockDelegate;
@property (nonatomic, retain) id mockTableView;
@property (nonatomic, retain) id mockBundle;
@property (nonatomic, retain) id mockNavigationItem;
@property (nonatomic, retain) id mockFacebookSwitch;
@property (nonatomic, retain) id mockTwitterSwitch;
@property (nonatomic, retain) id mockUserDefaults;
@property (nonatomic, retain) id mockActionSheet;
@property (nonatomic, retain) id mockSaveButton;

@property (nonatomic, assign) BOOL isAuthenticatedWithTwitter;
@property (nonatomic, assign) BOOL twitterAvailable;
@property (nonatomic, assign) BOOL isAuthenticatedWithFacebook;
@property (nonatomic, assign) BOOL facebookAvailable;

@end
