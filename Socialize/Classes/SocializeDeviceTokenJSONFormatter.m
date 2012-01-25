//
//  SocializeDeviceTokenJSONFormatter.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/12/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeDeviceTokenJSONFormatter.h"
#import "SocializeDeviceToken.h"
#import "SocializeApplication.h"
#import "SocializeObjectFactory.h"
@implementation SocializeDeviceTokenJSONFormatter

-(void)doToObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary {
    if (toObject == nil || JSONDictionary == nil ) {
        return;
    }
    id<SocializeDeviceToken> deviceToken = (id<SocializeDeviceToken>)toObject;

    [deviceToken setDevice_token:[JSONDictionary objectForKey:@"device_token"]];
    [deviceToken setDevice_alias:[JSONDictionary objectForKey:@"device_alias"]];

    [deviceToken setApplication: [_factory createObjectFromDictionary:[JSONDictionary objectForKey:@"application"] 
                                                          forProtocol:@protocol(SocializeApplication)] ];
    [deviceToken setUser: [_factory createObjectFromDictionary:[JSONDictionary objectForKey:@"user"] 
                                                   forProtocol:@protocol(SocializeUser)]];
}
@end
