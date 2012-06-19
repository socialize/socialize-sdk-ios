//
//  SocializeError.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/5/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeError.h"


@implementation SocializeError

@synthesize error = _error, payload = _payload;

-(void)dealloc
{
    [_error release];
    [_payload release];
    [super dealloc];
}

@end
