/*
 * SocializeEntityService.h
 * SocializeSDK
 *
 * Created on 6/17/11.
 * 
 * Copyright (c) 2011 Socialize, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


#import <Foundation/Foundation.h>
#import "SocializeEntity.h"
#import "SocializeRequest.h"
#import "SocializeService.h"

@class SocializeProvider;
@class SocializeObjectFactory;

/**
  Socialize entity service is the entity creation and fetch engine.
 */
@interface SocializeEntityService : SocializeService
{   
}

/**@name Fetch entity*/

/**
 Fetch entity by key.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didFetchElements:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param keyOfEntity URL of entity
 */
-(void)entityWithKey:(NSString *)keyOfEntity;

/**@name Create entity*/

/**
 Create entities.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param entities An array of <SocializeEntity> objects.
 */
-(void)createEntities:(NSArray *)entities;

/**
 Create entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param entity entity object which responded to <SocializeEntity> protocol.
 */
-(void)createEntity:(id<SocializeEntity>)entity ;

/**
 Create entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param keyOfEntity URL of entity
 @param nameOfEntity Name of entity
 */
-(void)createEntityWithKey:(NSString *)keyOfEntity andName:(NSString *)nameOfEntity;


- (void)getEntitiesWithIds:(NSArray*)entityIds;

- (void)getEntityWithId:(NSNumber*)entityId;

- (void)getEntitiesWithIds:(NSArray*)entityIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;

- (void)getEntityWithKey:(NSString*)entityKey success:(void(^)(NSArray *entities))success failure:(void(^)(NSError *error))failure;

- (void)getEntitiesWithSorting:(SZResultSorting)sorting first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *entities))success failure:(void(^)(NSError *error))failure;

- (void)getEntitiesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *entities))success failure:(void(^)(NSError *error))failure;

- (void)createEntities:(NSArray*)entities success:(void(^)(id entityOrEntities))success failure:(void(^)(NSError *error))failure;

@end