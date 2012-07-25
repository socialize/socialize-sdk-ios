/*
 * SocializeCommentsService.h
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
#import "SocializeRequest.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeService.h"

@class SocializeCommentsService;
@class SocializeObjectFactory;

@protocol SocializeComment;
@protocol SocializeEntity;

/**
 Socialize comment service is the comment creation and fetch engine.
 */
@interface SocializeCommentsService : SocializeService {

}

/**@name Getting Comments*/

/**
 Fetch comment by comment id.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didFetchElements:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param commentId Unique id of comment object
 */
-(void) getCommentById: (int) commentId;

/**
 Fetch list of comments.
 
 @param commentsId The array of comment ids.
 @param keys The array of entity keys.
 */
- (void)getCommentsList:(NSArray*)commentsId andKeys:(NSArray*)keys;

/**
 Fetch list of comments.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didFetchElements:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 Parameters first and last (OPTIONAL) : specify range to do pagination by entity’s key. First is included, and last is excluded.
 
 Default values:
 first = 0
 last = 100
 
 @warning *Note:*
 Each request is limited to 100 items.
 If first = 0, last = 50, the API returns comments 0-49.
 If last - first > 100, then last is truncated to equal first + 100. For example, if first = 100, last = 250, then last is changed to last = 200.
 If only last = 150 is passed, then last is truncated to 100. If last = 25, then results 0...24 are returned.
 
 @param entryKey URL to the entity.
 @param first First comment. Could be nil. (OPTIONAL)
 @param last Last comment. Could be nil. (OPTIONAL)
 */
-(void) getCommentList: (NSString*) entryKey first:(NSNumber*)first last:(NSNumber*)last;

/**@name Comment Creation*/

/**
 Create comment for entity.
 
 @see createCommentForEntityWithKey:comment:longitude:latitude:subscribe:
 */
-(void) createCommentForEntityWithKey: (NSString*) entityKey comment: (NSString*) comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat;

/**
 Create comment for entity.
 @see createCommentForEntity:comment:longitude:latitude:subscribe:
 */
-(void) createCommentForEntity: (id<SocializeEntity>) entity comment: (NSString*) comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat;

/**
 Create comment for entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param entityKey URL to the entity.
 @param comment Text of the comment.
 @param lng Longitude *float* value. Could be nil. (OPTIONAL)
 @param lat Latitude  *float* value. Could be nil. (OPTIONAL)
 @param subscribe YES if you want to subscribe to push notifications for other comments on this entity, NO otherwise
 */
-(void) createCommentForEntityWithKey:(NSString*)entityKey comment:(NSString*)comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat subscribe:(BOOL)subscribe;

/**
 Create comment for entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param entity <SocializeEntity> for which user is going to create a comment.
 @param comment Text of the comment.
 @param lng Longitude *float* value. Could be nil. (OPTIONAL)
 @param lat Latitude  *float* value. Could be nil. (OPTIONAL)
 @param subscribe YES if you want to subscribe to push notifications for other comments on this entity, NO otherwise
 */
-(void) createCommentForEntity: (id<SocializeEntity>) entity comment: (NSString*) comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat subscribe:(BOOL)subscribe;

/**
 * Create multiple comments at once
 */
- (void)createComments:(NSArray*)comments;

- (void)createComment:(id<SZComment>)comment success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure;

/**
 * Create one comment
 */
- (void)createComment:(id<SocializeComment>)comment;

- (void)getCommentsWithIds:(NSArray*)commentIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
- (void)getCommentsWithEntityKey:(NSString*)entityKey success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
- (void)createComments:(NSArray*)comments success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
- (void)getCommentsWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;

@end
