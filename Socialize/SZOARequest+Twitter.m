//
//  SZOARequest+Twitter.m
//  Socialize
//
//  Created by Nathaniel Griswold on 7/12/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZOARequest+Twitter.h"
#import "SZTwitterUtils.h"
#import <JSONKit/JSONKit.h>

@implementation SZOARequest (Twitter)

+ (SZOARequest*)twitterRequestWithMethod:(NSString*)method
                                    path:(NSString*)path
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
    
    SZOARequest *request = [[SZOARequest alloc] initWithConsumerKey:consumerKey
                                                     consumerSecret:consumerSecret
                                                              token:accessToken
                                                        tokenSecret:accessTokenSecret
                                                             method:method
                                                             scheme:@"http"
                                                               host:@"api.twitter.com"
                                                               path:path
                                                         parameters:parameters
                                                            success:^(NSURLResponse *response, NSData *data) {
                                                                BLOCK_CALL_1(success, [data objectFromJSONData]);
                                                            }
                                                            failure:failure];
    
    return request;
}

@end
