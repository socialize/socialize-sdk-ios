//
//  SocializeFacebookAuthenticatorTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeFacebookAuthenticator.h"
#import "SocializeThirdPartyAuthenticatorTests.h"

@interface SocializeFacebookAuthenticatorTests : SocializeThirdPartyAuthenticatorTests

@property (nonatomic, retain) SocializeFacebookAuthenticator *facebookAuthenticator;
@property (nonatomic, retain) id mockFacebookAuthHandler;

@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSDate *expirationDate;

@end
