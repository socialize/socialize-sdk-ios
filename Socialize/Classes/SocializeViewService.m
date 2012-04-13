//
//  SocializeViewService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeViewService.h"
#import "SocializeEntity.h"

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

-(void)createViewForEntity:(id<SocializeEntity>)entity longitude:(NSNumber*)lng latitude: (NSNumber*)lat{
    SocializeView *view = [SocializeView viewWithEntity:entity];
    view.lng = lng;
    view.lat = lat;
    
    [self createView:view];
}

-(void)createViewForEntityKey:(NSString*)key longitude:(NSNumber*)lng latitude: (NSNumber*)lat {
    SocializeEntity *entity = [SocializeEntity entityWithKey:key name:nil];
    [self createViewForEntity:entity longitude:lng latitude:lat];
}

- (void)createViews:(NSArray*)views {
    NSArray *params = [_objectCreator createDictionaryRepresentationArrayForObjects:views];
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"POST"
                                resourcePath:VIEW_METHOD
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]
     ];
}

- (void)createView:(id<SocializeView>)view {
    [self createViews:[NSArray arrayWithObject:view]];
}

/*
-(void)getViewsForEntityKey:(NSString*)key first:(NSNumber*)first last:(NSNumber*)last{
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease]; 
    if (key)
        [params setObject:key forKey:@"entity_key"];
    if (first && last){
        [params setObject:first forKey:@"first"];
        [params setObject:last forKey:@"last"];
    }
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:VIEW_METHOD
                          expectedJSONFormat:SocializeDictionaryWIthListAndErrors
                                      params:params]
     ];
}
*/


@end
