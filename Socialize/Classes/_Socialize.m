//
//  SocializeService.m
//  SocializeSDK
//
//  Created by William Johnson on 5/31/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "_Socialize.h"

#import "SocializeConfiguration.h"
#import "SocializeCommentsService.h"
#import "SocializeLikeService.h"
#import "SocializeAuthenticateService.h"
#import "SocializeEntityService.h"
#import "SocializeActivityService.h"
#import "SocializeCommentsService.h"
#import "SocializeUserService.h"
#import "SocializeViewService.h"
#import "SocializeDeviceTokenService.h"
#import "SocializeShareService.h"
#import "SocializeSubscriptionService.h"
#import "NSTimer+BlocksKit.h"
#import "SocializeNotificationHandler.h"
#import "StringHelper.h"
#import "SocializeTwitterAuthenticator.h"
#import "SocializeDeviceTokenSender.h"
#import "SocializeUIShareCreator.h"
#import "SocializeUIShareOptions.h"
#import "SocializeTwitterAuthOptions.h"
#import "SocializeFacebookAuthHandler.h"
#import "SocializeThirdPartyTwitter.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeFacebookAuthenticator.h"

#define SYNTH_DEFAULTS_GETTER(TYPE, NAME, STORE_KEY) \
+ (TYPE*)NAME { \
    return [[NSUserDefaults standardUserDefaults] objectForKey:STORE_KEY]; \
}

#define SYNTH_DEFAULTS_SETTER(TYPE, NAME, STORE_KEY) \
+ (void)store ## NAME : (TYPE*)value { \
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; \
    [defaults setValue:value forKey:STORE_KEY]; \
    [defaults synchronize]; \
}

#define SYNTH_DEFAULTS_PROPERTY(TYPE, UPPERNAME, LOWERNAME, STORE_KEY) \
SYNTH_DEFAULTS_SETTER(TYPE, UPPERNAME, STORE_KEY) \
SYNTH_DEFAULTS_GETTER(TYPE, LOWERNAME, STORE_KEY)

NSString *const kSocializeDisableBrandingKey = @"kSocializeDisableBrandingKey";

NSString *const kSocializeConsumerKey = @"kSocializeConsumerKey";
NSString *const kSocializeConsumerSecret = @"kSocializeConsumerSecret";

NSString *const SocializeAuthenticatedUserDidChangeNotification = @"SocializeAuthenticatedUserDidChangeNotification";

NSString *const SocializeCLAuthorizationStatusDidChangeNotification = @"SocializeLocationManagerAuthorizationStatusDidChangeNotification";
NSString *const kSocializeCLAuthorizationStatusKey = @"kSocializeCLAuthorizationStatusKey";
NSString *const kSocializeShouldShareLocationKey = @"kSocializeShouldShareLocationKey";

NSString *const SocializeUIControllerDidFailWithErrorNotification = @"SocializeUIControllerDidFailWithErrorNotification";
NSString *const SocializeUIControllerErrorUserInfoKey = @"SocializeUIControllerErrorUserInfoKey";

NSString *const kSocializeDeviceTokenKey  = @"kSocializeDeviceTokenKey";
NSString *const kSocializeUIErrorAlertsDisabled = @"kSocializeUIErrorAlertsDisabled";

NSString *const kSocializeTwitterAuthConsumerKey = @"kSocializeTwitterAuthConsumerKey";
NSString *const kSocializeTwitterAuthConsumerSecret = @"kSocializeTwitterAuthConsumerSecret";
NSString *const kSocializeTwitterAuthAccessToken = @"kSocializeTwitterAuthAccessToken";
NSString *const kSocializeTwitterAuthAccessTokenSecret = @"kSocializeTwitterAuthAccessTokenSecret";
NSString *const kSocializeTwitterAuthScreenName = @"kSocializeTwitterAuthScreenName";
NSString *const kSocializeTwitterAuthUserId = @"kSocializeTwitterAuthUserId";

NSString *const kSocializeTwitterStringForAPI = @"Twitter";

NSString *const kSocializeFacebookAuthAppId = SOCIALIZE_FACEBOOK_APP_ID;
NSString *const kSocializeFacebookAuthLocalAppId = SOCIALIZE_FACEBOOK_LOCAL_APP_ID;
NSString *const kSocializeFacebookAuthAccessToken = @"kSocializeFacebookAuthAccessToken";
NSString *const kSocializeFacebookAuthExpirationDate = @"kSocializeFacebookAuthExpirationDate";

