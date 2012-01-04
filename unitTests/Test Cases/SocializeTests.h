//
//  SocializeTests.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/21/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Socialize.h"
#import "SocializeRequest.h"
#import <GHUnitIOS/GHUnit.h>


@interface SocializeTests : GHAsyncTestCase<SocializeServiceDelegate> {
    Socialize               *_service;
    NSError                 *_testError;
    id _mockService;
}

@end
