/*
 * SocializeEntityService.m
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

#import "SocializeEntityService.h"
#import "SocializeObjectFactory.h"
#import "SocializeEntity.h"
#import "socialize_globals.h"
#import "SZAPIClientHelpers.h"

#define ENTITY_GET_ENDPOINT     @"entity/"
#define ENTITY_CREATE_ENDPOINT  @"entity/"
#define ENTITY_LIST_ENDPOINT    @"entity/list/"

#define IDS_KEY @"ids"
#define ENTRY_KEY @"entity_key"
#define ENTITY_KEY @"entity"
#define COMMENT_KEY @"text"


@interface SocializeEntityService()
@end

@implementation SocializeEntityService


- (void)dealloc {
    [super dealloc];
}

- (Protocol *)ProtocolType {
    return  @protocol(SocializeEntity);
}


- (void)callEntityGetWithParams:(NSDictionary*)params
                        success:(void(^)(NSArray *entities))success
                        failure:(void(^)(NSError *error))failure {
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"GET"
                                                           resourcePath:ENTITY_GET_ENDPOINT
                                                     expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                                                 params:params];
    
    request.successBlock = success;
    request.failureBlock = failure;
    
    [self executeRequest:request];
}

- (void)callEntityPostWithParams:(NSArray*)params success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"POST"
                                                           resourcePath:ENTITY_GET_ENDPOINT
                                                     expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                                                 params:params];
    request.successBlock = success;
    request.failureBlock = failure;
    
    [self executeRequest:request];
}

- (void)getEntitiesWithIds:(NSArray*)entityIds
                   success:(void(^)(NSArray *comments))success
                   failure:(void(^)(NSError *error))failure {
    NSDictionary *params = [NSDictionary dictionaryWithObject:entityIds forKey:@"id"];
    [self callEntityGetWithParams:params success:success failure:failure];
}
     
- (void)getEntitiesWithIds:(NSArray*)entityIds {
    [self getEntitiesWithIds:entityIds success:nil failure:nil];
}


- (void)getEntityWithId:(NSNumber*)entityId {
    [self getEntitiesWithIds:[NSArray arrayWithObject:entityId]];
}

- (void)getEntityWithKey:(NSString*)entityKey
                 success:(void(^)(NSArray *entities))success
                 failure:(void(^)(NSError *error))failure {
    NSDictionary *params = [NSDictionary dictionaryWithObject:entityKey forKey:@"entity_key"];
    [self callEntityGetWithParams:params success:success failure:failure];
}

- (void)getEntitiesWithSorting:(SZResultSorting)sorting
                         first:(NSNumber*)first
                          last:(NSNumber*)last
                       success:(void(^)(NSArray *entities))success
                       failure:(void(^)(NSError *error))failure {
    NSString *sortingString = SZAPINSStringFromSZResultSorting(sorting);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:first forKey:@"first"];
    [params setValue:last forKey:@"last"];
    [params setValue:sortingString forKey:@"sort"];
    
    [self callEntityGetWithParams:params success:success failure:failure];
}

- (void)getEntitiesWithFirst:(NSNumber*)first
                        last:(NSNumber*)last
                     success:(void(^)(NSArray *entities))success
                     failure:(void(^)(NSError *error))failure {
    [self getEntitiesWithSorting:SZResultSortingDefault first:first last:last success:success failure:failure];
}

- (void)entityWithKey:(NSString *)keyOfEntity {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:keyOfEntity,ENTRY_KEY, nil];
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:ENTITY_GET_ENDPOINT
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]
     ];

}

- (void)createEntities:(NSArray *)entities
expectedResponseFormat:(ExpectedResponseFormat)expectedFormat {
    NSString * stringRepresentation =  [_objectCreator createStringRepresentationOfArray:entities]; 
    NSMutableDictionary* params = [self generateParamsFromJsonString:stringRepresentation];
   
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"POST"
                                resourcePath:ENTITY_CREATE_ENDPOINT
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]
     ];

}

- (void)createEntity:(id<SocializeEntity>)entity {
    [self createEntities:[NSArray arrayWithObject:entity]];
}

- (void)createEntityWithKey:(NSString *)keyOfEntity
                   andName:(NSString *)nameOfEntity {
    id<SocializeEntity> entity = (id<SocializeEntity>)[_objectCreator createObjectForProtocol:@protocol(SocializeEntity)];
   
    [entity setKey:keyOfEntity];
    [entity setName:nameOfEntity];
   
    [self createEntity:entity];
}

-(void)createEntities:(NSArray *)entities {
    [self createEntities:entities expectedResponseFormat:SocializeDictionaryWithListAndErrors];
}

- (void)createEntities:(NSArray*)entities
               success:(void(^)(id entityOrEntities))success
               failure:(void(^)(NSError *error))failure {
    NSArray* params = [_objectCreator createDictionaryRepresentationArrayForObjects:entities];
    [self callEntityPostWithParams:params success:success failure:failure];
}

@end
