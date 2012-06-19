//
//  SocializeApplication.m
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeApplication.h"


@implementation SocializeApplication

@synthesize name = _name;

-(void)dealloc
{
    [_name release];
    [super dealloc];
}

@end
