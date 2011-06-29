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
-(NSMutableDictionary*) genereteParamsFromJsonString: (NSString*) jsonRequest;
@end

#define LIKE_METHOD @"like/"
#define ENTRY_KEY @"key"
#define ENTITY_KEY @"entity"

@implementation SocializeLikeService


@synthesize delegate = _delegate;
@synthesize provider = _provider;
@synthesize objectCreator = _objectCreator;

-(id) initWithProvider: (SocializeProvider*) provider objectFactory: (SocializeObjectFactory*) objectFactory delegate: (id<SocializeLikeServiceDelegate>) delegate
{
    self = [super init];
    if(self != nil)
    {
        self.provider = provider;
        self.objectCreator = objectFactory;
        self.delegate = delegate;
    }
    
    return self;
}

-(void) dealloc
{
    self.delegate = nil;
    self.provider = nil;
    
    [_objectCreator release]; _objectCreator = nil;
    [super dealloc];
}

- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error
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
        [_provider requestWithMethodName:LIKE_METHOD andParams:params andHttpMethod:@"POST" andDelegate:self];
    }
}

-(void)deleteLike:(id<SocializeLike>)like{
    if ([like conformsToProtocol:@protocol(SocializeLike)]){
        NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease];
        [params setObject:[NSNumber numberWithInteger:[like objectID]] forKey:@"id"];
        NSString* updatedResource = [NSString stringWithFormat:@"%@%d/", LIKE_METHOD, [like objectID]];
        [_provider requestWithMethodName:updatedResource andParams:params andHttpMethod:@"DELETE" andDelegate:self];
    }
}

-(void)getLike:(NSInteger)likeId{
    
    NSMutableDictionary*  params = [[[NSMutableDictionary alloc] init] autorelease]; 
    [params setObject:[NSNumber numberWithInteger:likeId] forKey:@"id"];
    NSString* updatedResource = [NSString stringWithFormat:@"%@%d/", LIKE_METHOD, likeId]; 
    [_provider requestWithMethodName:updatedResource andParams:params andHttpMethod:@"GET" andDelegate:self];

}

-(void)getLikesForEntityKey:(NSString*)key{
    
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease]; 
    if (key)
        [params setObject:key forKey:@"key"];
    [_provider requestWithMethodName:LIKE_METHOD andParams:params andHttpMethod:@"GET" andDelegate:self];

}

-(void)getLikesForEntity:(id<SocializeEntity>)entity{
    if ([entity conformsToProtocol:@protocol(SocializeEntity)])
        [self getLikesForEntityKey:[entity key]];
}

-(NSMutableDictionary*) genereteParamsFromJsonString: (NSString*) jsonRequest
{
    NSString* jsonData = jsonRequest;
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            jsonData, @"jsonData",
            nil];
}
@end