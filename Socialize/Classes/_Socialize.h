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

#import "SocializeObjects.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeServiceDelegate.h"

@class SocializeObjectFactory;
@class SocializeAuthenticateService;
@class SocializeLikeService;
@class SocializeCommentsService;
@class SocializeEntityService;
@class SocializeViewService;
@class SocializeUserService;
@class SocializeActivityService;
@class SocializeShareService;
@class UIImage;
@class SocializeFacebook;

/**
This is a general facade of the   SDK`s API. Through it a third party developers could use the API.
 
@warning *Note:* Every thing in socialize revolves around the concept of "Entity". An entity could be liked, unliked, commented on etc. 
In Socialize an entity can only be a url. So when creating an entity always remember to input the key for the entity as a url 
otherwise you will get a failure.  
*/


@interface Socialize : NSObject 
{
    @private
    SocializeObjectFactory          *_objectFactory;
    SocializeAuthenticateService    *_authService;
    SocializeLikeService            *_likeService;
    SocializeCommentsService        *_commentsService;
    SocializeEntityService          *_entityService;
    SocializeViewService            *_viewService;
    SocializeUserService            *_userService;
    SocializeActivityService        *_activityService;
    SocializeShareService           *_shareService;
}
/**Get access to the authentication service via <SocializeAuthenticateService>.*/
@property (nonatomic, retain) SocializeAuthenticateService    *authService;
/**Get access to the like service via <SocializeLikeService>. */
@property (nonatomic, retain) SocializeLikeService            *likeService;
/**Get access to the comment service via <SocializeCommentsService>.*/
@property (nonatomic, retain) SocializeCommentsService        *commentsService;
/**Get access to the entity service via <SocializeEntityService>.*/
@property (nonatomic, retain) SocializeEntityService          *entityService;
/**Get access to the view service via <SocializeViewService>.*/
@property (nonatomic, retain) SocializeViewService            *viewService;
/**Get access to the user service via <SocializeViewService>.*/
@property (nonatomic, retain) SocializeUserService            *userService;
/**Get access to the activity service via <SocializeActivityService>.*/
@property (nonatomic, retain) SocializeActivityService        *activityService;
/**Get access to the activity service via <SocializeShareService>.*/
@property (nonatomic, retain) SocializeShareService           *shareService;
/**Current delegate*/
@property (nonatomic, assign) id<SocializeServiceDelegate> delegate;

/** @name Initialization */

/**
 Initialize Socialize service with <SocializeServiceDelegate> callback.
 
 @param delegate Implemented by user callback delegate which responds to the  <SocializeServiceDelegate> protocol.
 */
-(id)initWithDelegate:(id<SocializeServiceDelegate>)delegate;

/**
 Save API information to the user defaults.
 
 @param key Socialize API key.
 @param secret Socialize API secret.
 */
+(void)storeSocializeApiKey:(NSString*) key andSecret: (NSString*)secret;

/**
 Save facebook app id to the user defaults.
 
 @param facebookAppID Facebook App Id
 */
+(void)storeFacebookAppId:(NSString*)facebookAppID;

/**
 Save facebook local app id to the user defaults.
 
 @param facebookLocalAppID Facebook App Id
 */
+(void)storeFacebookLocalAppId:(NSString*)facebookLocalAppID;

/**
 Save app link to the user defaults.
 
 @param application link(URL)
 */
+(void)storeApplicationLink:(NSString*)link;

/**
 Remove app link from the user defaults.
 
 */
+(void)removeApplicationLink;

/**
 Provide access to the Socialize API key.
 
 @return API key NSString value.
 */
+(NSString*) apiKey;

/**
 Provide access to the Socialize API secret.
 
 @return API secret NSString value.
 */
+(NSString*) apiSecret;

/**
 Provide access to the facebook app id
 
 @return Facebook app id
 */
+(NSString*) facebookAppId;

/**
 Provide access to the facebook local app id (used if you have multiple apps with the same facebook app id, e.g. paid and free)
 
 @return Local Facebook app id
 */
+(NSString*) facebookLocalAppId;


/**
 Provide access to the app link
 
 @return link to the app
 */
