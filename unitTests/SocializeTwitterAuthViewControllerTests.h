//
//  SocializeTwitterAuthViewControllerTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewControllerTests.h"
#import "SocializeTwitterAuthViewController.h"

@interface SocializeTwitterAuthViewControllerTests : SocializeBaseViewControllerTests
@property (nonatomic, retain) SocializeTwitterAuthViewController *twitterAuthViewController;
@property (nonatomic, retain) id mockWebView;
@property (nonatomic, retain) id mockDelegate;
@end
