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
@class SocializeDeviceTokenService;
@class SocializeSubscriptionService;
@class UIImage;
@class SocializeFacebook;
@class SocializeUIShareOptions;
@class SocializeTwitterAuthOptions;
@class SocializeEventService;
@class UINavigationController;

extern NSString *const kSocializeDisableBrandingKey;

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
    SocializeDeviceTokenService    *_deviceTokenService;
    SocializeSubscriptionService           *_subscriptionService;
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
/**Get access to the activity service via <SocializeNotificationService>.*/
@property (nonatomic, retain) SocializeDeviceTokenService    *deviceTokenService;
/**Get access to the activity service via <SocializeSubscriptionService>.*/
@property (nonatomic, retain) SocializeSubscriptionService *subscriptionService;
/**Get access to the activity service via <SocializeEventsService>.*/
@property (nonatomic, retain) SocializeEventService         *eventsService;
/**Current delegate*/

/**
 Set callback delegate which responds to protocol <SocializeServiceDelegate> to the service.
 @param delegate Implemented by user callback delegate which responds to the  <SocializeServiceDelegate> protocol.
 */
@property (nonatomic, assign) id<SocializeServiceDelegate> delegate;

/** @name Initialization */

/**
 Initialize Socialize service with <SocializeServiceDelegate> callback.
 
 @param delegate Implemented by user callback delegate which responds to the  <SocializeServiceDelegate> protocol.
 */
-(id)initWithDelegate:(id<SocializeServiceDelegate>)delegate;

/**
 Cancel all outstanding requests
 */
- (void)cancelAllRequests;

+ (BOOL)isSocializeNotification:(NSDictionary*)userInfo;

+ (BOOL)handleNotification:(NSDictionary*)userInfo;

+ (BOOL)openNotification:(NSDictionary*)userInfo;

+ (NSString *)socializeVersion;

+ (id)sharedLoopyAPIClient;

/**
 Provide access to the entity loader block
 
 typedef void(^SocializeEntityLoaderBlock)(UINavigationController *navigationController, id<SocializeEntity>entity);
 */
+(SocializeEntityLoaderBlock)entityLoaderBlock;

/**
 Set entity loader block
 
 typedef void(^SocializeEntityLoaderBlock)(UINavigationController *navigationController, id<SocializeEntity>entity);
 
 @param entityLoaderBlock This block will be called when Socialize wishes to load an entity
 */
+(void)setEntityLoaderBlock:(SocializeEntityLoaderBlock)entityLoaderBlock;

/**
 Set new comments notification block
 
 @param newCommentsBlock This block will be called when Socialize wishes to load a new comments notification
 */
+(void)setNewCommentsNotificationBlock:(SocializeNewCommentsNotificationBlock)newCommentsBlock;

/**
 Provide access to the "don't load entity" block
 
 typedef BOOL(^SocializeCanLoadEntityBlock)(id<SocializeEntity>entity);
 */
+(SocializeCanLoadEntityBlock)canLoadEntityBlock;

/**
 Set "don't load entity block"
 
 typedef BOOL(^SocializeEntityUnavailableBlock)(id<SocializeEntity>entity);
 
 You only need to implement this if you wish to selectively disable loading of certain entities from Socialize in your app
 
 @param entityUnavailableBlock Block which should return YES if Socialize should not try to display the given entity in your app, NO otherwise
 */
+(void)setCanLoadEntityBlock:(SocializeCanLoadEntityBlock)canLoadEntityBlock;

/**
 Save API information to the user defaults.
 
 @param key Socialize API key.
 @param secret Socialize API secret.
 */
+(void)storeSocializeApiKey:(NSString*) key andSecret: (NSString*)secret __attribute__((deprecated));

/**
 Save API consumer key
 
 @param consumerKey Socialize API consumer key.
 */
+(void)storeConsumerKey:(NSString*)consumerKey;

+ (NSString*)consumerKey;
+ (NSString*)consumerSecret;

/**
 Save API consumer secret
 
 @param consumerSecret Socialize API consumer secret.
 */
+(void)storeConsumerSecret:(NSString*)consumerSecret;

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
 Save facebook url scheme suffix to the user defaults.
 This is the new name for the local app id
 
 @param facebookURLSchemeSuffix Facebook URL Scheme suffix
 */
+(void)storeFacebookURLSchemeSuffix:(NSString*)facebookURLSchemeSuffix;

+(void)storeTwitterConsumerKey:(NSString*)consumerKey;
+(void)storeTwitterConsumerSecret:(NSString*)consumerSecret;

+(NSString*)twitterConsumerKey;
+(NSString*)twitterConsumerSecret;

    
/**
 Save app link to the user defaults.
 
 @param application link(URL)
 */
