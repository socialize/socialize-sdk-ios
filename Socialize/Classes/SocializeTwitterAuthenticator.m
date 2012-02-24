//
//  SocializeTwitterAuthenticator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeTwitterAuthenticator.h"
#import "_Socialize.h"
#import "SocializeTwitterAuthViewController.h"
#import "UINavigationController+Socialize.h"
#import "SocializeUIDisplayProxy.h"

@implementation SocializeTwitterAuthenticator
@synthesize twitterAuthViewController = twitterAuthViewController_;
@synthesize options = options_;

- (void)dealloc {
    [twitterAuthViewController_ setDelegate:nil];
    self.twitterAuthViewController = nil;
    self.options = nil;
    
    [super dealloc];
}

+ (void)authenticateViaTwitterWithOptions:(SocializeTwitterAuthOptions*)options
                                  display:(id)display
                                  success:(void(^)())success
                                  failure:(void(^)(NSError *error))failure {
    SocializeTwitterAuthenticator *auth = [[[self alloc] initWithDisplayObject:nil display:display options:options success:success failure:failure] autorelease];
    [SocializeAction executeAction:auth];
}

+ (void)authenticateViaTwitterWithOptions:(SocializeTwitterAuthOptions*)options
                           displayProxy:(SocializeUIDisplayProxy*)proxy
                                success:(void(^)())success
                                failure:(void(^)(NSError *error))failure {
    SocializeTwitterAuthenticator *auth = [[[self alloc] initWithDisplayObject:proxy.object display:proxy.display options:options success:success failure:failure] autorelease];
    [SocializeAction executeAction:auth];
}


- (id)initWithDisplayObject:(id)displayObject
                    display:(id)display
                    options:(SocializeTwitterAuthOptions*)options
                    success:(void(^)())success
                    failure:(void(^)(NSError *error))failure {
    
    if (self = [super initWithDisplayObject:displayObject display:display success:success failure:failure]) {
        self.options = options;
    }
    
    return self;
}

- (void)cancelAllCallbacks {
    [twitterAuthViewController_ setDelegate:nil];
    [super cancelAllCallbacks];
}

- (BOOL)authenticationPossible {
    return [self.socialize twitterAvailable];
}

- (NSError*)thirdPartyUnavailableError {
    return [NSError defaultSocializeErrorForCode:SocializeErrorTwitterUnavailable];
}

- (NSError*)userAbortedAuthError {
    return [NSError defaultSocializeErrorForCode:SocializeErrorTwitterCancelledByUser];
}

- (NSString*)thirdPartyName {
    return @"Twitter";
}

- (BOOL)isAuthenticated {
    return [self.socialize isAuthenticatedWithTwitter];
}

- (BOOL)hasLocalCredentials {
    return [self.socialize twitterSessionValid];
}

- (void)removeLocalCredentials {
    [self.socialize removeTwitterAuthenticationInfo];
}

- (void)authenticateWithLocalCredentials {
    [self.socialize authenticateViaTwitterWithStoredCredentials];
}

- (void)attemptInteractiveLogin {
    [self showTwitterAuthViewController];
}

- (SocializeTwitterAuthViewController*)twitterAuthViewController {
    if (twitterAuthViewController_ == nil) {
        twitterAuthViewController_ = [[SocializeTwitterAuthViewController alloc] init];
        twitterAuthViewController_.delegate = self;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        twitterAuthViewController_.consumerKey = [defaults objectForKey:kSocializeTwitterAuthConsumerKey];
        twitterAuthViewController_.consumerSecret = [defaults objectForKey:kSocializeTwitterAuthConsumerSecret];
    }
    
    return twitterAuthViewController_;
}

- (void)showTwitterAuthViewController {
    self.twitterAuthViewController = nil;
    UINavigationController *nav = [self.twitterAuthViewController wrappingSocializeNavigationController];
    [self.displayProxy presentModalViewController:nav];
}

- (void)twitterAuthViewController:(SocializeTwitterAuthViewController *)twitterAuthViewController
            didReceiveAccessToken:(NSString *)accessToken
                accessTokenSecret:(NSString *)accessTokenSecret
                       screenName:(NSString *)screenName
                           userID:(NSString *)userID {

    // Successful auth -- store into the Socialize user defaults keys
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:kSocializeTwitterAuthAccessToken];
    [defaults setObject:accessTokenSecret forKey:kSocializeTwitterAuthAccessTokenSecret];
    [defaults setObject:screenName forKey:kSocializeTwitterAuthScreenName];
    [defaults synchronize];
}

- (void)baseViewControllerDidCancel:(SocializeBaseViewController *)baseViewController {
    /* The SocializeTwitterAuthViewController flow was cancelled by the user */
    [self.displayProxy dismissModalViewController:self.twitterAuthViewController];

    NSError *error = [NSError defaultSocializeErrorForCode:SocializeErrorTwitterCancelledByUser];
    [self failWithError:error];
}

- (void)baseViewControllerDidFinish:(SocializeBaseViewController *)baseViewController {
    /* The SocializeTwitterAuthViewController flow was completed successfully */
    [self.displayProxy dismissModalViewController:self.twitterAuthViewController];

    [self tryToFinishAuthenticating];
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    [self socializeAuthenticationFailedWithError:error];
}

- (void)didAuthenticate:(id<SocializeUser>)user {
    [self socializeAuthenticationSucceeded];
}


@end
