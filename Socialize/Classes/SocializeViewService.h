//
//  SocializeViewService.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeView.h"
#import "SocializeRequest.h"
#import "SocializeViewService.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeObjectFactory.h"
#import "SocializeService.h"

/**
 Socialize view service is the view creation engine.
 */
@interface SocializeViewService : SocializeService {

}

- (void)createViews:(NSArray*)views success:(void(^)(NSArray *views))success failure:(void(^)(NSError *error))failure;
- (void)createView:(id<SZView>)view success:(void(^)(id<SZView>))success failure:(void(^)(NSError *error))failure;
- (void)createViews:(NSArray*)views;
- (void)createView:(id<SocializeView>)view;

/**@name Create view*/

/**
 This method creates view for entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param key Entity's URL which should be marked as viewed.
 @param lng Longitude *float* value. Could be nil. (OPTIONAL)
 @param lat Latitude  *float* value. Could be nil. (OPTIONAL)
 */
-(void)createViewForEntityKey:(NSString*)key longitude:(NSNumber*)lng latitude: (NSNumber*)lat;

/**
 This method creates view for entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param entity <SocializeEntity> object which should be marked as viewed.
 @param lng Longitude *float* value. Could be nil. (OPTIONAL)
 @param lat Latitude  *float* value. Could be nil. (OPTIONAL)
 */
-(void)createViewForEntity:(id<SocializeEntity>)entity longitude:(NSNumber*)lng latitude: (NSNumber*)lat;

/**
 Get views on the given entity key
 
 @param key Entity URL.
 @param first The first view object to get. (OPTIONAL)
 @param last The last view object to get. (OPTIONAL)
 */
//-(void)getViewsForEntityKey:(NSString*)key first:(NSNumber*)first last:(NSNumber*)last;


@end