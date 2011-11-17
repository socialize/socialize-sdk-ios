//
//  SocializePostShareViewControllerTest.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/11/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "SocializePostShareViewController.h"
#import "SocializeComposeMessageViewControllerTests.h"

@interface SocializePostShareViewControllerTest : SocializeComposeMessageViewControllerTests
@property (nonatomic, retain) SocializePostShareViewController *postShareViewController;
@property (nonatomic, retain) id mockShareObject;
@end
