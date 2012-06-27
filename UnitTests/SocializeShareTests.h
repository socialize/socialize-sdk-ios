//
//  SocializeShareTests.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <UIKit/UIKit.h>
#import "SocializeCommonDefinitions.h"
#import "SocializeRequest.h"
#import "SocializeShareService.h"


@interface SocializeShareTests : GHTestCase<SocializeServiceDelegate> {
    SocializeShareService   *_service;
    id _mockService;
    NSError                 *_testError;
}

@end
