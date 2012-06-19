//
//  SocializeFacebookAuthHandler.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//
// This file handles basic facebook auth flow to get a token and expiration date, and nothing more

#import "SocializeFacebookAuthHandler.h"
#import <facebook-ios-sdk/FBConnect.h>
#import "SocializeCommonDefinitions.h"
#import "SocializePreprocessorUtilities.h"

static SocializeFacebookAuthHandler *sharedFacebookAuthHandler;

@implementation SocializeFacebookAuthHandler
@synthesize permissions = permissions_;
@synthesize successBlock = successBlock_;
@synthesize failureBlock = failureBlock_;
@synthesize facebook = facebook_;
@synthesize authenticating = authenticating_;

- (void)dealloc {
    self.permissions = nil;
    self.successBlock = nil;
    self.failureBlock = nil;
    self.facebook = nil;
    
    [super dealloc];
}

+ (SocializeFacebookAuthHandler*)sharedFacebookAuthHandler {
    if (sharedFacebookAuthHandler == nil) {
        sharedFacebookAuthHandler = [[SocializeFacebookAuthHandler alloc] init];
    }
    
    return sharedFacebookAuthHandler;
}

- (void)failWithError:(NSError*)error {
    if (self.failureBlock != nil) {
        self.failureBlock(error);
    }
}


- (void)authenticateWithAppId:(NSString*)appId
              urlSchemeSuffix:(NSString*)urlSchemeSuffix
                  permissions:(NSArray*)permissions
                      success:(void(^)())success
                      failure:(void(^)(NSError*))failure {
    
    self.authenticating = YES;
    self.facebook = [[[Facebook alloc] initWithAppId:appId urlSchemeSuffix:urlSchemeSuffix andDelegate:self] autorelease];
    self.permissions = permissions;
    self.successBlock = success;
    self.failureBlock = failure;
    [self.facebook authorize:self.permissions];
}

- (BOOL)handleOpenURL:(NSURL*)url {
    return [self.facebook handleOpenURL:url];
}

- (void)fbDidLogin {
    self.authenticating = NO;
    
    self.successBlock([self.facebook accessToken], [self.facebook expirationDate]);
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    self.authenticating = NO;
    
    [self failWithError:[NSError defaultSocializeErrorForCode:SocializeErrorFacebookCancelledByUser]];
}

@end
