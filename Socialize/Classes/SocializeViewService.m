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

-(void)createViewForEntity:(id<SocializeEntity>)entity{
    [self createViewForEntityKey:[entity key]];
}

-(void)createViewForEntityKey:(NSString*)key{
    
    if (key && [key length]){   
        NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:key, @"entity_key", nil];
        NSArray *params = [NSArray arrayWithObjects:entityParam, 
                           nil];
        [_provider requestWithMethodName:VIEW_METHOD andParams:params expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:self];
    }
}

@end
