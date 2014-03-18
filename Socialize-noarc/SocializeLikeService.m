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
#import "socialize_globals.h"
#import "SZAPIClientHelpers.h"


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

- (void)callLikeWithMethod:(NSString*)method params:(id)params success:(void(^)(NSArray *entities))success failure:(void(^)(NSError *error))failure {
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:method
                                                           resourcePath:LIKE_METHOD
                                                     expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                                                 params:params];
    
    request.successBlock = success;
    request.failureBlock = failure;
    
    [self executeRequest:request];
}

- (void)callLikeGetWithParams:(NSDictionary*)params success:(void(^)(NSArray *entities))success failure:(void(^)(NSError *error))failure {
    [self callLikeWithMethod:@"GET" params:params success:success failure:failure];
}

- (void)callLikePostWithParams:(NSArray*)params success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [self callLikeWithMethod:@"POST" params:params success:^(NSArray *likes) {
        SZPostActivityEntityDidChangeNotifications(likes);
        BLOCK_CALL_1(success, likes);
    } failure:failure];
}

- (void)callLikeDeleteWithParams:(NSArray*)params success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [self callLikeWithMethod:@"DELETE" params:params success:^(NSArray *likes) {
        SZPostActivityEntityDidChangeNotifications(likes);
        BLOCK_CALL_1(success, likes);
    } failure:failure];
}

- (void)getLikesWithIds:(NSArray*)likeIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    NSDictionary *params = [NSDictionary dictionaryWithObject:likeIds forKey:@"id"];
    [self callLikeGetWithParams:params success:success failure:failure];
}

- (void)getLikesForEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *likes))success failure:(void(^)(NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:entity.key forKey:@"entity_key"];
    [params setValue:first forKey:@"first"];
    [params setValue:last forKey:@"last"];

    [self callLikeGetWithParams:params success:success failure:failure];
}

- (void)createLikes:(NSArray*)likes success:(void(^)(id entityOrEntities))success failure:(void(^)(NSError *error))failure {
    NSArray* params = [_objectCreator createDictionaryRepresentationArrayForObjects:likes];
    [self callLikePostWithParams:params success:success failure:failure];
}

- (void)createLike:(id<SZLike>)like success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure {
    [self createLikes:[NSArray arrayWithObject:like] success:^(NSArray *likes) {
        BLOCK_CALL_1(success, [likes objectAtIndex:0]);
    } failure:failure];
}

-(void)postLikeForEntity:(id<SocializeEntity>)entity andLongitude:(NSNumber*)lng latitude: (NSNumber*)lat
{
    SocializeLike *like = [SocializeLike likeWithEntity:entity];
    [like setLat:lat];
    [like setLng:lng];
    [self createLike:like success:nil failure:nil];
}

-(void)postLikeForEntityKey:(NSString*)key andLongitude:(NSNumber*)lng latitude: (NSNumber*)lat {
    SocializeEntity *entity = [SocializeEntity entityWithKey:key name:nil];
    [self postLikeForEntity:entity andLongitude:lat latitude:lng];
}

- (void)createLikes:(NSArray*)likes {
    [self createLikes:likes success:nil failure:nil];
}

- (void)createLike:(id<SocializeLike>)like {
    [self createLike:like success:nil failure:nil];
}

-(void)deleteLike:(id<SocializeLike>)like{
    if ([like conformsToProtocol:@protocol(SocializeLike)]){
        NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease];
        [params setObject:[NSNumber numberWithInteger:[like objectID]] forKey:@"id"];
        NSString* updatedResource = [NSString stringWithFormat:@"%@%d/", LIKE_METHOD, [like objectID]];
        [self executeRequest:
         [SocializeRequest requestWithHttpMethod:@"DELETE"
                                    resourcePath:updatedResource
                              expectedJSONFormat:SocializeDictionary
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

- (void)getLikesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *likes))success failure:(void(^)(NSError *error))failure {
    [self callListingGetEndpointWithPath:LIKES_METHOD params:nil first:first last:last success:success failure:failure];
}

@end
