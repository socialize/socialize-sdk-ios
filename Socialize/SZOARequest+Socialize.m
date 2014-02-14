//
//  SZOARequest+Socialize.m
//  Socialize
//
//  Created by Nathaniel Griswold on 8/8/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZOARequest+Socialize.h"
#import "Socialize.h"
//#import <JSONKit/JSONKit.h>
#import <SZJSONKit/JSONKit.h>

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
    
    // This is what the Socialize API wants
    if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"]) {
        parameters = [NSDictionary dictionaryWithObject:parameters forKey:@"payload"];
    }
    
    SZOARequest *request = [[SZOARequest alloc] initWithConsumerKey:consumerKey
                                                     consumerSecret:consumerSecret
                                                              token:accessToken
                                                        tokenSecret:accessTokenSecret
                                                             method:method
                                                             scheme:@"http"
                                                               host:@"api.getsocialize.com"
                                                               path:path
                                                         parameters:parameters
                                                          multipart:NO
                                                            success:^(NSURLResponse *response, NSData *data) {
                                                                NSDictionary *dictionary = [data objectFromJSONData];
                                                                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                
                                                                if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
                                                                    BLOCK_CALL_1(failure, [NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Not a dictionary"]);
                                                                    return;
                                                                }
                                                                                                                                
                                                                BLOCK_CALL_1(success, [dictionary objectForKey:@"items"]);
                                                            }
                                                            failure:failure];
    
    return request;
}

@end
