
//
//  SocializeFacebookInterface.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/31/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeFacebookInterface.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeFacebook.h"

typedef void (^RequestCompletionBlock)(id result, NSError *error);

@interface SocializeFacebookInterface () <SocializeFBRequestDelegate>
@end

@implementation SocializeFacebookInterface
@synthesize facebook = facebook_;
@synthesize handlers = handlers_;

- (void)dealloc {
    self.facebook = nil;
    self.handlers = nil;
    
    [super dealloc];
}

- (SocializeFacebook*)facebook {
    if (facebook_ == nil) {
        facebook_ = [[SocializeThirdPartyFacebook createFacebookClient] retain];
    }
    
    return facebook_;
}

- (NSMutableDictionary*)handlers {
    if (handlers_ == nil) handlers_ = [[NSMutableDictionary alloc] init];
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

- (void)requestWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params httpMethod:(NSString*)httpMethod completion:(void (^)(id result, NSError *error))completion {
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    SocializeFBRequest *request = [self.facebook requestWithGraphPath:graphPath andParams:[[params mutableCopy] autorelease] andHttpMethod:httpMethod andDelegate:self];
    NSValue *requestId = [self requestIdentifier:request];
    NSAssert([self.handlers objectForKey:requestId] == nil, @"Key for request %@ already exists (should be nil)", requestId);
    
    if (completion != nil) {
        [self.handlers setObject:[[completion copy] autorelease] forKey:requestId];
    }
}

- (void)request:(SocializeFBRequest *)request didFailWithError:(NSError *)error {
    DebugLog(@"Facebook Wall Post Failed! Description: %@", [error localizedDescription]);
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
