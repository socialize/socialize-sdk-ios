//
//  SocializeDeviceTokenSenderTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeDeviceTokenSender.h"

@interface SocializeDeviceTokenSenderTests : GHAsyncTestCase

@property (nonatomic, retain) SocializeDeviceTokenSender *deviceTokenSender;
@property (nonatomic, retain) id mockSocialize;

@end
