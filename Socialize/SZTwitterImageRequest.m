//
//  SZSTTwitterRequest.m
//  Socialize
//
//  Created by David Jedeikin on 9/9/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import "SZTwitterImageRequest.h"
#import "SZTwitterUtils.h"
#import "NSError+Socialize.h"
#import <SZJSONKit/JSONKit.h>

@implementation SZTwitterImageRequest

@synthesize params = _params;
@synthesize successBlock = _successBlock;
@synthesize failureBlock = _failureBlock;
@synthesize twitter = _twitter;

+ (SZTwitterImageRequest *)twitterRequestWithMethod:(NSString*)method
                                         parameters:(NSDictionary*)parameters
                                            success:(void(^)(id result))success
                                            failure:(void(^)(NSError *error))failure {
    
    NSString *accessToken = [SZTwitterUtils accessToken];
    NSString *accessTokenSecret = [SZTwitterUtils accessTokenSecret];
    NSString *consumerKey = [SZTwitterUtils consumerKey];
    NSString *consumerSecret = [SZTwitterUtils consumerSecret];
    
    NSString *credentialsMessage = @"Tried to make twitter request without existing credentials";
    NSAssert(accessToken != nil, credentialsMessage);
    NSAssert(accessTokenSecret != nil, credentialsMessage);
    NSAssert(consumerKey != nil, credentialsMessage);
    NSAssert(consumerSecret != nil, credentialsMessage);
    
    SZTwitterImageRequest *request = [[SZTwitterImageRequest alloc] initWithConsumerKey:consumerKey
                                                                         consumerSecret:consumerSecret
                                                                                  token:accessToken
                                                                            tokenSecret:accessTokenSecret
                                                                             parameters:parameters
                                                                                success:success
                                                                                failure:failure];
    
    return request;
}

//default constructor
- (id)initWithConsumerKey:(NSString*)consumerKey
           consumerSecret:(NSString*)consumerSecret
                    token:(NSString*)token
              tokenSecret:(NSString*)tokenSecret
               parameters:(NSDictionary*)parameters
                  success:(void(^)(id result))success
                  failure:(void(^)(NSError *error))failure {
    
    if (self = [super init]) {
        self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerKey
                                                     consumerSecret:consumerSecret
                                                         oauthToken:token
                                                   oauthTokenSecret:tokenSecret];
        self.successBlock = success;
        self.failureBlock = failure;
        self.params = parameters;
    }
    return self;
}

- (void)start {
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = (NSData *)[self.params objectForKey:@"media[]"];
        NSString *statusUpdate = (NSString *)[self.params objectForKey:@"status"];
        
        [self.twitter postStatusUpdate:statusUpdate
                        mediaDataArray:@[data]
                     possiblySensitive:nil
                     inReplyToStatusID:nil
                              latitude:nil
                             longitude:nil
                               placeID:nil
                    displayCoordinates:nil
                   uploadProgressBlock:nil
                          successBlock:^(NSDictionary *status) {
                              BLOCK_CALL_1(self.successBlock, status);
                          }
                            errorBlock:^(NSError *error) {
                                BLOCK_CALL_1(self.failureBlock, error);
                            }];
    });
}

- (void)cancel {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isExecuting]) {
            self.executing = NO;
        }
        
        if (![self isFinished]) {
            self.finished = YES;
            NSError *error = [NSError defaultSocializeErrorForCode:SocializeErrorRequestCancelled];
            BLOCK_CALL_1(self.failureBlock, error);
        }
    });
    
    [super cancel];
}

@end
