//
//  SocializeViewTests.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <UIKit/UIKit.h>
#import "SocializeCommonDefinitions.h"
#import "SocializeRequest.h"
#import "SocializeViewService.h"

@class SocializeViewService;
@interface SocializeViewTests : GHTestCase<SocializeServiceDelegate, SocializeRequestDelegate> {
    SocializeViewService    *_service;
    id                      _mockService;
    NSError                 *_testError;
}

@end
