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


@class SocializeLikeService;
@interface SocializeLikeTests : GHTestCase<SocializeLikeServiceDelegate> {
    
    SocializeLikeService    *_service;
    NSError                 *_testError;
}

@end
