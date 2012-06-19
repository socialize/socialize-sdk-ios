//
//  SocializeSubscription.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeObject.h"
#import "SocializeEntity.h"
#import "SocializeUser.h"

/**
 Protocol for socialize entity representation.
 */
@protocol SocializeSubscription <SocializeObject>

@required

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

/**@name Subscribed*/
/**
 Get subscribed (YES or NO).
 */
-(BOOL)subscribed;

/**
 Set subscribed state
 @param subscribed whether or not the subscription is active
 */
-(void)setSubscribed:(BOOL)subscribed;

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

/**
 Get date of subscription
 */
-(NSDate *)date;

/**
 Set date for subscription.
 @param date Date of subscription.
 */
-(void)setDate:(NSDate *)date;

/**
 Get type of subscription
 */
-(NSString *)type;

/**
 Set type for subscription.
 @param type Type of subscription.
 */
-(void)setType:(NSString *)type;


@end

/**Private implementation of <SocializeSubscription> protocol*/
@interface SocializeSubscription : SocializeObject <SocializeSubscription>

+ (SocializeSubscription*)subscriptionWithEntity:(id<SocializeEntity>)entity type:(NSString*)type subscribed:(BOOL)subscribed;

/** Set\get <SocializeEntity> object.*/
@property (nonatomic, retain) id<SocializeEntity>      entity;
/** Set\get <SocializeUser> object.*/
@property (nonatomic, retain) id<SocializeUser>        user;

@property (nonatomic, retain) NSDate*           date;

@property (nonatomic, assign) BOOL subscribed;

@property (nonatomic, copy) NSString * type;

@end
