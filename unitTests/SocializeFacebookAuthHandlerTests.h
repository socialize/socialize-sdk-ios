//
//  SocializeFacebookAuthHandlerTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeTestCase.h"
#import "SocializeFacebookAuthHandler.h"

@interface SocializeFacebookAuthHandlerTests : SocializeTestCase
@property (nonatomic, retain) SocializeFacebookAuthHandler *facebookAuthHandler;
@property (nonatomic, retain) id mockFacebookClass;
@property (nonatomic, retain) id mockFacebook;
@end
