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

@synthesize propagation = _propagation;
@synthesize propagationInfoRequest = _propagationInfoRequest;
@synthesize propagationInfoResponse = _propagationInfoResponse;

-(void)dealloc
{
    [_application release];
    [_entity release];
    [_user release];
    [_lat release];
    [_lng release];
    [_date release];
    [_propagation release];
    [_propagationInfoRequest release];
    [_propagationInfoResponse release];
    [super dealloc];
}

@end
