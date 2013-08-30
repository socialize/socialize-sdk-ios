//
//  SocializeUser.m
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeUser.h"
#import "UserHelper.h"

@implementation SocializeUser

@synthesize firstName = _firstName;
@synthesize lastName =  _lastName;
@synthesize userName = _userName;
@synthesize displayName;
@synthesize smallImageUrl = _smallInageUrl;
@synthesize city = _city;
@synthesize state = _state;
@synthesize meta = _meta;

@synthesize thirdPartyAuth = _thirdPartyAuth;

-(NSString*)displayName {
    return [UserHelper getDisplayName:self.userName firstName:self.firstName lastName:self.lastName];
}

-(void)dealloc
{
    [_firstName release];
    [_lastName release];
    [_userName release];
    [_smallInageUrl release];
    [_city release];
    [_state release];
    [_meta release];
    [_thirdPartyAuth release];
    [super dealloc];
}

@end
