//
//  SocializeThirdPartyAuthenticatorTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/1/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeThirdPartyAuthenticatorTests.h"
#import "SocializeThirdPartyAuthenticator.h"
#import "SocializeActionTests.h"

@interface SocializeThirdPartyAuthenticatorTests : SocializeActionTests
@property (nonatomic, retain) SocializeThirdPartyAuthenticator *thirdPartyAuthenticator;
@property (nonatomic, retain) id mockThirdParty;
@property (nonatomic, assign) BOOL isAuthenticated;
@property (nonatomic, assign) BOOL hasLocalCredentials;
@property (nonatomic, assign) BOOL authenticationPossible;
@property (nonatomic, retain) id mockSettings;

- (void)respondToLoginDialogWithAccept:(BOOL)accept;
- (void)simulateAutoAuthConditions;
- (void)simulateInteractiveAuthConditions;
- (void)simulateInteractiveAuthConditions;
- (void)succeedInteractiveLogin;
- (void)suceedSocializeAuthentication;
- (void)expectSocializeAuthenticationAndDo:(void(^)())block;
- (NSInteger)authType;
- (void)stubBoolsForMockThirdParty:(id)mockThirdParty;

- (void)expectSettingsAndCancel;
- (void)expectSettingsAndSave;
- (void)expectSettingsAndLogout;

@end
