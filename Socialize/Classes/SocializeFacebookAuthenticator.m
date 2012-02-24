//
//  SocializeFacebookAuthenticator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeFacebookAuthenticator.h"
#import "_Socialize.h"
#import "SocializeErrorDefinitions.h"
#import "SocializeUIDisplayProxy.h"

@implementation SocializeFacebookAuthenticator
@synthesize options = options_;

- (void)dealloc {
    self.options = nil;
    
    [super dealloc];
}

+ (void)authenticateViaFacebookWithOptions:(SocializeFacebookAuthOptions*)options
                                   display:(id)display
                                   success:(void(^)())success
                                   failure:(void(^)(NSError *error))failure {
    SocializeFacebookAuthenticator *auth = [[[self alloc] initWithDisplayObject:nil display:display options:options success:success failure:failure] autorelease];
    [SocializeAction executeAction:auth];
}

+ (void)authenticateViaFacebookWithOptions:(id)options
                              displayProxy:(SocializeUIDisplayProxy*)proxy
                                   success:(void(^)())success
                                   failure:(void(^)(NSError *error))failure {
    SocializeFacebookAuthenticator *auth = [[[self alloc] initWithDisplayObject:proxy.object display:proxy.display options:options success:success failure:failure] autorelease];
    [SocializeAction executeAction:auth];
}


- (id)initWithDisplayObject:(id)displayObject
                    display:(id)display
                    options:(SocializeFacebookAuthOptions*)options
                    success:(void(^)())success
                    failure:(void(^)(NSError *error))failure {
    
    if (self = [super initWithDisplayObject:displayObject display:display success:success failure:failure]) {
        self.options = options;
    }
    
    return self;
}

- (BOOL)authenticationPossible {
    return [self.socialize facebookAvailable];
}

- (NSError*)thirdPartyUnavailableError {
    return [NSError defaultSocializeErrorForCode:SocializeErrorFacebookUnavailable];
}

- (NSString*)thirdPartyName {
    return @"Facebook";
}

- (BOOL)isAuthenticated {
    return [self.socialize isAuthenticatedWithFacebook];
}

- (BOOL)hasLocalCredentials {
    return [self.socialize facebookSessionValid];
}

- (void)removeLocalCredentials {
    [self.socialize removeFacebookAuthenticationInfo];
}

- (void)authenticateWithLocalCredentials {
    [self.socialize authenticateViaFacebookWithStoredCredentials];
}

- (void)attemptInteractiveLogin {
    [self.displayProxy startLoading];
    [self.socialize authenticateViaFacebook];
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    [self socializeAuthenticationFailedWithError:error];
}

- (NSError*)userAbortedAuthError {
    return [NSError defaultSocializeErrorForCode:SocializeErrorFacebookCancelledByUser];
}

- (void)didAuthenticate:(id<SocializeUser>)user {
    [self socializeAuthenticationSucceeded];
}


@end
