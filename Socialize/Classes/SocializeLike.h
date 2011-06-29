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

-(NSNumber*)lat;
-(void)setLat:(NSNumber*)lat;

-(NSNumber*)lng;
-(void)setLng:(NSNumber*)lng;

@end


@interface SocializeLike : SocializeObject <SocializeLike>
{
@private
    id<SocializeApplication> _application;
    id<SocializeEntity>      _entity;
    id<SocializeUser>        _user;
    NSNumber*                _lat;
    NSNumber*                _lng;
}

@property (nonatomic, retain) id<SocializeApplication> application;
@property (nonatomic, retain) id<SocializeEntity>      entity;
@property (nonatomic, retain) id<SocializeUser>        user;

@property (nonatomic, assign) NSNumber*           lat;
@property (nonatomic, assign) NSNumber*           lng;

@end
