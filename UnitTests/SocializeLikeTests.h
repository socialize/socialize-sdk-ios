//
//  SocializeLikeTests.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/23/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <UIKit/UIKit.h>
#import "SocializeCommonDefinitions.h"
#import "SocializeRequest.h"
#import "SocializeService.h"
#import "SocializeTestCase.h"


@class SocializeLikeService;
@interface SocializeLikeTests : SocializeTestCase <SocializeServiceDelegate, SocializeRequestDelegate> {
    
    SocializeLikeService    *_service;
    id                      _mockService;
    NSError                 *_testError;
}

@end
