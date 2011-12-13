//
//  SocializeNotificationService.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/7/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#define USER_DEVICE_METHOD @"user/device/"
#import "SocializeDeviceTokenService.h"
#import "SocializeRequest.h"
#import "SocializeDeviceToken.h"

@implementation SocializeDeviceTokenService

-(void)registerDeviceTokens:(NSArray *) tokens {
    NSMutableArray *params = [NSMutableArray array];
    for ( NSString *token in tokens ) {
        NSDictionary *deviceToken = [NSDictionary dictionaryWithObject:token forKey:@"device_token"];
        [params addObject:deviceToken];
       
    }
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"POST"
                               resourcePath:USER_DEVICE_METHOD
                         expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                     params:params];
    [self executeRequest:request];
}
-(void)registerDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenStr = [[[[deviceToken description]
                     stringByReplacingOccurrencesOfString: @"<" withString: @""]
                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                   stringByReplacingOccurrencesOfString: @" " withString: @""];
    [self registerDeviceTokens:[NSArray arrayWithObjects:deviceTokenStr, nil]];
}
-(Protocol *)ProtocolType
{
    return  @protocol(SocializeDeviceToken);
}

@end
