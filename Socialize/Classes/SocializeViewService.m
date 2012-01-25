//
//  SocializeViewService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeViewService.h"

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
    [self createViewForEntityKey:[entity key] longitude:lng latitude:lat];
}

-(void)createViewForEntityKey:(NSString*)key longitude:(NSNumber*)lng latitude: (NSNumber*)lat{
    
    if (key && [key length]){   
        NSMutableDictionary* entityParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:key, @"entity_key", nil];
        
        if (lng!= nil && lat != nil)
        {
            [entityParam setObject:lng forKey:@"lng"];
            [entityParam setObject:lat forKey:@"lat"];
        }
        
        NSArray *params = [NSArray arrayWithObject:entityParam];
        [self executeRequest:
         [SocializeRequest requestWithHttpMethod:@"POST"
                                    resourcePath:VIEW_METHOD
                              expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                          params:params]
         ];

    }
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