+(NSString*) applicationLink;

/**
 Provide access to the facebook authorization token after facebook authentication
 
 @return Facebook authorization token
 */
-(NSString*) receiveFacebookAuthToken;

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
 Any applications using third party authentication must call this method from their
 application delegate's method. An example is below.
 
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // Run any application-specific url handling
 
    // This is necessary for completion of Socialize third party authorization
    [Socialize handleOpenURL:url];
 }

 @param url Unique URL to the user application.
 */
+(BOOL)handleOpenURL:(NSURL *)url;

/**
 Authenticate with API key and API secret.
 
 This method is used to perform anonymous authentication. It means that uses could not do any action with his profile.  
 Find information how to get API key and secret on [Socialize.](http://www.getsocialize.com/)
 
 Successful call of this method invokes <SocializeServiceDelegate> didAuthenticate: method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param apiKey API access key.
 @param apiSecret API access secret.
 @see authenticateWithApiKey:apiSecret:thirdPartyAppId:thirdPartyName:
 @see authenticateWithApiKey:apiSecret:thirdPartyAuthToken:thirdPartyAppId:thirdPartyName:
 */
-(void)authenticateWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret;

/**
 Third party authentication via SDK service.
 
 Third Party Authentication uses a service like Facebook to verify the user. Using third party authentication allows the user to maintain a profile that is linked to their activity. Without using Third Party Authentication, the user will still be able to access socialize features but these actions will not be linked to the user's profile.
 
 Find information how to get API key and secret on [Socialize.](http://www.getsocialize.com/)
 
 Successful call of this method invokes <SocializeServiceDelegate> didAuthenticate: method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param apiKey API access key.
 @param apiSecret API access secret.
 @param thirdPartyAppId Extern service application id.
 @param thirdPartyLocalAppId Extern service local application id.
 @param thirdPartyName Third party authentication name. Current verion of SDK suports only FacebookAuth value.
 @warning *Note:* In current SDK version only Facebook authentication is available.
 
 @see authenticateWithApiKey:apiSecret:thirdPartyAuthToken:thirdPartyAppId:thirdPartyName:
 @see authenticateWithApiKey:apiSecret:
 */
-(void)authenticateWithApiKey:(NSString*)apiKey
                    apiSecret:(NSString*)apiSecret
              thirdPartyAppId:(NSString*)thirdPartyAppId 
         thirdPartyLocalAppId:(NSString*)thirdPartyLocalAppId 
               thirdPartyName:(SocializeThirdPartyAuthType)thirdPartyName;

/**
 Third party authentication via SDK service.
 
 Third Party Authentication uses a service like Facebook to verify the user. Using third party authentication allows the user to maintain a profile that is linked to their activity. Without using Third Party Authentication, the user will still be able to access socialize features but these actions will not be linked to the user's profile.
 
 Find information how to get API key and secret on [Socialize.](http://www.getsocialize.com/)
 
 Successful call of this method invokes <SocializeServiceDelegate> didAuthenticate: method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.

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
               thirdPartyName:(SocializeThirdPartyAuthType)thirdPartyName;

/**
 Facebook authentication via SDK service.
 
 This is a convenience method for facebook authentication (without an existing token).
 
 Successful call of this method invokes <SocializeServiceDelegate> didAuthenticate: method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
  
 @see authenticateWithApiKey:apiSecret:thirdPartyAuthToken:thirdPartyAppId:thirdPartyName:
 @see storeSocializeApiKey:andSecret:
 @see storeFacebookAppId:
 */
-(void)authenticateWithFacebook;

/**
 Authenticate with API key and API secret that were saved in the user defaults.
 
 This method is used to perform anonymous authentication. It means that uses could not do any action with his profile.  
 Find information how to get API key and secret on [Socialize.](http://www.getsocialize.com/)
 
 Successful call of this method invokes <SocializeServiceDelegate> didAuthenticate: method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @see authenticateWithApiKey:apiSecret:
 @see authenticateWithApiKey:apiSecret:thirdPartyAppId:thirdPartyName:
 @see authenticateWithApiKey:apiSecret:thirdPartyAuthToken:thirdPartyAppId:thirdPartyName:
 @see storeSocializeApiKey:andSecret:
 */
