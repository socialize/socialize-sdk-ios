//
//  SocializeAuthTests.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/17/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <UIKit/UIKit.h>

#import "SocializeAuthenticateService.h"

@interface SocializeAuthTests : GHTestCase<SocializeAuthenticationDelegate> {
    SocializeAuthenticateService* _service;
    NSError*                      _testError;
}

@end
