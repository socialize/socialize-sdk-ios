//
//  SocializeDeviceTokenServiceTests.h
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/13/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeDeviceTokenService.h"

@interface SocializeDeviceTokenServiceTests : GHTestCase

@property(nonatomic, retain) SocializeDeviceTokenService *deviceTokenService;
@property(nonatomic, retain) id partialDeviceTokenService;
@property(nonatomic, retain) id mockDeviceTokenString;
@property(nonatomic, retain) id mockDeviceToken;
@end    
