//
//  SocializeViewService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeViewService.h"
#import "SocializeEntity.h"
#import "socialize_globals.h"
#import "SZAPIClientHelpers.h"

#define VIEW_METHOD @"view/"
#define ENTRY_KEY @"key"
#define ENTITY_KEY @"entity"

@implementation SocializeViewService


-(void) dealloc
{
    [super dealloc];
}

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeView);
}

- (void)callViewPostWithParams:(id)params success:(void(^)(NSArray *views))success failure:(void(^)(NSError *error))failure {
    [self callEndpointWithPath:VIEW_METHOD method:@"POST" params:params success:^(NSArray *views) {
        SZPostActivityEntityDidChangeNotifications(views);
        BLOCK_CALL_1(success, views);
    } failure:failure];
}

- (void)createViews:(NSArray*)views success:(void(^)(NSArray *views))success failure:(void(^)(NSError *error))failure {
    NSArray *params = [_objectCreator createDictionaryRepresentationArrayForObjects:views];
    [self callViewPostWithParams:params success:success failure:failure];
}

- (void)createView:(id<SZView>)view success:(void(^)(id<SZView>))success failure:(void(^)(NSError *error))failure {
    [self createViews:[NSArray arrayWithObject:view] success:^(NSArray *views) {
        BLOCK_CALL_1(success, [views objectAtIndex:0]);
    } failure:failure];
}

- (void)createView:(id<SocializeView>)view {
    [self createView:view success:nil failure:nil];
}

- (void)createViews:(NSArray*)views {
    [self createViews:views success:nil failure:nil];
}

-(void)createViewForEntity:(id<SocializeEntity>)entity longitude:(NSNumber*)lng latitude: (NSNumber*)lat{
    SZView *view = [SZView viewWithEntity:entity];
    view.lat = lat;
    view.lng = lng;
    
    [self createView:view];
}

-(void)createViewForEntityKey:(NSString*)key longitude:(NSNumber*)lng latitude: (NSNumber*)lat {
    SocializeEntity *entity = [SocializeEntity entityWithKey:key name:nil];
    [self createViewForEntity:entity longitude:lng latitude:lat];
}


@end
