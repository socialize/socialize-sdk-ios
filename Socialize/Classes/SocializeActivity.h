//
//  Activity.h
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeEntity.h"
#import "SocializeObject.h"
#import "SocializeApplication.h"
#import "SocializeUser.h"

/**
 in progress
 */
@protocol SocializeActivity <SocializeObject>

@required

//This style is used to surpress GCC warnings for derived classes.
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


-(NSDate *)date;
-(void)setDate:(NSDate *)date;

@end

@interface SocializeActivity : SocializeObject <SocializeActivity>
{
    @private
        id<SocializeApplication> _application;
        id<SocializeEntity>      _entity;
        id<SocializeUser>        _user;
        NSNumber*           _lat;
        NSNumber*           _lng;
        NSDate*           _date;
        
}

@property (nonatomic, retain) id<SocializeApplication> application;
@property (nonatomic, retain) id<SocializeEntity>      entity;
@property (nonatomic, retain) id<SocializeUser>        user;

@property (nonatomic, assign) NSNumber*           lat;
@property (nonatomic, assign) NSNumber*           lng;
@property (nonatomic, retain) NSDate*           date;

@end
