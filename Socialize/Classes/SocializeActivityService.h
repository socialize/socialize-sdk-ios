//
//  SocializeActivityService.h
//  SocializeSDK
//
//  Created by William Johnson on 6/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeService.h"
#import "SocializeCommonDefinitions.h"

@protocol SocializeUser;

@interface SocializeActivityService : SocializeService 
{
}

-(void) getActivityOfCurrentApplication;
-(void) getActivityOfCurrentApplicationWithFirst:(NSNumber*)first last:(NSNumber*)last;
-(void) getActivityOfUser:(id<SocializeUser>)user;
-(void) getActivityOfUser:(id<SocializeUser>)user first: (NSNumber*)first last:(NSNumber*)last activity: (SocializeActivityType) type;
-(void) getActivityOfUserId:(NSInteger)userId first: (NSNumber*)first last:(NSNumber*)last activity: (SocializeActivityType) type;
-(void) getActivityOfUserId:(NSInteger)userId;
@end
