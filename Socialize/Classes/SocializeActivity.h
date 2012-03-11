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
 Base protocol for any Socialize activity such as comment, view, like.
 */
@protocol SocializeActivity <SocializeObject>

@required

/**@name Application*/

/**
 Get <SocializeApplication>.
 */
-(id<SocializeApplication>)application;
/**
 Set <SocializeApplication>
 @param application Socialize application object.
 */
-(void)setApplication:(id<SocializeApplication>)application;

/**@name Entity*/
/**
 Get <SocializeEntity>.
 */
-(id<SocializeEntity>)entity;

/**
 Set entity object.
 @param entity <SocializeEntity> for activity.
 */
-(void)setEntity:(id<SocializeEntity>)entity;

/**@name User*/
/**
 Get <SocializeUser>.
 */
-(id<SocializeUser>)user;
/**
 Set <SocializeUser>.
 @param user Socialize user object.
 */
-(void)setUser:(id<SocializeUser>)user;

/**Activity*/
/**
 Get latitude of activity.
 */
-(NSNumber*)lat;

/**
 Set latitude for activity.
 @param lat Latitude.
 */
-(void)setLat:(NSNumber*)lat;

/**
 Get longitude of activity.
 */
-(NSNumber*)lng;

/**
 Set longitude for activity.
 @param lng Longitude.
 */
-(void)setLng:(NSNumber*)lng;

/**
 Get activity's date.
 */
-(NSDate *)date;

/**
 Set date for activity.
 @param date Date of activity.
 */
-(void)setDate:(NSDate *)date;

/**
 Third party destinations
 */
-(NSString *)thirdParties;

/**
 Third party propagation targets
 @param thirdParties
 */
-(void)setThirdParties:(NSArray*)thirdParties;

@end

/**Private implementation of <SocializeActivity> protocol*/
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

/** Set\get <SocializeApplication> object.*/
@property (nonatomic, retain) id<SocializeApplication> application;
/** Set\get <SocializeEntity> object.*/
@property (nonatomic, retain) id<SocializeEntity>      entity;
/** Set\get <SocializeUser> object.*/
@property (nonatomic, retain) id<SocializeUser>        user;

/** Set\get latitude of activity.*/
@property (nonatomic, retain) NSNumber*           lat;
/** Set\get logitude of activity.*/
@property (nonatomic, retain) NSNumber*           lng;
/** Set\get date of activity.*/
@property (nonatomic, retain) NSDate*           date;

/* Text to be sent to twitter */
@property (nonatomic, copy) NSArray *thirdParties;

@end
