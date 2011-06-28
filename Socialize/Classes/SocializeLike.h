//
//  SocializeLike.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/22/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObject.h"
#import "SocializeApplication.h"
#import "SocializeUser.h"
#import "SocializeEntity.h"


@protocol SocializeLike <SocializeObject>

@required

-(id<SocializeApplication>)application;
-(void)setApplication:(id<SocializeApplication>)application;

-(id<SocializeEntity>)entity;
-(void)setEntity:(id<SocializeEntity>)entity;

-(id<SocializeUser>)user;
-(void)setUser:(id<SocializeUser>)user;

-(float_t)lat;
-(void)setLat:(float_t)lat;

-(float_t)lng;
-(void)setLng:(float_t)lng;

-(NSDate *)date;
-(void)setDate:(NSDate *)date;

@end


@interface SocializeLike : SocializeObject <SocializeLike>
{
@private
    id<SocializeApplication> _application;
    id<SocializeEntity>      _entity;
    id<SocializeUser>        _user;
    float_t                  _lat;
    float_t                  _lng;
    NSDate*                  _date;
}

@property (nonatomic, retain) id<SocializeApplication> application;
@property (nonatomic, retain) id<SocializeEntity>      entity;
@property (nonatomic, retain) id<SocializeUser>        user;

@property (nonatomic, assign) float_t           lat;
@property (nonatomic, assign) float_t           lng;
@property (nonatomic, retain) NSDate*           date;

@end
