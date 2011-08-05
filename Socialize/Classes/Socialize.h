/*
 * SocializeService.h
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
#import "SocializeProvider.h"
#import "SocializeObjectFactory.h"
#import "SocializeRequest.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeAuthenticateService.h"
#import "SocializeCommentsService.h"
#import "SocializeEntityService.h"
#import "SocializeLikeService.h"
#import "SocializeViewService.h"
#import "SocializeUserService.h"
#import "SocializeCommonDefinitions.h"

/**
This is a general facade of the   SDK`s API. Through it a third party developers could use the API.
 
@warning *Note:* Every thing in socialize revolves around the concept of “Entity”. An entity could be liked, unliked, commented on etc. 
In Socialize an entity can only be a url. So when creating an entity always remember to input the key for the entity as a url 
otherwise you will get a failure.  
*/


@interface Socialize : NSObject 
{
    @private
    SocializeObjectFactory          *_objectFactory;
    SocializeProvider               *_provider;

    SocializeAuthenticateService    *_authService;
    SocializeLikeService            *_likeService;
    SocializeCommentsService        *_commentsService;
    SocializeEntityService          *_entityService;
    SocializeViewService            *_viewService;
}
/**Get access to the authentication service via <SocializeAuthenticateService>.*/
@property (nonatomic, retain) SocializeAuthenticateService    *authService;
/**Get access to the like service.*/
@property (nonatomic, retain) SocializeLikeService            *likeService;
/**Get access to the comment service via <SocializeCommentsService>.*/
@property (nonatomic, retain) SocializeCommentsService        *commentsService;
/**Get access to the entity service.*/
@property (nonatomic, retain) SocializeEntityService          *entityService;
/**Get access to the view service via <SocializeViewService>.*/
@property (nonatomic, retain) SocializeViewService            *viewService;

/** @name Initialization */

/**
 Initialize Socialize service with <SocializeServiceDelegate> callback.
 
 @param delegate Implemented by user callback delegate which responds to the  <SocializeServiceDelegate> protocol.
 */
-(id)initWithDelegate:(id<SocializeServiceDelegate>)delegate;

/**
 Set callback delegate which responds to protocol <SocializeServiceDelegate> to the service.
 @param delegate Implemented by user callback delegate which responds to the  <SocializeServiceDelegate> protocol.
 */
-(void)setDelegate:(id<SocializeServiceDelegate>)delegate;

/** @name  Local in memory object creation */

/**
 Create local socialize object which responds to the specific protocol.
 
 For example you could create local instanse of comment class:
        id<SocializeComment> comment = [service createObjectForProtocol:@protocol(SocializeComment)];
 
 @param protocol Protocol of Socialize object: <SocializeEntity> ,  <SocializeLike> , <SocializeComment> , <SocializeView>
 */
-(id)createObjectForProtocol:(Protocol *)protocol;

/** @name Authentication stuff*/

/**
 Authenticate with API key and API secret.
 
 This method is used to perform anonymous authentication. It means that uses could not do any action with his profile.  
 Find information how to get API key and secret on [Socialize.](http://www.getsocialize.com/)
 
 @param apiKey API access key.
 @param apiSecret API access secret.
 @see authenticateWithApiKey:apiSecret:thirdPartyAppId:thirdPartyName:
 @see authenticateWithApiKey:apiSecret:thirdPartyAuthToken:thirdPartyAppId:thirdPartyName:
 */
-(void)authenticateWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret;

/**
 Third party authentication via SDK service.
 
 Third Party Authentication uses a service like Facebook to verify the user. Using third party authentication allows the user to maintain a profile that is linked to their activity. Without using Third Party Authentication, the user will still be able to access socialize features but these actions will not be linked to the user’s profile.
 
 Find information how to get API key and secret on [Socialize.](http://www.getsocialize.com/)

 @param apiKey API access key.
 @param apiSecret API access secret.
 @param thirdPartyAppId Extern service application id.
 @param thirdPartyName Third party authentication name. Current verion of SDK suports only FacebookAuth value.
 @warning *Note:* In current SDK version only Facebook authentication is available.
 
 @see authenticateWithApiKey:apiSecret:thirdPartyAuthToken:thirdPartyAppId:thirdPartyName:
 @see authenticateWithApiKey:apiSecret:
 */
