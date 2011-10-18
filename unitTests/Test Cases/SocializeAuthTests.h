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

@interface SocializeAuthTests : GHAsyncTestCase<SocializeServiceDelegate> {
    SocializeAuthenticateService* _service;
    id                            _mockService;
    NSError*                      _testError;
}

@end
