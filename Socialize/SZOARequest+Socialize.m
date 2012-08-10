//
//  SZOARequest+Socialize.m
//  Socialize
//
//  Created by Nathaniel Griswold on 8/8/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZOARequest+Socialize.h"
#import "Socialize.h"
#import <JSONKit/JSONKit.h>

@implementation SZOARequest (Socialize)

+ (SZOARequest*)socializeRequestWithMethod:(NSString*)method
                                      path:(NSString*)path
                                parameters:(NSDictionary*)parameters
                                   success:(void(^)(id result))success
                                   failure:(void(^)(NSError *error))failure {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:kSocializeAccessToken];
    NSString *accessTokenSecret = [defaults objectForKey:kSocializeAccessTokenSecret];
    NSString *consumerKey = [defaults objectForKey:kSocializeConsumerKey];
    NSString *consumerSecret = [defaults objectForKey:kSocializeConsumerSecret];
    
    NSString *credentialsMessage = @"Tried to make Socialize request without existing credentials";
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
                                                               host:@"api.getsocialize.com"
                                                               path:path
                                                         parameters:parameters
                                                            success:^(NSURLResponse *response, NSData *data) {
                                                                BLOCK_CALL_1(success, [data objectFromJSONData]);
                                                            }
                                                            failure:failure];
    
    return request;
}

@end
