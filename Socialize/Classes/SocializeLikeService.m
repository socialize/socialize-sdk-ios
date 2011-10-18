//
//  SocializeLikeService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/22/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeLikeService.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeLike.h"
#import "SocializeObjectFactory.h"
#import "SocializeEntity.h"


#define LIKE_METHOD @"like/"
#define ENTRY_KEY @"key"
#define ENTITY_KEY @"entity"
#define LIKES_METHOD @"like/"


@interface SocializeLikeService()
@end

@implementation SocializeLikeService



-(void) dealloc
{
    [super dealloc];
}
 
-(Protocol *)ProtocolType
{
    return  @protocol(SocializeLike);
}

-(void)postLikeForEntity:(id<SocializeEntity>)entity andLongitude:(NSNumber*)lng latitude: (NSNumber*)lat
{
    [self postLikeForEntityKey:[entity key] andLongitude:lng latitude:lat];
}

-(void)postLikeForEntityKey:(NSString*)key andLongitude:(NSNumber*)lng latitude: (NSNumber*)lat
{
    if (key && [key length]){   
        NSDictionary* entityParam = nil;
        if (lng!= nil && lat != nil)
            entityParam = [NSDictionary dictionaryWithObjectsAndKeys:key, @"entity_key", lng, @"lng", lat, @"lat", nil];
        else
            entityParam = [NSDictionary dictionaryWithObjectsAndKeys:key, @"entity_key", nil];
        
        NSArray *params = [NSArray arrayWithObjects:entityParam, 
                           nil];
        [self executeRequest:
         [SocializeRequest requestWithHttpMethod:@"POST"
                                    resourcePath:LIKE_METHOD
                              expectedJSONFormat:SocializeDictionaryWIthListAndErrors
                                          params:params]
         ];

    }
}

-(void)deleteLike:(id<SocializeLike>)like{
    if ([like conformsToProtocol:@protocol(SocializeLike)]){
        NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease];
        [params setObject:[NSNumber numberWithInteger:[like objectID]] forKey:@"id"];
        NSString* updatedResource = [NSString stringWithFormat:@"%@%d/", LIKE_METHOD, [like objectID]];
        [self executeRequest:
         [SocializeRequest requestWithHttpMethod:@"DELETE"
                                    resourcePath:updatedResource
                              expectedJSONFormat:SocializeAny
                                          params:params]
         ];

    }
}

-(void)getLike:(NSInteger)likeId{
    
    NSMutableDictionary*  params = [[[NSMutableDictionary alloc] init] autorelease]; 
    [params setObject:[NSNumber numberWithInteger:likeId] forKey:@"id"];
    NSString* updatedResource = [NSString stringWithFormat:@"%@%d/", LIKE_METHOD, likeId]; 
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:updatedResource
                          expectedJSONFormat:SocializeDictionaryWIthListAndErrors
                                      params:params]
     ];

}

-(void)getLikesForEntityKey:(NSString*)key first:(NSNumber*)first last:(NSNumber*)last{
    
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease]; 
    if (key)
        [params setObject:key forKey:@"entity_key"];
    if (first && last){
        [params setObject:first forKey:@"first"];
        [params setObject:last forKey:@"last"];
    }
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:LIKE_METHOD
                          expectedJSONFormat:SocializeDictionaryWIthListAndErrors
                                      params:params]
     ];

}

-(void)getLikesForEntity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last{
    if ([entity conformsToProtocol:@protocol(SocializeEntity)])
        [self getLikesForEntityKey:[entity key] first:first last:last];
}

@end