+(void)storeApplicationLink:(NSString*)link   __attribute__((deprecated)) ;

/**
 Remove app link from the user defaults.
 
 */
+(void)removeApplicationLink __attribute__((deprecated));

+(void)storeUIErrorAlertsDisabled:(BOOL)disabled;

/**
 Some aspects of Socialize, such as Facebook wall posts, include information about Socialize. If you do not
 wish to have this 
 
 @param disableBranding turn off the branding
 */
+(void)storeDisableBranding:(BOOL)disableBranding;

/**
 Provide access to the Socialize "disable branding" flag
 
 @return BOOL reflecting whether or not branding is disabled.
 */
+ (BOOL)disableBranding;

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

-(void)authenticateWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;

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
  
 @warning Deprecated, use linkToFacebookWithAccessToken: instead
 
 @see authenticateWithApiKey:apiSecret:thirdPartyAuthToken:thirdPartyAppId:thirdPartyName:
 @see storeSocializeApiKey:andSecret:
 @see storeFacebookAppId:
 */
-(void)authenticateWithFacebook  __attribute__((deprecated));

/**
 Link
 */
- (void)linkToFacebookWithAccessToken:(NSString*)facebookAccessToken expirationDate:(NSDate*)expirationDate;

- (void)linkToFacebookWithAccessToken:(NSString*)facebookAccessToken 
                       expirationDate:(NSDate *)expirationDate
                              success:(void(^)(id<SZFullUser>))success
                              failure:(void(^)(NSError *error))failure;

- (void)linkToTwitterWithAccessToken:(NSString*)twitterAccessToken accessTokenSecret:(NSString*)twitterAccessTokenSecret;
- (void)linkToTwitterWithAccessToken:(NSString*)twitterAccessToken 
                   accessTokenSecret:(NSString *)twitterAccessTokenSecret
                             success:(void(^)(id<SZFullUser>))success
                             failure:(void(^)(NSError *error))failure;

/**
 Perform a managed Twitter authentication process, including webview callout to twitter auth process if necessary
 
 @see SocializeUIDisplay
 This variant allows specifying an explicit consumer key and secret
 */
//- (void)authenticateViaTwitterWithConsumerKey:(NSString*)consumerKey
//                               consumerSecret:(NSString*)consumerSecret
//                               displayHandler:(id)displayHandler;

/**
 Perform a managed Twitter authentication process, including webview callout to twitter auth process if necessary
 This variant uses the stored consumer key and secret (used by built-in Socialize UI controls)
 
 @param displayHandler A SocializeUIDisplay for handling the required modal controller presentation and dismissal.
 
 @see SocializeUIDisplay
 */
- (void)authenticateViaTwitterWithOptions:(SocializeTwitterAuthOptions*)options
                                  display:(id)display
                                  success:(void(^)())success
                                  failure:(void(^)(NSError *error))failure;

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

-(void)authenticateAnonymouslyWithSuccess:(void(^)())success
                                  failure:(void(^)(NSError *error))failure;

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
               thirdPartyName:(SocializeThirdPartyAuthType)thirdPartyName  __attribute__((deprecated));

/**
 Link socialize account to third party
 
 @param type The third party to link to
 @param thirdPartyAuthToken auth token (required for both fb and twitter)
 @param thirdPartyAuthTokenSecret auth token secret (required for Twitter, unused for Facebook)
 */ 
- (void)authenticateWithThirdPartyAuthType:(SocializeThirdPartyAuthType)type
                       thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                 thirdPartyAuthTokenSecret:(NSString*)thirdPartyAuthTokenSecret;

/**
 Check if the app is configured for any type of third party authentication (currently Facebook or Twitter)
 
 @return YES if available, NO otherwise
 */
- (BOOL)thirdPartyAvailable;

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
 @return A SocializeFullUser object for the currently authenticated user
 */
-(id<SocializeFullUser>)authenticatedFullUser;

/**
 Check if authentication credentials still valid /and/ that this is a facebook authentication.
 
 @return YES if credentials are valid and facebook was used for authentication, and NO otherwise
 */
-(BOOL)isAuthenticatedWithFacebook;

/**
 @return YES if authenticated with Socialize and linked to Twitter
 */
-(BOOL)isAuthenticatedWithTwitter;

/**
 Check if authenticated with a third party
 @return YES if authenticated with any third party (currently, either Twitter or Facebook)
 */
- (BOOL)isAuthenticatedWithThirdParty;


/**
 Remove old authentication information.
 
 If user would like to re-authenticate he has to remove previous authentication information.
 */
-(void)removeAuthenticationInfo;

/**
 Remove just Socialize authentication info (no third party credentials will be wiped)
 */
- (void)removeSocializeAuthenticationInfo;

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

