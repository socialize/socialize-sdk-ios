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
#import "SocializeProfileEditViewController.h"
#import "SocializeBaseViewControllerDelegate.h"

@interface SocializeThirdPartyAuthenticator ()
- (void)showLoginDialog;
@property (nonatomic, assign) BOOL sentTokenToSocialize;
@property (nonatomic, assign) BOOL authDialogAccepted;
@property (nonatomic, assign) BOOL interactiveLoginSucceeded;
@property (nonatomic, assign) BOOL displayedSettings;
@end

@implementation SocializeThirdPartyAuthenticator
@synthesize sentTokenToSocialize = sentTokenToSocialize_;
@synthesize authDialogAccepted = authDialogAccepted_;
@synthesize interactiveLoginSucceeded = interactiveLoginSucceeded_;
@synthesize displayedSettings = displayedSettings_;

@synthesize options = options_;
@synthesize thirdParty = thirdParty_;

- (void)dealloc {
    self.options = nil;
    
    [super dealloc];
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

- (BOOL)hasLocalCredentials {
    NSAssert(NO, @"not implemented");
    return NO;
}

- (NSString*)socializeAuthToken {
    NSAssert(NO, @"not implemented");
    return nil;
}

- (NSString*)socializeAuthTokenSecret {
    NSAssert(NO, @"not implemented");
    return nil;
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

- (void)finishWithSettings {
    // Settings cancelled
    self.displayedSettings = YES;
    [self tryToFinishAuthenticating];        
}

- (void)baseViewControllerDidCancel:(SocializeBaseViewController*)baseViewController {
    [self.displayProxy dismissModalViewController:baseViewController];
    [self finishWithSettings];
}

- (void)profileEditViewController:(SocializeProfileEditViewController *)profileEditViewController didUpdateProfileWithUser:(id<SocializeFullUser>)user {
    [self.displayProxy dismissModalViewController:profileEditViewController];
    [self finishWithSettings];
}

- (void)showSettings {
    SocializeProfileEditViewController *settings = [[[SocializeProfileEditViewController alloc] init] autorelease];
    settings.delegate = self;
    UINavigationController *nav = [settings wrappingSocializeNavigationController];
    [self.displayProxy presentModalViewController:nav];
}

- (void)tryToFinishAuthenticating {
    // Check if auth is even possible
    if (![self.thirdParty available]) {
        [self failWithError:[self.thirdParty thirdPartyUnavailableError]];
        return;
    }
    
    // Show dialog, allow user abort if desired
    if (!self.authDialogAccepted && ![self.options doNotPromptForPermission]) {
        [self showLoginDialog];
        return;
    }
    
    // Interactive login
    if (!self.interactiveLoginSucceeded) {
        [self attemptInteractiveLogin];
        return;
    }
    
    // Send auth data to Socialize
    if (!self.sentTokenToSocialize) {
        [self.displayProxy startLoading];
        [self linkWithSocializeUsingLocalCredentials];
        return;
    }
    
    if (!self.displayedSettings) {
        [self showSettings];
        return;
    }
    
    if (![self.thirdParty isLinkedToSocialize]) {
        // For example, maybe the user immediately logged out in settings
        [self failWithError:[self.thirdParty userAbortedAuthError]];
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

- (void)succeedInteractiveLogin {
    self.interactiveLoginSucceeded = YES;
    [self tryToFinishAuthenticating];
}

- (void)socializeAuthenticationFailedWithError:(NSError*)error {
    [self.thirdParty removeLocalCredentials];
    [self failWithError:error];
}

- (void)socializeAuthenticationSucceeded {
    self.sentTokenToSocialize = YES;
    [self tryToFinishAuthenticating];
}

- (void)executeAction {
    [self.thirdParty removeLocalCredentials];
    [self tryToFinishAuthenticating];
}

@end
