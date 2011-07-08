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
#import "SocializeProvider.h"
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

-(void)postLikeForEntity:(id<SocializeEntity>)entity{
    DLog(@"entity %@", entity);
    [self postLikeForEntityKey:[entity key]];
}

-(void)postLikeForEntityKey:(NSString*)key{

    if (key && [key length]){   
        NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:key, @"entity", nil];
        NSArray *params = [NSArray arrayWithObjects:entityParam, 
                           nil];
        [_provider requestWithMethodName:LIKE_METHOD andParams:params expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:self];
    }
}

-(void)deleteLike:(id<SocializeLike>)like{
    if ([like conformsToProtocol:@protocol(SocializeLike)]){
        NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease];
        [params setObject:[NSNumber numberWithInteger:[like objectID]] forKey:@"id"];
        NSString* updatedResource = [NSString stringWithFormat:@"%@%d/", LIKE_METHOD, [like objectID]];
        [_provider requestWithMethodName:updatedResource andParams:params  expectedJSONFormat:SocializeDictionary andHttpMethod:@"DELETE" andDelegate:self];
    }
}

-(void)getLike:(NSInteger)likeId{
    
    NSMutableDictionary*  params = [[[NSMutableDictionary alloc] init] autorelease]; 
    [params setObject:[NSNumber numberWithInteger:likeId] forKey:@"id"];
    NSString* updatedResource = [NSString stringWithFormat:@"%@%d/", LIKE_METHOD, likeId]; 
    [_provider requestWithMethodName:updatedResource andParams:params expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"GET" andDelegate:self];
}

-(void)getLikesForEntityKey:(NSString*)key{
    
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease]; 
    if (key)
        [params setObject:key forKey:@"key"];
    [_provider requestWithMethodName:LIKE_METHOD andParams:params  expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"GET" andDelegate:self];

}

-(void)getLikesForEntity:(id<SocializeEntity>)entity{
    if ([entity conformsToProtocol:@protocol(SocializeEntity)])
        [self getLikesForEntityKey:[entity key]];
}

@end