NSString *const kSocializeFacebookStringForAPI = @"FaceBook";


@implementation Socialize

@synthesize authService = _authService;
@synthesize likeService = _likeService;
@synthesize commentsService = _commentsService;
@synthesize entityService = _entityService;
@synthesize viewService = _viewService;
@synthesize userService = _userService;
@synthesize delegate = _delegate;
@synthesize activityService = _activityService;
@synthesize shareService = _shareService;
@synthesize deviceTokenService = _deviceTokenService;
@synthesize subscriptionService = _subscriptionService;

static Socialize *_sharedSocialize = nil;
static SocializeEntityLoaderBlock _sharedEntityLoaderBlock;
static SocializeCanLoadEntityBlock _sharedCanLoadEntityBlock;

+ (void)initialize {
    if (self == [Socialize class]) {
        Class dynamicTest = NSClassFromString(@"SocializeDynamicTest");
        NSAssert(dynamicTest != nil, @"Dynamic Class Load Error -- does your application build settings for 'other linker flags' contain the flag '-all_load'?");
    }
}

+(id)sharedSocialize {
    @synchronized(self)
    {
        if (_sharedSocialize == nil)
            _sharedSocialize = [[self alloc] initWithDelegate:nil];
    }
    return _sharedSocialize;
}

- (void)dealloc {
    [_objectFactory release]; _objectFactory = nil;
    [_authService release]; _authService = nil;
    [_likeService release]; _likeService = nil;
    [_commentsService release]; _commentsService = nil;
    [_entityService release]; _entityService = nil;
    [_viewService release]; _viewService = nil;
    [_userService release]; _userService = nil;
    [_activityService release]; _activityService = nil;
    [_shareService release]; _shareService = nil;
    [_deviceTokenService release]; _deviceTokenService = nil;
    [_subscriptionService release]; _subscriptionService = nil;
    
    [super dealloc];
}

-(id) initWithDelegate:(id<SocializeServiceDelegate>)delegate
{
    self = [super init];
    if(self != nil)
    {
        _delegate = delegate;
        _objectFactory = [[SocializeObjectFactory alloc]init];
        _authService = [[SocializeAuthenticateService alloc] initWithObjectFactory:_objectFactory delegate:delegate];
        _likeService  = [[SocializeLikeService alloc] initWithObjectFactory:_objectFactory delegate:delegate];
        _commentsService = [[SocializeCommentsService alloc] initWithObjectFactory:_objectFactory delegate:delegate];
        _entityService = [[SocializeEntityService alloc]initWithObjectFactory:_objectFactory delegate:delegate];
        _viewService  = [[SocializeViewService alloc] initWithObjectFactory:_objectFactory delegate:delegate];
        _userService = [[SocializeUserService alloc] initWithObjectFactory:_objectFactory delegate:delegate];
        _activityService = [[SocializeActivityService alloc] initWithObjectFactory:_objectFactory delegate:delegate];
        _shareService = [[SocializeShareService  alloc] initWithObjectFactory:_objectFactory delegate:delegate];
        _deviceTokenService = [[SocializeDeviceTokenService alloc] initWithObjectFactory:_objectFactory delegate:delegate];
        _subscriptionService = [[SocializeSubscriptionService alloc] initWithObjectFactory:_objectFactory delegate:delegate];
    }
    return self;
}

+(void)setEntityLoaderBlock:(SocializeEntityLoaderBlock)entityLoaderBlock {
    SocializeEntityLoaderBlock copied = [[entityLoaderBlock copy] autorelease];
    NonatomicRetainedSetToFrom(_sharedEntityLoaderBlock, copied);
}

+(SocializeEntityLoaderBlock)entityLoaderBlock {
    return _sharedEntityLoaderBlock;
}

+ (void)setCanLoadEntityBlock:(SocializeCanLoadEntityBlock)canLoadEntityBlock {
    SocializeCanLoadEntityBlock copied = [[canLoadEntityBlock copy] autorelease];
    NonatomicRetainedSetToFrom(_sharedCanLoadEntityBlock, copied);
}