- (void)deleteLikeForUser:(id<SZFullUser>)user entity:(id<SZEntity>)entity success:(void(^)(id<SZLike>))success failure:(void(^)(NSError *error))failure;

- (void)createLike:(id<SocializeLike>)like;
- (void)createLikes:(NSArray*)likes;

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
 
 @param entity An object that conforms to the SocializeEntity protocol
 @param name Name of the entity
 */
-(void)createEntity:(id<SocializeEntity>)entity;

/**
 Create entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param entityKey Key for the entity
 @param name Name of the entity
 */
-(void)createEntityWithKey:(NSString*)entityKey name:(NSString*)name;

/**
 Create entity.
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param entityKey URL of entity
 @param name Name of entity
 
 @warning Deprecated. Use createEntityWithKey:name: instead
 */
-(void)createEntityWithUrl:(NSString*)entityKey andName:(NSString*)name  __attribute__((deprecated));

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

- (void)getCommentsWithIds:(NSArray*)commentIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
- (void)getCommentsWithEntityKey:(NSString*)entityKey success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;

- (void)getCommentsWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;

/**
 Create comment for entity.
 
 @see createCommentForEntityWithKey:comment:longitude:latitude:subscribe:
 */
-(void)createCommentForEntityWithKey:(NSString*)url comment:(NSString*)comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat;

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
-(void)createCommentForEntityWithKey:(NSString*)entityKey comment:(NSString*)comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat subscribe:(BOOL)subscribe;

/**
 Create comment for entity.
 @see createCommentForEntity:comment:longitude:latitude:subscribe:
 */
-(void)createCommentForEntity:(id<SocializeEntity>) entity comment: (NSString*) comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat;

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
 * Create a comment (invokes service:didCreate:)
 */
- (void)createComment:(id<SocializeComment>)comment;

/**
 * Create multiple comment (invokes service:didCreate:)
 */
- (void)createComments:(NSArray*)comments;

- (void)createComments:(NSArray*)comments success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;

- (void)createComment:(id<SZComment>)comment success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure;

/** Socialize Notification Service **/
//registers a device token.  Call this method when the developer gets the callback for:
//didRegisterForRemoteNotificationsWithDeviceToken from the system
+(void)registerDeviceToken:(NSData *)deviceToken development:(BOOL)development;
+(void)registerDeviceToken:(NSData *)deviceToken;

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
- (void)createView:(id<SocializeView>)view;
- (void)createViews:(NSArray*)views;

- (void)createViews:(NSArray*)views success:(void(^)(NSArray *views))success failure:(void(^)(NSError *error))failure;
- (void)createView:(id<SZView>)view success:(void(^)(id<SZView>))success failure:(void(^)(NSError *error))failure;

-(void)getCurrentUser;
-(void)getUserWithId:(int)userId;
-(void)updateUserProfile:(id<SocializeFullUser>)user;
-(void)updateUserProfile:(id<SocializeFullUser>)user profileImage:(UIImage*)profileImage;
-(void)getUsersWithIds:(NSArray*)ids success:(void(^)(NSArray *users))success failure:(void(^)(NSError *error))failure;

/**
 * Get likes for a specific user.
 
 @param user user
 @param entity Optional, only likes for this specific entity will be returned
 @param first Optional start offset
 @param last Optional end offset. Can be specified without first.
 */
- (void)getLikesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last;

- (void)getSharesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last;

- (void)getLikesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure;
- (void)getSharesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure;
- (void)getCommentsForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure;
- (void)getActivityForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure;

- (void)getActivityOfEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
- (void)getActivityOfApplicationWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
-(void)getActivityOfCurrentApplication;
-(void)getActivityOfCurrentApplicationWithFirst:(NSNumber*)first last:(NSNumber*)last;
-(void)getActivityOfUser:(id<SocializeUser>)user;
-(void)getActivityOfUserId:(NSInteger)userId;
-(void)getActivityOfUserId:(NSInteger)userId first:(NSNumber*)first last:(NSNumber*)last activity:(SocializeActivityType)activityType;

- (void)getLikesWithIds:(NSArray*)likeIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
- (void)getLikesForEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *likes))success failure:(void(^)(NSError *error))failure;
- (void)createLikes:(NSArray*)likes success:(void(^)(id entityOrEntities))success failure:(void(^)(NSError *error))failure;
- (void)createLike:(id<SZLike>)like success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure;
- (void)getLikesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;

