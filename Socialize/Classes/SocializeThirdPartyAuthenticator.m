//
//  SocializeThirdPartyAuthenticator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeThirdPartyAuthenticator.h"
#import "UIAlertView+BlocksKit.h"

@interface SocializeThirdPartyAuthenticator ()
@property (nonatomic, assign) BOOL sentTokenToSocialize;
@property (nonatomic, assign) BOOL attemptedAutoAuth;
@property (nonatomic, assign) BOOL failedAutoAuth;
@property (nonatomic, assign) BOOL authDialogAccepted;
@end

@implementation SocializeThirdPartyAuthenticator
@synthesize sentTokenToSocialize = sentTokenToSocialize_;
@synthesize authDialogAccepted = authDialogAccepted_;
@synthesize attemptedAutoAuth = attemptedAutoAuth_;
@synthesize failedAutoAuth = failedAutoAuth_;

@synthesize options = options_;

- (void)dealloc {
    self.options = nil;
    
    [super dealloc];
}

- (BOOL)authenticationPossible {
    NSAssert(NO, @"not implemented");
    return NO;
}

- (NSString*)thirdPartyName {
    NSAssert(NO, @"not implemented");
    return NO;    
}

- (BOOL)isAuthenticated {
    NSAssert(NO, @"not implemented");
    return NO;        
}

- (NSError*)thirdPartyUnavailableError {
    NSAssert(NO, @"not implemented");
    return nil;
}

- (NSError*)userAbortedAuthError {
    NSAssert(NO, @"not implemented");
    return nil;
}

- (BOOL)hasLocalCredentials {
    NSAssert(NO, @"not implemented");
    return NO;            
}

- (void)removeLocalCredentials {
    NSAssert(NO, @"not implemented");
}

- (void)authenticateWithLocalCredentials {
    NSAssert(NO, @"not implemented");
}

- (void)attemptInteractiveLogin {
    NSAssert(NO, @"not implemented");    
}

- (BOOL)isAuthenticationFailure:(NSError*)error {
    if ([[error domain] isEqualToString:SocializeErrorDomain] && [error code] == SocializeErrorServerReturnedHTTPError) {
        
        // Determine if this is an error we can recover from
        NSHTTPURLResponse *response = [[error userInfo] objectForKey:kSocializeErrorNSHTTPURLResponseKey];
        if ([response statusCode] == 401 || [response statusCode] == 403) {
            return YES;
        }
    }
    
    return NO;
}

- (void)tryToFinishAuthenticating {
    // Check if auth is even possible
    if (![self authenticationPossible]) {
        [self failWithError:[self thirdPartyUnavailableError]];
        return;
    }
    
    // Try to silently auto auth if there are already credentials and we haven't already tried
    if (![self isAuthenticated] && [self hasLocalCredentials] && !self.attemptedAutoAuth) {
        [self.displayProxy startLoading];
        self.attemptedAutoAuth = YES;
        [self authenticateWithLocalCredentials];
        return;
    }
    
    // Show dialog, allow user abort if desired
    if (![self hasLocalCredentials] && !self.authDialogAccepted && ![self.options doNotPromptForPermission]) {
        [self showLoginDialog];
        return;
    }
    
    // Interactive login
    if (![self hasLocalCredentials]) {
        [self attemptInteractiveLogin];
        return;
    }
    
    // Send auth data to Socialize
    if (!self.sentTokenToSocialize) {
        [self.displayProxy startLoading];
        [self authenticateWithLocalCredentials];
        return;
    }
    
    [self succeed];
}

- (void)showLoginDialog {
    NSString *title = [NSString stringWithFormat:@"%@ Login Required", [self thirdPartyName]];
    NSString *message = [NSString stringWithFormat:@"Do you want to log in with %@?", [self thirdPartyName]];
    UIAlertView *alertView = [UIAlertView alertWithTitle:title message:message];
    [alertView setCancelButtonWithTitle:@"No" handler:^{
        [self failWithError:[self userAbortedAuthError]];
    }];
    [alertView addButtonWithTitle:@"Yes"
                          handler:^{ self.authDialogAccepted = YES; [self tryToFinishAuthenticating]; }];
    
    [alertView show];    
}

- (void)socializeAuthenticationFailedWithError:(NSError*)error {
    if (self.attemptedAutoAuth && !self.failedAutoAuth) {
        
        // Auto auth failure
        self.failedAutoAuth = YES;
        
        if ([self isAuthenticationFailure:error]) {
            // Credentials are no longer valid, wipe credentials and retry
            [self removeLocalCredentials];
            [self tryToFinishAuthenticating];

        } else {
            
            // We can't handle the error, fail
            [self failWithError:error];
        }
    } else {
        
        // Normal failure
        [self failWithError:error];
    }
}

- (void)socializeAuthenticationSucceeded {
    self.sentTokenToSocialize = YES;
    [self tryToFinishAuthenticating];
    
}

- (void)executeAction {
    [self tryToFinishAuthenticating];
}

@end