+(SocializeCanLoadEntityBlock)canLoadEntityBlock {
    return _sharedCanLoadEntityBlock;
}

+(void)storeSocializeApiKey:(NSString*) key andSecret: (NSString*)secret;
{
    [self storeConsumerKey:key];
    [self storeConsumerSecret:secret];
}

+(void)storeConsumerKey:(NSString*)consumerKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    consumerKey = [consumerKey trim];
    [[NSUserDefaults standardUserDefaults] setValue:consumerKey forKey:SOCIALIZE_API_KEY];
    [defaults synchronize];
}

+(void)storeConsumerSecret:(NSString*)consumerSecret {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    consumerSecret = [consumerSecret trim];
    [[NSUserDefaults standardUserDefaults] setValue:consumerSecret forKey:SOCIALIZE_API_SECRET];
    [defaults synchronize];
}

+(void)storeFacebookAppId:(NSString*)facebookAppId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:facebookAppId forKey:SOCIALIZE_FACEBOOK_APP_ID];
    [defaults synchronize];
}

+(void)storeFacebookLocalAppId:(NSString*)facebookLocalAppId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:facebookLocalAppId forKey:SOCIALIZE_FACEBOOK_LOCAL_APP_ID];
    [defaults synchronize];
}

SYNTH_DEFAULTS_PROPERTY(NSString, TwitterConsumerKey, twitterConsumerKey, kSocializeTwitterAuthConsumerKey)
SYNTH_DEFAULTS_PROPERTY(NSString, TwitterConsumerSecret, twitterConsumerSecret, kSocializeTwitterAuthConsumerSecret)

+(void)storeApplicationLink:(NSString*)link {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:link forKey:SOCIALIZE_APPLICATION_LINK];
    [defaults synchronize];
}

+(void)removeApplicationLink{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:SOCIALIZE_APPLICATION_LINK];
    [defaults synchronize];
}

+(void)storeDisableBranding:(BOOL)disableBranding {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:disableBranding] forKey:kSocializeDisableBrandingKey];
    [defaults synchronize];
}

+ (BOOL)disableBranding {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeDisableBrandingKey] boolValue];
}

+(void)storeUIErrorAlertsDisabled:(BOOL)disabled {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:disabled] forKey:kSocializeUIErrorAlertsDisabled];
    [defaults synchronize];
}

+(NSString*) apiKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:SOCIALIZE_API_KEY];
}

+(NSString*) apiSecret
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:SOCIALIZE_API_SECRET];
}

+(NSString*) facebookAppId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:SOCIALIZE_FACEBOOK_APP_ID];
}

+(NSString*) facebookLocalAppId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:SOCIALIZE_FACEBOOK_LOCAL_APP_ID];
}

+(NSString*) applicationLink
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:SOCIALIZE_APPLICATION_LINK];
}

+ (BOOL)isSocializeNotification:(NSDictionary*)userInfo {
    return [SocializeNotificationHandler isSocializeNotification:userInfo];
}

+ (BOOL)handleNotification:(NSDictionary*)userInfo {
    return [[SocializeNotificationHandler sharedNotificationHandler] handleSocializeNotification:userInfo];
}

#pragma mark authentication info

+(BOOL)handleOpenURL:(NSURL *)url {
    return [[SocializeFacebookAuthHandler sharedFacebookAuthHandler] handleOpenURL:url];
}

-(void)authenticateWithApiKey:(NSString*)apiKey 
          apiSecret:(NSString*)apiSecret
{
   [_authService authenticateWithApiKey:apiKey apiSecret:apiSecret]; 
}

-(void)setDelegate:(id<SocializeServiceDelegate>)delegate{
    _delegate = delegate;
    _authService.delegate = delegate;
    _likeService.delegate = delegate;
    _commentsService.delegate = delegate;
    _entityService.delegate = delegate;
    _viewService.delegate = delegate;
    _activityService.delegate = delegate;
    _userService.delegate = delegate;
    _deviceTokenService.delegate = delegate;
}

/**
 * Deprecated legacy behavior (should go soon)
 */
-(void)authenticateWithFacebook {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"];
    NSDate *expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"FBExpirationDateKey"];
    if ([accessToken length] == 0 && [[NSDate date] timeIntervalSinceDate:expirationDate] > 0 ) {
        return;
    }
    [SocializeThirdPartyFacebook storeLocalCredentialsWithAccessToken:accessToken expirationDate:expirationDate];
    [self linkToFacebookWithAccessToken:accessToken expirationDate:expirationDate];
}

