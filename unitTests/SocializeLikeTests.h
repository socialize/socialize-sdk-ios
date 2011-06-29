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


@class SocializeLikeService;
@interface SocializeLikeTests : GHTestCase<SocializeLikeServiceDelegate, SocializeRequestDelegate> {
    
    SocializeLikeService    *_service;
    NSError                 *_testError;
}

@end
