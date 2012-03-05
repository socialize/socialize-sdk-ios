//
//  SocializeTwitterAuthenticatorTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeActionTests.h"
#import "SocializeThirdPartyAuthenticatorTests.h"

@class SocializeTwitterAuthenticator;

@interface SocializeTwitterAuthenticatorTests : SocializeThirdPartyAuthenticatorTests

@property (nonatomic, retain) SocializeTwitterAuthenticator *twitterAuthenticator;

@end
