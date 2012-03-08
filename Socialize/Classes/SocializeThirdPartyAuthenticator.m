//
//  SocializeThirdPartyAuthenticator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeThirdPartyAuthenticator.h"
#import "UIAlertView+BlocksKit.h"
#import "SocializeThirdParty.h"
#import "SocializeUIDisplayProxy.h"
#import "_Socialize.h"

@interface SocializeThirdPartyAuthenticator ()
- (void)showLoginDialog;
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
@synthesize thirdParty = thirdParty_;

- (void)dealloc {
    self.options = nil;
    
    [super dealloc];
}

- (id)initWithDisplayObject:(id)displayObject
                    display:(id)display
                    options:(SocializeAuthOptions*)options
                    success:(void(^)())success
                    failure:(void(^)(NSError *error))failure {
    
    if (self = [super initWithDisplayObject:displayObject display:display success:success failure:failure]) {
        self.options = options;
    }
    
    return self;
}

- (void)attemptInteractiveLogin {
    NSAssert(NO, @"not implemented");
}

- (Class)thirdParty {
    if (thirdParty_ == nil) {
        NSAssert(NO, @"not implemented");
    }
    return thirdParty_;
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

- (void)linkWithSocializeUsingLocalCredentials {
    [self.socialize authenticateWithThirdPartyAuthType:[self.thirdParty socializeAuthType]
                                   thirdPartyAuthToken:[self.thirdParty socializeAuthToken]
                             thirdPartyAuthTokenSecret:[self.thirdParty socializeAuthTokenSecret]];
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    [self socializeAuthenticationFailedWithError:error];
}

- (void)didAuthenticate:(id<SocializeUser>)user {
    [self socializeAuthenticationSucceeded];
}

- (void)tryToFinishAuthenticating {
    // Check if auth is even possible
    if (![self.thirdParty available]) {
        [self failWithError:[self.thirdParty thirdPartyUnavailableError]];
        return;
    }
    
    // Try to silently auto auth if there are already credentials and we haven't already tried
    if (![self.thirdParty isAuthenticated] && [self.thirdParty hasLocalCredentials] && !self.attemptedAutoAuth) {
        [self.displayProxy startLoading];
        self.attemptedAutoAuth = YES;
        [self linkWithSocializeUsingLocalCredentials];
        return;
    }
    
    // Show dialog, allow user abort if desired
    if (![self.thirdParty hasLocalCredentials] && !self.authDialogAccepted && ![self.options doNotPromptForPermission]) {
        [self showLoginDialog];
        return;
    }
    
    // Interactive login
    if (![self.thirdParty hasLocalCredentials]) {
        [self attemptInteractiveLogin];
        return;
    }
    
    // Send auth data to Socialize
    if (!self.sentTokenToSocialize) {
        [self.displayProxy startLoading];
        [self linkWithSocializeUsingLocalCredentials];
        return;
    }
    
    [self succeed];
}

- (void)showLoginDialog {
    NSString *title = [NSString stringWithFormat:@"%@ Login Required", [self.thirdParty thirdPartyName]];
    NSString *message = [NSString stringWithFormat:@"Do you want to log in with %@?", [self.thirdParty thirdPartyName]];
    UIAlertView *alertView = [UIAlertView alertWithTitle:title message:message];
    
    __block __typeof__(self) weakSelf = self;
    
    [alertView setCancelButtonWithTitle:@"No" handler:^{
        [weakSelf failWithError:[weakSelf.thirdParty userAbortedAuthError]];
    }];
    
    [alertView addButtonWithTitle:@"Yes" handler:^{
        weakSelf.authDialogAccepted = YES; [weakSelf tryToFinishAuthenticating];
    }];
    
    [self.displayProxy showAlertView:alertView];
}

- (void)socializeAuthenticationFailedWithError:(NSError*)error {
    if (self.attemptedAutoAuth && !self.failedAutoAuth) {
        
        // Auto auth failure
        self.failedAutoAuth = YES;
        
        if ([self isAuthenticationFailure:error]) {
            // Credentials are no longer valid, wipe credentials and retry
            [self.thirdParty removeLocalCredentials];
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
