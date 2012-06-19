//
//  SocializeSubscriptionServiceTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

@class SocializeSubscriptionService;

@interface SocializeSubscriptionServiceTests : GHTestCase
@property (nonatomic, retain) SocializeSubscriptionService *origSubscriptionService;
@property (nonatomic, retain) SocializeSubscriptionService *subscriptionService;
@end
