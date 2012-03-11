//
//  Activity.m
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeActivity.h"


@implementation SocializeActivity

@synthesize  application = _application;
@synthesize  entity = _entity;
@synthesize  user = _user;

@synthesize  lat = _lat;
@synthesize  lng = _lng;
@synthesize  date = _date;

@synthesize thirdParties = _thirdParties;

-(void)dealloc
{
    [_application release];
    [_entity release];
    [_user release];
    [_lat release];
    [_lng release];
    [_date release];
    [_thirdParties release];
    [super dealloc];
}

@end
