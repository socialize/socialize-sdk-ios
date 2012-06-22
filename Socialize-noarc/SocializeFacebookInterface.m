
//
//  SocializeFacebookInterface.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/31/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeFacebookInterface.h"
#import "SocializeThirdPartyFacebook.h"

static SocializeFacebookInterface *sharedFacebookInterface;

typedef void (^RequestCompletionBlock)(id result, NSError *error);

@interface SocializeFacebookInterface () <FBRequestDelegate>
@end

@implementation SocializeFacebookInterface
@synthesize facebook = facebook_;
@synthesize handlers = handlers_;

+ (SocializeFacebookInterface*)sharedFacebookInterface {
    if (sharedFacebookInterface == nil) {
        sharedFacebookInterface = [[SocializeFacebookInterface alloc] init];
    }
    
    return sharedFacebookInterface;
}

- (void)dealloc {
    self.facebook = nil;
    self.handlers = nil;
    
    [super dealloc];
}

- (Facebook*)facebook {
    if (facebook_ == nil) {
        facebook_ = [[SocializeThirdPartyFacebook createFacebookClient] retain];
        facebook_.sessionDelegate = self;
    }
    
    return facebook_;
}

- (NSMutableDictionary*)handlers {
    if (handlers_ == nil) handlers_ = [[NSMutableDictionary alloc] init];
    return handlers_;
}

- (NSValue*)requestIdentifier:(FBRequest*)request {
    return [NSValue valueWithPointer:request];
}

- (void)removeHandlerForRequest:(FBRequest*)request {
    NSValue *requestId = [self requestIdentifier:request];
    if ([self.handlers objectForKey:requestId]) {
        [self.handlers removeObjectForKey:requestId];
    }
}

- (void)requestWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params httpMethod:(NSString*)httpMethod completion:(void (^)(id result, NSError *error))completion {
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    FBRequest *request = [self.facebook requestWithGraphPath:graphPath andParams:[[params mutableCopy] autorelease] andHttpMethod:httpMethod andDelegate:self];
    NSValue *requestId = [self requestIdentifier:request];
    NSAssert([self.handlers objectForKey:requestId] == nil, @"Key for request %@ already exists (should be nil)", requestId);
    
    if (completion != nil) {
        [self.handlers setObject:[[completion copy] autorelease] forKey:requestId];
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    DebugLog(@"Facebook Wall Post Failed! Description: %@", [error localizedDescription]);
    RequestCompletionBlock completionBlock = [self.handlers objectForKey:[self requestIdentifier:request]];
    completionBlock(nil, error);
    [self removeHandlerForRequest:request];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    RequestCompletionBlock completionBlock = [self.handlers objectForKey:[self requestIdentifier:request]]; 
    completionBlock(result, nil);
    [self removeHandlerForRequest:request];
}

- (void)fbDidLogin {
    // Unused here    
}

- (void)fbDidLogout {
    // Unused here    
}

- (void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    [SocializeThirdPartyFacebook storeLocalCredentialsWithAccessToken:accessToken expirationDate:expiresAt];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    // Unused here
}

- (void)fbSessionInvalidated {
    [SocializeThirdPartyFacebook removeLocalCredentials];
}

@end
