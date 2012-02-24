//
//  SocializeThirdPartyAuthenticator.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeAction.h"
#import "SocializeAuthOptions.h"

@interface SocializeThirdPartyAuthenticator : SocializeAction
- (BOOL)authenticationPossible;
- (NSString*)thirdPartyName;
- (BOOL)isAuthenticated;
- (NSError*)thirdPartyUnavailableError;
- (NSError*)userAbortedAuthError;
- (BOOL)hasLocalCredentials;
- (void)removeLocalCredentials;
- (void)authenticateWithLocalCredentials;
- (BOOL)isAuthenticationFailure:(NSError*)error;
- (void)attemptInteractiveLogin;
- (void)socializeAuthenticationFailedWithError:(NSError*)error;
- (void)socializeAuthenticationSucceeded;

- (void)tryToFinishAuthenticating;

@property (nonatomic, retain) SocializeAuthOptions *options;

@end
