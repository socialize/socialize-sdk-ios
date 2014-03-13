//
//  SocializeFacebookAuthHandler.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//
// This file handles basic facebook auth flow to get a token and expiration date, and nothing more

#import "SocializeFacebookAuthHandler.h"
#import <Facebook-iOS-SDK/FacebookSDK/Facebook.h>
#import "SocializeCommonDefinitions.h"
#import "SocializePreprocessorUtilities.h"
#import "SocializeThirdPartyFacebook.h"
#import "socialize_globals.h"

static SocializeFacebookAuthHandler *sharedFacebookAuthHandler;

@implementation SocializeFacebookAuthHandler
@synthesize permissions = permissions_;
@synthesize successBlock = successBlock_;
@synthesize failureBlock = failureBlock_;
@synthesize foregroundBlock = foregroundBlock_;
@synthesize facebook = facebook_;
@synthesize authenticating = authenticating_;

- (void)dealloc {
    self.permissions = nil;
    self.successBlock = nil;
    self.failureBlock = nil;
    self.foregroundBlock = nil;
    self.facebook = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}

- (void)applicationDidBecomeActive:(NSNotification*)notification {
    if (self.authenticating) {
        // Foreground, but user did not select authenticate or cancel
        BLOCK_CALL(self.foregroundBlock);
    }
}

+ (SocializeFacebookAuthHandler*)sharedFacebookAuthHandler {
    if (sharedFacebookAuthHandler == nil) {
        sharedFacebookAuthHandler = [[SocializeFacebookAuthHandler alloc] init];
    }
    
    return sharedFacebookAuthHandler;
}

- (void)cancelAuthentication {
    self.authenticating = NO;
    self.successBlock = nil;
    self.failureBlock = nil;
    self.foregroundBlock = nil;
}

- (void)failWithError:(NSError*)error {
}


- (void)authenticateWithAppId:(NSString*)appId
              urlSchemeSuffix:(NSString*)urlSchemeSuffix
                  permissions:(NSArray*)permissions
                      success:(void(^)())success
                   foreground:(void(^)())foreground
                      failure:(void(^)(NSError*))failure {
    
    self.authenticating = YES;
    self.facebook = [[[Facebook alloc] initWithAppId:appId urlSchemeSuffix:urlSchemeSuffix andDelegate:self] autorelease];
    self.permissions = permissions;
    self.successBlock = success;
    self.failureBlock = failure;
    self.foregroundBlock = foreground;
    [self.facebook authorize:self.permissions];
}

- (BOOL)handleOpenURL:(NSURL*)url {
    return [self.facebook handleOpenURL:url];
}

- (void)fbDidLogin {
    self.authenticating = NO;
    
    if (self.successBlock != nil) {
        self.successBlock([self.facebook accessToken], [self.facebook expirationDate]);
    }
    self.successBlock = nil;
    self.failureBlock = nil;
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    self.authenticating = NO;
    
    if (self.failureBlock != nil) {
        if (cancelled) {
            self.failureBlock([NSError defaultSocializeErrorForCode:SocializeErrorFacebookCancelledByUser]);
        }
        else {
            self.failureBlock([NSError defaultSocializeErrorForCode:SocializeErrorFacebookAuthFailed]);
        }
    }
    
    self.successBlock = nil;
    self.failureBlock = nil;
}

- (void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    [SocializeThirdPartyFacebook storeLocalCredentialsWithAccessToken:accessToken expirationDate:expiresAt];
}

- (void)fbDidLogout {
}

- (void)fbSessionInvalidated {
    [SocializeThirdPartyFacebook removeLocalCredentials];
}

@end
