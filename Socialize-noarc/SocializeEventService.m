//
//  SocializeEventService.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/28/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeEventService.h"
#import <Socialize/Socialize.h>

#define EVENT_METHOD @"private/sdk_event/"

@implementation SocializeEventService

//- (Protocol *)ProtocolType
//{
//    return  @protocol(SocializeSubscription);
//}
//

- (void)trackEventWithBucket:(NSString*)bucket values:(NSDictionary*)values success:(void(^)(id result))success failure:(void(^)(NSError *error))failure {

    const char *disabled = getenv("SZEventTrackingDisabled");
    if (disabled != NULL && strncmp("1", disabled, 1) == 0) {
        return;
    }
    
    if (values == nil) {
        values = [NSDictionary dictionary];
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            bucket, @"bucket",
                            values, @"values",
                            nil];
    
    SocializeRequest *request =      [SocializeRequest requestWithHttpMethod:@"POST"
                                                                resourcePath:EVENT_METHOD
                                                          expectedJSONFormat:SocializeAny
                                                                      params:params];
    request.successBlock = success;
    request.failureBlock = failure;

    [self executeRequest:request];
}

- (void)trackEventWithBucket:(NSString*)bucket values:(NSDictionary*)values {
    [self trackEventWithBucket:bucket values:values success:nil failure:nil];
}

@end
