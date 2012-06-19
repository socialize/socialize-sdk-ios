//
//  SocializeNotificationService.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/7/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//
#import "SocializeDeviceTokenService.h"
#import "SocializeRequest.h"
#import "SocializeDeviceToken.h"
#import "Socialize.h"

#define SOCIALIZE_USER_DEVICE_METHOD @"user/device/"

@implementation SocializeDeviceTokenService

- (void)registerDeviceTokens:(NSArray *)tokens {
    NSMutableArray *params = [NSMutableArray array];
    for ( NSString *token in tokens ) {
        NSDictionary *deviceToken = [NSDictionary dictionaryWithObjectsAndKeys:
                                     token, @"device_token",
                                     @"iOS", @"device_type",
                                     nil];
        [params addObject:deviceToken];
       
    }
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"POST"
                               resourcePath:SOCIALIZE_USER_DEVICE_METHOD
                         expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                     params:params];
    [self executeRequest:request];
}

- (void)registerDeviceTokenString:(NSString *)deviceToken {
    [self registerDeviceTokens:[NSArray arrayWithObject:deviceToken]];
}

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeDeviceToken);
}

@end
