//
//  SocializeLikeService.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/22/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeRequest.h"
#import "SocializeService.h"

@class SocializeProvider;
@class SocializeObjectFactory;

@protocol SocializeEntity;
@protocol SocializeLike;

/**
 Socialize like service is the like entity engine.
 */
@interface SocializeLikeService : SocializeService{
    
}

/**@name Get like*/

/**
 Get list of 'likes' for entity.
 
 @param key Entity URL.
 @param first The first like object to get. (OPTIONAL)
 @param last The last like object to get. (OPTIONAL)
 */
-(void)getLikesForEntityKey:(NSString*)key first:(NSNumber*)first last:(NSNumber*)last;

/**
 Get list of 'likes' for entity.
 
 @param entity Entity object.
 @param first The first like object to get. (OPTIONAL)
 @param last The last like object to get. (OPTIONAL)
 */
-(void)getLikesForEntity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last;

/**
 Get like by object id.
 
 @param likeId Identificator of like object.
 */
-(void)getLike:(NSInteger)likeId;

/**@name Delete like*/

/**
 Unlike the entity.
 
 @param like <SocializeLike> object which should be removed.
 */
-(void)deleteLike:(id<SocializeLike>)like;

/**@name Like the entity*/

/**
 Mark entity as liked.
 
 @param key Entity URL.
 @param lng Longitude. (OPTIONAL)
 @param lat Latitude. (OPTIONAL)
 */
-(void)postLikeForEntityKey:(NSString*)key andLongitude:(NSNumber*)lng latitude: (NSNumber*)lat; 

/**
 Mark entity as liked.
 
 @param entity Entity object.
 @param lng Longitude. (OPTIONAL)
 @param lat Latitude. (OPTIONAL)
 */
-(void)postLikeForEntity:(id<SocializeEntity>)entity andLongitude:(NSNumber*)lng latitude: (NSNumber*)lat;

- (void)createLikes:(NSArray*)likes;

- (void)createLike:(id<SocializeLike>)like;

- (void)getLikesWithIds:(NSArray*)likeIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
- (void)getLikesForEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *likes))success failure:(void(^)(NSError *error))failure;
- (void)createLikes:(NSArray*)likes success:(void(^)(id entityOrEntities))success failure:(void(^)(NSError *error))failure;
- (void)createLike:(id<SZLike>)like success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure;
- (void)getLikesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *likes))success failure:(void(^)(NSError *error))failure;
@end