- (void)linkToTwitterWithAccessToken:(NSString*)twitterAccessToken accessTokenSecret:(NSString*)twitterAccessTokenSecret {
    [SocializeThirdPartyTwitter storeLocalCredentialsWithAccessToken:twitterAccessToken accessTokenSecret:twitterAccessTokenSecret];
    [_authService linkToTwitterWithAccessToken:twitterAccessToken accessTokenSecret:twitterAccessTokenSecret];
}

- (void)linkToFacebookWithAccessToken:(NSString*)facebookAccessToken expirationDate:(NSDate*)expirationDate {
    [SocializeThirdPartyFacebook storeLocalCredentialsWithAccessToken:facebookAccessToken expirationDate:[NSDate distantFuture]];
    [_authService linkToFacebookWithAccessToken:facebookAccessToken];
}

- (void)authenticateViaTwitterWithOptions:(SocializeTwitterAuthOptions*)options
                                  display:(id)display
                                  success:(void(^)())success
                                  failure:(void(^)(NSError *error))failure {
    
    [SocializeTwitterAuthenticator authenticateViaTwitterWithOptions:options display:display success:success failure:failure];
}

-(void)authenticateAnonymously
{
    NSString *apiKey = [Socialize apiKey];
    NSString *apiSecret = [Socialize apiSecret];
    
    NSAssert(apiKey != nil, @"Missing api key. API key must be configured before using socialize. [Socialize storeApiKey:Secret]");
    NSAssert(apiSecret != nil, @"Missing api secret. API secret must be configured before using socialize.[Socialize storeApiKey:Secret]");
    
    [self authenticateWithApiKey:apiKey apiSecret:apiSecret];
}

-(void)authenticateWithApiKey:(NSString*)apiKey 
                    apiSecret:(NSString*)apiSecret 
          thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
              thirdPartyAppId:(NSString*)thirdPartyAppId
               thirdPartyName:(SocializeThirdPartyAuthType)thirdPartyName
{
    NSAssert(thirdPartyName == SocializeThirdPartyAuthTypeFacebook, @"Only Facebook was/is supported in this (deprecated) call");

    [Socialize storeConsumerKey:apiKey];
    [Socialize storeConsumerSecret:apiSecret];
    [Socialize storeFacebookAppId:thirdPartyAppId];
    [self linkToFacebookWithAccessToken:thirdPartyAuthToken expirationDate:[NSDate distantFuture]];
}     

-(void)authenticateWithApiKey:(NSString*)apiKey
                    apiSecret:(NSString*)apiSecret
              thirdPartyAppId:(NSString*)thirdPartyAppId 
         thirdPartyLocalAppId:(NSString*)thirdPartyLocalAppId 
               thirdPartyName:(SocializeThirdPartyAuthType)thirdPartyName
{
    NSAssert(thirdPartyName == SocializeThirdPartyAuthTypeFacebook, @"Only Facebook was/is supported in this (deprecated) call");
    [Socialize storeConsumerKey:apiKey];
    [Socialize storeConsumerSecret:apiSecret];
    [Socialize storeFacebookAppId:thirdPartyAppId];
    [Socialize storeFacebookLocalAppId:thirdPartyLocalAppId];

    SocializeFacebookAuthOptions *options = [SocializeFacebookAuthOptions options];
    options.doNotPromptForPermission = YES;
    [SocializeFacebookAuthenticator authenticateViaFacebookWithOptions:options
                                                               display:nil
                                                               success:nil
                                                               failure:nil];
}

-(void)authenticateWithApiKey:(NSString*)apiKey
                    apiSecret:(NSString*)apiSecret
              thirdPartyAppId:(NSString*)thirdPartyAppId 
               thirdPartyName:(SocializeThirdPartyAuthType)thirdPartyName
{
    [self authenticateWithApiKey:apiKey apiSecret:apiSecret thirdPartyAppId:thirdPartyAppId thirdPartyLocalAppId:nil thirdPartyName:thirdPartyName];
}

-(id<SocializeUser>)authenticatedUser {
    return _authService.authenticatedUser;
}

