//
//  SocializeTwitterAuthenticatorTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeTwitterAuthenticatorDelegate.h"

@class SocializeTwitterAuthenticator;

@interface SocializeTwitterAuthenticatorTests : GHAsyncTestCase <SocializeTwitterAuthenticatorDelegate>

@property (nonatomic, retain) SocializeTwitterAuthenticator *twitterAuthenticator;
@property (nonatomic, retain) id mockSocialize;
@property (nonatomic, retain) id mockDelegate;
@property (nonatomic, retain) id mockTwitterAuthViewController;
@property (nonatomic, retain) id mockNavigationForTwitterAuthViewController;
@property (nonatomic, retain) id mockPresentationTarget;

@end