-(void)createShareForEntity:(id<SocializeEntity>)entity medium:(SocializeShareMedium)medium  text:(NSString*)text;
-(void)createShareForEntityWithKey:(NSString*)key medium:(SocializeShareMedium)medium  text:(NSString*)text;
- (void)createShare:(id<SocializeShare>)share;
- (void)createShare:(id<SocializeShare>)share success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure;
- (void)createShare:(id<SocializeShare>)share
            success:(void(^)(id<SZShare> share))success
            failure:(void(^)(NSError *error))failure
       loopySuccess:(id)loopySuccess
       loopyFailure:(id)loopyFailure;
-(void)getSharesWithIds:(NSArray*)shareIds success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure;
-(void)getShareWithId:(NSNumber*)shareId success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure;
- (void)getSharesForEntityKey:(NSString*)key first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure;
- (void)getSharesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure;

/**
 Enable push notifications for new comments on the given entity
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param entityKey Pushes will be sent for comments on this entity
 */
- (void)subscribeToCommentsForEntityKey:(NSString*)entityKey;

/**
 Disable push notifications for new comments on the given entity
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didCreate:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param entityKey Pushes will no longer be sent for comments on this entity
 */
- (void)unsubscribeFromCommentsForEntityKey:(NSString*)entityKey;

/**
 Get all subscriptions for the given entity key
 
 Successful call of this method invokes <[SocializeServiceDelegate service:didFetchElements:]> method.
 In case of error it will be called <[SocializeServiceDelegate service:didFail:]> method.
 
 @param entityKey Get subscriptions for this entity key
 @param first First index
 @param last Last index, noninclusive
 */
- (void)getSubscriptionsForEntityKey:(NSString*)entityKey first:(NSNumber*)first last:(NSNumber*)last;

- (void)getSubscriptionsForEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *subscriptions))success failure:(void(^)(NSError *error))failure;

- (void)createSubscriptions:(NSArray*)subscriptions success:(void(^)(NSArray *subscriptions))success failure:(void(^)(NSError *error))failure;
- (void)createSubscription:(id<SZSubscription>)subscription success:(void(^)(id<SZSubscription>))success failure:(void(^)(NSError *error))failure;

- (BOOL)notificationsAreConfigured;

+(id)sharedSocialize;

/** Send device token (string) to Socialize servers using the REST API
 You should not require this function for normal use. Use registerDeviceToken: instead
 */
- (void)_registerDeviceTokenString:(NSString*)deviceTokenString development:(BOOL)development;

-(BOOL)isAuthenticatedWithAuthType:(NSString*)authType;

/**
 * Don't require users to authenticate with a 3rd party for social actions
 */
+ (void)storeAuthenticationNotRequired:(BOOL)authenticationNotRequired;

/**
 * Whether or not users are required to authenticate with a 3rd party for social actions
 */
+ (BOOL)authenticationNotRequired;

+ (void)storeLocationSharingDisabled:(BOOL)locationSharingDisabled;

+ (BOOL)locationSharingDisabled;

+ (void)storeAnonymousAllowed:(BOOL)anonymousAllowed;

+ (BOOL)anonymousAllowed;

+ (void)storeOGLikeEnabled:(BOOL)OGLikedEnabled;

+ (BOOL)OGLikeEnabled;

/**
 Get single entity by id
 
 @param entityId The id of the entity (SocializeObject's objectID)
 */
- (void)getEntityWithId:(NSNumber*)entityId;

/**
 Get multiple entities by id
 
 @param entityId The id of the entity (SocializeObject's objectID)
 */
- (void)getEntitiesWithIds:(NSArray*)entityIds;

- (void)getEntitiesWithIds:(NSArray*)entityIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;

- (void)getEntityWithKey:(NSString*)entityKey success:(void(^)(NSArray *entities))success failure:(void(^)(NSError *error))failure;

- (void)getEntitiesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *entities))success failure:(void(^)(NSError *error))failure;

- (void)getEntitiesWithSorting:(SZResultSorting)sorting first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *entities))success failure:(void(^)(NSError *error))failure;

- (void)createEntities:(NSArray*)entities success:(void(^)(id entityOrEntities))success failure:(void(^)(NSError *error))failure;

/**
 Check if the app can actually load this entity
 */
+ (BOOL)canLoadEntity:(id<SocializeEntity>)entity;

/**
 Track an event
 */
- (void)trackEventWithBucket:(NSString*)bucket values:(NSDictionary*)values;
- (void)trackEventWithBucket:(NSString*)bucket values:(NSDictionary*)values success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure;

- (void)updateUserProfile:(id<SocializeFullUser>)user
             profileImage:(UIImage*)image
                  success:(void(^)(id<SocializeFullUser> user))success
                  failure:(void(^)(NSError *error))failure;

//+ (void)showShareActionSheetWithViewController:(UIViewController*)viewController entity:(id<SocializeEntity>)entity success:(void(^)())success failure:(void(^)(NSError *error))failure;

@end
