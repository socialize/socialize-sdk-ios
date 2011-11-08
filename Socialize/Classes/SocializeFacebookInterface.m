
//
//  SocializeFacebookInterface.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/31/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeFacebookInterface.h"
#import "Facebook+Socialize.h"

typedef void (^RequestCompletionBlock)(id result, NSError *error);

@implementation SocializeFacebookInterface
@synthesize facebook = facebook_;
@synthesize handlers = handlers_;

- (void)dealloc {
    self.facebook = nil;
    
    [super dealloc];
}

- (SocializeFacebook*)facebook {
    if (facebook_ == nil) {
        facebook_ = [[SocializeFacebook facebookFromSettings] retain];
    }
    
    return facebook_;
}

- (NSMutableDictionary*)handlers {
    if (handlers_ == nil) handlers_ = [NSMutableDictionary new];
    return handlers_;
}

- (NSValue*)requestIdentifier:(SocializeFBRequest*)request {
    return [NSValue valueWithPointer:request];
}

- (void)removeHandlerForRequest:(SocializeFBRequest*)request {
    NSValue *requestId = [self requestIdentifier:request];
    if ([self.handlers objectForKey:requestId]) {
        [self.handlers removeObjectForKey:requestId];
    }
}

- (void)copyDefaultsToFacebookObject {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
}

- (void)requestWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params httpMethod:(NSString*)httpMethod completion:(void (^)(id result, NSError *error))completion {
    [self copyDefaultsToFacebookObject];
    SocializeFBRequest *request = [self.facebook requestWithGraphPath:graphPath andParams:[[params mutableCopy] autorelease] andHttpMethod:httpMethod andDelegate:self];
    NSValue *requestId = [self requestIdentifier:request];
    NSAssert([self.handlers objectForKey:requestId] == nil, @"Key for request %@ already exists (should be nil)", requestId);
    
    if (completion != nil) {
        [self.handlers setObject:[[completion copy] autorelease] forKey:requestId];
    }
}

- (void)request:(SocializeFBRequest *)request didFailWithError:(NSError *)error {
    RequestCompletionBlock completionBlock = [self.handlers objectForKey:[self requestIdentifier:request]];
    completionBlock(nil, error);
    [self removeHandlerForRequest:request];
}

- (void)request:(SocializeFBRequest *)request didLoad:(id)result {
    RequestCompletionBlock completionBlock = [self.handlers objectForKey:[self requestIdentifier:request]]; 
    completionBlock(result, nil);
    [self removeHandlerForRequest:request];
}

@end
