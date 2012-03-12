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
    SocializeLike *like = [SocializeLike likeWithEntity:entity];
    [like setLat:lat];
    [like setLng:lng];
    [self createLike:like];
}

-(void)postLikeForEntityKey:(NSString*)key andLongitude:(NSNumber*)lng latitude: (NSNumber*)lat {
    SocializeEntity *entity = [SocializeEntity entityWithKey:key name:nil];
    [self postLikeForEntity:entity andLongitude:lat latitude:lng];
}

- (void)createLikesForParams:(NSArray*)params {
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"POST"
                                resourcePath:LIKE_METHOD
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]
     ];
}

- (void)createLikes:(NSArray*)likes {
    NSArray* params = [_objectCreator createDictionaryRepresentationArrayForObjects:likes];
    [self createLikesForParams:params];
}

- (void)createLike:(id<SocializeLike>)like {
    [self createLikes:[NSArray arrayWithObject:like]];
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
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
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
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]
     ];

}

-(void)getLikesForEntity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last{
    if ([entity conformsToProtocol:@protocol(SocializeEntity)])
        [self getLikesForEntityKey:[entity key] first:first last:last];
}

@end