-(void)authenticateWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret
              thirdPartyAppId:(NSString*)thirdPartyAppId 
               thirdPartyName:(ThirdPartyAuthName)thirdPartyName;

/**
 Third party authentication.
 
 Third Party Authentication uses a service like Facebook to verify the user. Using third party authentication allows the user to maintain a profile that is linked to their activity. Without using Third Party Authentication, the user will still be able to access socialize features but these actions will not be linked to the user’s profile.
 
 Find information how to get API key and secert on [Socialize.](http://www.getsocialize.com/)
 
 @param apiKey API access key.
 @param apiSecret API access secret.
 @param thirdPartyAuthToken External service's access token.
 @param thirdPartyAppId External service application id.
 @param thirdPartyName Third party authentication name.
 @warning In current SDK version only Facebook authentication is available.
 
 @see authenticateWithApiKey:apiSecret:thirdPartyAppId:thirdPartyName:
 @see authenticateWithApiKey:apiSecret:
 */
-(void)authenticateWithApiKey:(NSString*)apiKey 
                    apiSecret:(NSString*)apiSecret 
          thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
              thirdPartyAppId:(NSString*)thirdPartyAppId
               thirdPartyName:(ThirdPartyAuthName)thirdPartyName;

/**
 Check if authentication credentials still valid.
 
 @return YES if valid and NO if access token was expired.
 */
-(BOOL)isAuthenticated;

/**
 Remove old authentication information.
 
 If user would like to re-authenticate he has to remove previous authentication information.
 */
-(void)removeAuthenticationInfo;

/** @name Like stuff*/

-(void)likeEntityWithKey:(NSString*)url longitude:(NSNumber*)lng latitude:(NSNumber*)lat;
-(void)unlikeEntity:(id<SocializeLike>)like;
-(void)getLikesForEntityKey:(NSString*)url  first:(NSNumber*)first last:(NSNumber*)last;

/** @name Entity stuff*/

-(void)getEntityByKey:(NSString *)url;
-(void)createEntityWithUrl:(NSString*)entityKey andName:(NSString*)name;

/** @name Comment stuff */

/**
 Fetch comment by comment id.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didFetchElements:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param commentId Unique id of comment object
 */
-(void)getCommentById: (int) commentId;

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
-(void)getCommentList: (NSString*) entryKey first:(NSNumber*)first last:(NSNumber*)last;

/**
 Create comment for entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param url URL to the entity.
 @param comment Text of the comment.
 @param lng Longitude *float* value. Could be nil. (OPTIONAL)
 @param lat Latitude  *float* value. Could be nil. (OPTIONAL)
 @see createCommentForEntity:comment:longitude:latitude:;
 */
-(void)createCommentForEntityWithKey:(NSString*)url comment:(NSString*)comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat;

/**
 Create comment for entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param entity <SocializeEntity> for which user is going to create a comment.
 @param comment Text of the comment.
 @param lng Longitude *float* value. Could be nil. (OPTIONAL)
 @param lat Latitude  *float* value. Could be nil. (OPTIONAL)
 @see createCommentForEntityWithKey:comment:longitude:latitude:
 */
-(void)createCommentForEntity:(id<SocializeEntity>) entity comment: (NSString*) comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat;

/** @name View stuff */

/**
 This method creates view for entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param entity <SocializeEntity> object which should be marked as viewed.
 @param lng Longitude *float* value. Could be nil. (OPTIONAL)
 @param lat Latitude  *float* value. Could be nil. (OPTIONAL)
 */
-(void)viewEntity:(id<SocializeEntity>)entity longitude:(NSNumber*)lng latitude: (NSNumber*)lat;
@end