-(BOOL)isAuthenticated{
    return [SocializeAuthenticateService isAuthenticated];
}

-(BOOL)isAuthenticatedWithAuthType:(NSString*)authType
{
    if (![self isAuthenticated]) {
        return NO;
    }
    
    for (NSDictionary *auth in [[self authenticatedUser] thirdPartyAuth]) {
        if ([[auth objectForKey:@"auth_type"] isEqualToString:authType]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)authenticateWithThirdPartyAuthType:(SocializeThirdPartyAuthType)type
                       thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                 thirdPartyAuthTokenSecret:(NSString*)thirdPartyAuthTokenSecret {
    [_authService authenticateWithThirdPartyAuthType:type thirdPartyAuthToken:thirdPartyAuthToken thirdPartyAuthTokenSecret:thirdPartyAuthTokenSecret];
}

-(BOOL)isAuthenticatedWithFacebook {
    return [SocializeThirdPartyFacebook isLinkedToSocialize];
}

-(BOOL)isAuthenticatedWithTwitter {
    return [SocializeThirdPartyTwitter isLinkedToSocialize];
}

- (BOOL)isAuthenticatedWithThirdParty {
    return [SocializeThirdPartyFacebook isLinkedToSocialize] || [SocializeThirdPartyTwitter isLinkedToSocialize];
}

- (BOOL)thirdPartyAvailable {
    return [SocializeThirdPartyFacebook available] || [SocializeThirdPartyTwitter available];
}

- (void)removeSocializeAuthenticationInfo {
    [_authService removeSocializeAuthenticationInfo];
}

-(void)removeAuthenticationInfo {
    [self removeSocializeAuthenticationInfo];
    [SocializeThirdPartyFacebook removeLocalCredentials];
    [SocializeThirdPartyTwitter removeLocalCredentials];
}

#pragma object creation

-(id)createObjectForProtocol:(Protocol *)protocol{
    return [_objectFactory createObjectForProtocol:protocol];
}

#pragma mark like related stuff

-(void)likeEntityWithKey:(NSString*)key longitude:(NSNumber*)lng latitude:(NSNumber*)lat
{
    [_likeService postLikeForEntityKey:key andLongitude:lng latitude:lat]; 
}

-(void)unlikeEntity:(id<SocializeLike>)like
{
    [_likeService deleteLike:like]; 
}

- (void)createLike:(id<SocializeLike>)like {
    [_likeService createLike:like];
}

- (void)createLikes:(NSArray*)likes {
    [_likeService createLikes:likes];
}

-(void)getLikesForEntityKey:(NSString*)key first:(NSNumber*)first last:(NSNumber*)last{
    [_likeService getLikesForEntityKey:key first:first last:last] ;
}

#pragma comment related  stuff

-(void)getCommentById: (int) commentId{
    [_commentsService getCommentById:commentId];
}

-(void)getCommentList: (NSString*) entryKey first:(NSNumber*)first last:(NSNumber*)last{
    [_commentsService getCommentList:entryKey first:first last:last];
}

-(void)createCommentForEntityWithKey:(NSString*)entityKey comment:(NSString*) comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat{
    [_commentsService createCommentForEntityWithKey:entityKey comment:comment longitude: lng latitude: lat];
}

-(void)createCommentForEntityWithKey:(NSString*)entityKey comment:(NSString*)comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat subscribe:(BOOL)subscribe {
    [_commentsService createCommentForEntityWithKey:entityKey comment:comment longitude:lng latitude:lat subscribe:subscribe];
}

-(void)createCommentForEntity:(id<SocializeEntity>) entity comment: (NSString*) comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat{
    [_commentsService createCommentForEntity:entity comment:comment longitude: lng latitude: lat];
}

-(void) createCommentForEntity: (id<SocializeEntity>) entity comment: (NSString*) comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat subscribe:(BOOL)subscribe {
    [_commentsService createCommentForEntity:entity comment:comment longitude:lng latitude:lat subscribe:subscribe];    
}

- (void)createComment:(id<SocializeComment>)comment {
    [_commentsService createComment:comment];
}

- (void)createComments:(NSArray*)comments {
    [_commentsService createComments:comments];
}

#pragma entity related stuff

-(void)getEntityByKey:(NSString *)entitykey{
    [_entityService entityWithKey:entitykey];
}

-(void)createEntity:(id<SocializeEntity>)entity {
    [_entityService createEntity:entity];
}

-(void)createEntityWithKey:(NSString*)entityKey name:(NSString*)name{
    [_entityService createEntityWithKey:entityKey andName:name];
}

#pragma mark view related stuff
-(void)createEntityWithUrl:(NSString*)entityKey andName:(NSString*)name{
    [self createEntityWithKey:entityKey name:name];
}

#pragma view related stuff

-(void)viewEntityWithKey:(NSString*)url longitude:(NSNumber*)lng latitude: (NSNumber*)lat {
    [_viewService createViewForEntityKey:url longitude:lng latitude:lat];
}

-(void)viewEntity:(id<SocializeEntity>)entity longitude:(NSNumber*)lng latitude: (NSNumber*)lat{
    [_viewService createViewForEntity:entity longitude:lng latitude:lat];
}

/*
-(void)getViewsForEntityKey:(NSString*)url  first:(NSNumber*)first last:(NSNumber*)last {
    [_viewService getViewsForEntityKey:url first:first last:last];
}
 */

#pragma mark user related stuff
-(void)getCurrentUser
{
    [_userService getCurrentUser];
}

-(void)getUserWithId:(int)userId
{
    [_userService getUserWithId:userId];
}

-(void)updateUserProfile:(id<SocializeFullUser>)user
{
    [_userService updateUser:user];
}

-(void)updateUserProfile:(id<SocializeFullUser>)user profileImage:(id)profileImage
{
    [_userService updateUser:user profileImage:profileImage];
}

#pragma mark activity related stuff
-(void)getActivityOfCurrentApplication
{
    [_activityService getActivityOfCurrentApplication];
}

-(void)getActivityOfUser:(id<SocializeUser>)user
{
    [_activityService getActivityOfUser:user];
}

-(void)getActivityOfUserId:(NSInteger)userId {
    [_activityService getActivityOfUserId:userId];
}

-(void)getActivityOfUserId:(NSInteger)userId first:(NSNumber*)first last:(NSNumber*)last activity:(SocializeActivityType)activityType {
    [_activityService getActivityOfUserId:userId first:first last:last activity:activityType];
}

#pragma mark share service stuff
-(void)createShareForEntity:(id<SocializeEntity>)entity medium:(SocializeShareMedium)medium  text:(NSString*)text
{
    [_shareService createShareForEntity:entity medium:medium text:text];
}

-(void)createShareForEntityWithKey:(NSString*)key medium:(SocializeShareMedium)medium  text:(NSString*)text {
    [_shareService createShareForEntityKey:key medium:medium text:text];
}

- (void)createShare:(id<SocializeShare>)share {
    [_shareService createShare:share];
}

#pragma mark notification service stuff
+(void)registerDeviceToken:(NSData *)deviceToken {
    [[SocializeDeviceTokenSender sharedDeviceTokenSender] registerDeviceToken:deviceToken];
}   

#pragma mark subscription types
- (void)subscribeToCommentsForEntityKey:(NSString*)entityKey {
    [_subscriptionService subscribeToCommentsForEntityKey:entityKey];
}

- (void)unsubscribeFromCommentsForEntityKey:(NSString*)entityKey {
    [_subscriptionService unsubscribeFromCommentsForEntityKey:entityKey];
}

- (void)getSubscriptionsForEntityKey:(NSString*)entityKey first:(NSNumber*)first last:(NSNumber*)last {
    [_subscriptionService getSubscriptionsForEntityKey:entityKey first:first last:last];
}

- (BOOL)notificationsAreConfigured {
    BOOL entityLoaderDefined = [Socialize entityLoaderBlock] != nil;
    BOOL tokenAvailable = [[SocializeDeviceTokenSender sharedDeviceTokenSender] tokenAvailable];
    
    return entityLoaderDefined && tokenAvailable;
}

- (void)_registerDeviceTokenString:(NSString*)deviceTokenString {
    [_deviceTokenService registerDeviceTokenString:deviceTokenString];
}

+ (void)createShareWithOptions:(SocializeUIShareOptions*)options display:(id)display success:(void(^)())success failure:(void(^)(NSError *error))failure {
    [SocializeUIShareCreator createShareWithOptions:options display:display success:success failure:failure];
}

@end
