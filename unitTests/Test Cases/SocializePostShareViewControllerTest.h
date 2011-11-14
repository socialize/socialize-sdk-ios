//
//  SocializePostShareViewControllerTest.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/11/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "SocializePostShareViewController.h"

@interface SocializePostShareViewControllerTest : GHTestCase
@property (nonatomic, retain) SocializePostShareViewController *postShareViewController;
@property (nonatomic, retain) SocializePostShareViewController *origPostShareViewController;
@property (nonatomic, retain) id mockShareObject;
@property (nonatomic, retain) id mockSocialize;
@property (nonatomic, retain) id mockTextView;
@property (nonatomic, retain) id mockShareBuilder;
@end
