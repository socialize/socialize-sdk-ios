//
//  SocializeDeviceToken.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/12/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeDeviceToken.h"

@implementation SocializeDeviceToken


@synthesize application = application_;
@synthesize user = user_;
@synthesize device_alias = device_alias_;
@synthesize device_token = device_token_;


-(void)dealloc
{
    self.application = nil;
    self.user = nil;
    self.device_alias = nil;
    self.device_token = nil;
    [super dealloc];
}
@end