-(void)authenticateAnonymously;

/**
 Third party authentication.
 
 Third Party Authentication uses a service like Facebook to verify the user. Using third party authentication allows the user to maintain a profile that is linked to their activity. Without using Third Party Authentication, the user will still be able to access socialize features but these actions will not be linked to the user's profile.
 
 Find information how to get API key and secert on [Socialize.](http://www.getsocialize.com/)
 
 Successful call of this method invokes <SocializeServiceDelegate> didAuthenticate: method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
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
               thirdPartyName:(SocializeThirdPartyAuthType)thirdPartyName;

/**
 Check if facebook is configured
 
 @return YES if the app is properly configured for facebook usage
 */
- (BOOL)facebookAvailable;

/**
 Check if authentication credentials still valid.
 
 @return YES if valid and NO if access token was expired.
 */
-(BOOL)isAuthenticated;

/**
 @return A SocializeUser object for the currently authenticated user
 */
-(id<SocializeUser>)authenticatedUser;

/**
 Check if authentication credentials still valid /and/ that this is a facebook authentication.
 
 @return YES if credentials are valid and facebook was used for authentication, and NO otherwise
 */
-(BOOL)isAuthenticatedWithFacebook;

/**
 Check if an existing facebook session already exists
 
 @return YES if there is already a valid facebook session for this app
 */
- (BOOL)facebookSessionValid;

/**
 Remove old authentication information.
 
 If user would like to re-authenticate he has to remove previous authentication information.
 */
-(void)removeAuthenticationInfo;

/** @name Like stuff*/

/**
 Like the entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param url Entyty URL.
 @param lng Longitude. (OPTIONAL)
 @param lat Latitude. (OPTIONAL)
 */
-(void)likeEntityWithKey:(NSString*)url longitude:(NSNumber*)lng latitude:(NSNumber*)lat;

/**
 Unlike the entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didDelete:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param like <SocializeLike> object.
 */
-(void)unlikeEntity:(id<SocializeLike>)like;

/**
 Get list of 'likes' for entity.
 
 @param url Entity URL.
 @param first The first like object to get. (OPTIONAL)
 @param last The last like object to get. (OPTIONAL)
 */
-(void)getLikesForEntityKey:(NSString*)url  first:(NSNumber*)first last:(NSNumber*)last;

/**
 Get list of 'views' for entity.
 
 @param url Entity URL.
 @param first The first view object to get. (OPTIONAL)
 @param last The last view object to get. (OPTIONAL)
 */
// not yet implemented
//-(void)getViewsForEntityKey:(NSString*)url  first:(NSNumber*)first last:(NSNumber*)last;

/** @name Entity stuff*/

/**
 Fetch entity by key.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didFetchElements:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param url URL of entity
 */
-(void)getEntityByKey:(NSString *)url;

/**
 Create entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param entityKey URL of entity
 @param name Name of entity
 */
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
 
 Parameters first and last (OPTIONAL) : specify range to do pagination by entity's key. First is included, and last is excluded.
 
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
-(void)viewEntityWithKey:(NSString*)url longitude:(NSNumber*)lng latitude: (NSNumber*)lat;

-(void)getCurrentUser;
-(void)getUserWithId:(int)userId;
-(void)updateUserProfile:(id<SocializeFullUser>)user;
-(void)updateUserProfile:(id<SocializeFullUser>)user profileImage:(UIImage*)profileImage;

-(void)getActivityOfCurrentApplication;
-(void)getActivityOfUser:(id<SocializeUser>)user;
-(void)getActivityOfUserId:(NSInteger)userId;
-(void)getActivityOfUserId:(NSInteger)userId first:(NSNumber*)first last:(NSNumber*)last activity:(SocializeActivityType)activityType;

-(void)createShareForEntity:(id<SocializeEntity>)entity medium:(SocializeShareMedium)medium  text:(NSString*)text;
-(void)createShareForEntityWithKey:(NSString*)key medium:(SocializeShareMedium)medium  text:(NSString*)text;
@end