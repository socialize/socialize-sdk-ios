//
//  SocializeLikeService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/22/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeLikeService.h"
#import "JSONKit.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeLike.h"
#import "SocializeObjectFactory.h"
#import "SocializeProvider.h"
#import "SocializeEntity.h"



@interface SocializeLikeService()
-(NSArray*)parseLikes:(id)likesJsonData;
//-(NSMutableDictionary*) genereteParamsFromJsonString: (NSString*) jsonRequest;
@end

#define LIKE_METHOD @"like/"
#define ENTRY_KEY @"key"
#define ENTITY_KEY @"entity"
#define LIKES_METHOD @"like/"

@implementation SocializeLikeService



-(void) dealloc
{
    [super dealloc];
}

/*- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error
{
    [_delegate didFailService:self error:error];
}

- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    NSString* responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    id responseObject = [responseString objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    if ([request.httpMethod isEqualToString:@"DELETE"]){
        [_delegate didDeleteLike:self like:nil];
    }
    else  if ([request.httpMethod  isEqualToString:@"GET"]){
        NSArray* likes = [self parseLikes:responseObject];
        [_delegate didFetchLike:self like:likes];
    }
    else if ([request.httpMethod  isEqualToString:@"POST"]){
        NSArray* likes = [self parseLikes:responseObject];
        [_delegate didPostLike:self like:likes];
    }
}
 */
 
-(Protocol *)ProtocolType
{
    return  @protocol(SocializeLike);
}


-(NSArray*)parseLikes:(id)likesJsonData
{
    NSMutableArray* likes = nil;
    if ([likesJsonData isKindOfClass:[NSDictionary class]]){

        likes = [NSMutableArray array];
        id<SocializeLike> like = [_objectCreator createObjectFromDictionary:likesJsonData forProtocol:@protocol(SocializeLike)];
        [likes addObject:like];
        
    }
    else if ([likesJsonData isKindOfClass:[NSArray class]]){
        
        likes = [NSMutableArray arrayWithCapacity:[likesJsonData count]];
        [likesJsonData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             id<SocializeLike> like = [_objectCreator createObjectFromDictionary:obj forProtocol:@protocol(SocializeLike)];
             [likes addObject:like];
         }
         ];
    }
    
    return likes;
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
