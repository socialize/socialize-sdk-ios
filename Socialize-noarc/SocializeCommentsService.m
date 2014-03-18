/*
 * SocializeCommentsService.m
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

#import "SocializeCommentsService.h"
#import "SocializeComment.h"
#import "SocializeCommentJSONFormatter.h"
#import "SocializeObjectFactory.h"
#import "socialize_globals.h"
#import "SZAPIClientHelpers.h"

#define COMMENTS_LIST_METHOD @"comment/"

#define ID_KEY @"id"
#define ENTRY_KEY @"key"
#define ENTITY_KEY @"entity_key"
#define COMMENT_KEY @"text"

@implementation SocializeCommentsService

-(void) dealloc
{
    [super dealloc];
}

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeComment);
}

- (void)callCommentsGetWithParams:(NSDictionary*)params success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"GET"
                                                           resourcePath:COMMENTS_LIST_METHOD
                                                     expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                                                 params:params];
    
    request.successBlock = success;
    request.failureBlock = failure;
    
    [self executeRequest:request];
}

- (void)getCommentsWithIds:(NSArray*)commentIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    NSDictionary *params = [NSDictionary dictionaryWithObject:commentIds forKey:@"id"];
    [self callCommentsGetWithParams:params success:success failure:failure];
}

- (void)getCommentsWithEntityKey:(NSString*)entityKey success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    NSDictionary *params = [NSDictionary dictionaryWithObject:entityKey forKey:@"entity_key"];
    [self callCommentsGetWithParams:params success:success failure:failure];
}

- (void)getCommentWithId:(NSNumber*)commentId
                 success:(void(^)(id<SZComment> comment))success
                 failure:(void(^)(NSError *error))failure {
    
}

- (void) getCommentById: (int) commentId
{
    [self getCommentsList:[NSArray arrayWithObject:[NSNumber numberWithInt:commentId]] andKeys:nil];
}

-(void) getCommentsList: (NSArray*) commentsId andKeys: (NSArray*)keys
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    if(commentsId!=nil && [commentsId count] != 0)
        [params setObject:commentsId forKey:ID_KEY];
    
    if(keys!=nil && [keys count] != 0)
        [params setObject:keys forKey:ENTRY_KEY];
    
    NSAssert([params count] != 0, @"User should provide commet ids or keys");
    
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:COMMENTS_LIST_METHOD
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]
     ];
}

-(void) getCommentList: (NSString*) entryKey first:(NSNumber*)first last:(NSNumber*)last{
    NSMutableDictionary* params;

    if (!first || !last)
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:entryKey, ENTITY_KEY, nil];
    else 
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:entryKey, ENTITY_KEY, first, @"first", last, @"last", nil];
        
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:COMMENTS_LIST_METHOD
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]
     ];
}

- (void)callCommentsPostWithParams:(NSArray*)params success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"POST"
                               resourcePath:COMMENTS_LIST_METHOD
                         expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                     params:params];

    request.successBlock = ^(NSArray *comments) {
        SZPostActivityEntityDidChangeNotifications(comments);
        BLOCK_CALL_1(success, comments);
    };
    
    request.failureBlock = failure;

    [self executeRequest:request];
}

- (void)createComments:(NSArray*)comments success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    NSArray* params = [_objectCreator createDictionaryRepresentationArrayForObjects:comments];
    [self callCommentsPostWithParams:params success:success failure:failure];
}

- (void)createComment:(id<SZComment>)comment success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    [self createComments:[NSArray arrayWithObject:comment] success:^(NSArray *comments) {
        BLOCK_CALL_1(success, [comments objectAtIndex:0]);
    } failure:failure];
}

- (void)createComments:(NSArray*)comments {
    [self createComments:comments success:nil failure:nil];
}

- (void)createComment:(id<SocializeComment>)comment {
    [self createComments:[NSArray arrayWithObject:comment]];
}

- (void)createCommentForEntity: (id<SocializeEntity>) entity comment: (NSString*) commentText longitude:(NSNumber*)lng latitude:(NSNumber*)lat subscribe:(BOOL)subscribe {
    SocializeComment *comment = [SocializeComment commentWithEntity:entity text:commentText];
    comment.lat = lat;
    comment.lng = lng;
    comment.subscribe = subscribe;
    [self createComment:comment];
}

- (void)createCommentForEntityWithKey:(NSString*)entityKey comment:(NSString*)commentText longitude:(NSNumber*)lng latitude:(NSNumber*)lat subscribe:(BOOL)subscribe {
    SocializeEntity *entity = [SocializeEntity entityWithKey:entityKey name:nil];
    [self createCommentForEntity:entity comment:commentText longitude:lng latitude:lat subscribe:subscribe];
}

- (void)createCommentForEntityWithKey:(NSString*)entityKey comment:(NSString*)comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat {
    SocializeEntity *entity = [SocializeEntity entityWithKey:entityKey name:nil];
    [self createCommentForEntity:entity comment:comment longitude:lng latitude:lat subscribe:NO];
}

- (void)createCommentForEntity: (id<SocializeEntity>) entity comment: (NSString*) comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat {
    [self createCommentForEntity:entity comment:comment longitude:lng latitude:lat subscribe:NO];
}

- (void)getCommentsWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [self callListingGetEndpointWithPath:COMMENTS_LIST_METHOD params:nil first:first last:last success:success failure:failure];
}

@end
