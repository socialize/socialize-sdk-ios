//
//  SocializeService.m
//  SocializeSDK
//
//  Created by William Johnson on 5/31/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "_Socialize.h"

#import <SZBlockskit/Blockskit.h>
#import <Loopy/Loopy.h>
#import <AFNetworking/AFNetworking.h>
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
#import "StringHelper.h"
#import "SocializeDeviceTokenSender.h"
#import "SocializeFacebookAuthHandler.h"
#import "SocializeThirdPartyTwitter.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeEventService.h"
#import "SZTwitterUtils.h"
#import "SZFacebookUtils.h"
#import "SocializePrivateDefinitions.h"
#import "socialize_globals.h"
#import "SZNotificationHandler.h"
#import "SZOpenURLHandler.h"
#import "SZEntityUtils.h"
#import "SZSmartAlertUtils.h"
#import "SZPinterestEngine.h"
#import "SZViewControllerWrapper.h"
#import "UIDevice+VersionCheck.h"
#import "UIColor+Socialize.h"

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

#define SYNTH_DEFAULTS_BOOL_GETTER(NAME, STORE_KEY) \
+ (BOOL)NAME { \
    return [[[NSUserDefaults standardUserDefaults] objectForKey:STORE_KEY] boolValue]; \
}

#define SYNTH_DEFAULTS_BOOL_SETTER(NAME, STORE_KEY) \
+ (void)store ## NAME : (BOOL)value { \
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; \
    [defaults setValue:[NSNumber numberWithBool:value] forKey:STORE_KEY]; \
    [defaults synchronize]; \
}

#define SYNTH_DEFAULTS_PROPERTY(TYPE, UPPERNAME, LOWERNAME, STORE_KEY) \
SYNTH_DEFAULTS_SETTER(TYPE, UPPERNAME, STORE_KEY) \
SYNTH_DEFAULTS_GETTER(TYPE, LOWERNAME, STORE_KEY)

#define SYNTH_DEFAULTS_BOOL_PROPERTY(UPPERNAME, LOWERNAME, STORE_KEY) \
SYNTH_DEFAULTS_BOOL_SETTER(UPPERNAME, STORE_KEY) \
SYNTH_DEFAULTS_BOOL_GETTER(LOWERNAME, STORE_KEY)

NSString *const kSocializeDisableBrandingKey = @"kSocializeDisableBrandingKey";

NSString *const kSocializeConsumerKey = SOCIALIZE_API_KEY;
NSString *const kSocializeConsumerSecret = SOCIALIZE_API_SECRET;
NSString *const kSocializeAccessToken = @"OAUTH_AUTH_SOCIALIZE_KEY";
NSString *const kSocializeAccessTokenSecret = @"OAUTH_AUTH_SOCIALIZE_SECRET";

NSString *const SocializeAuthenticatedUserDidChangeNotification = @"SocializeAuthenticatedUserDidChangeNotification";
NSString *const SZUserSettingsDidChangeNotification = @"SZUserSettingsDidChangeNotification";
NSString *const kSZUpdatedUserSettingsKey = @"kSZUpdatedUserSettingsKey";
NSString *const kSZUpdatedUserKey = @"kSZUpdatedUserKey";
NSString *const SZEntityDidChangeNotification = @"SZEntityDidChangeNotification";

NSString *const SZDidCreateObjectsNotification = @"SZDidCreateObjectsNotification";
NSString *const kSZCreatedObjectsKey = @"kSZCreatedObjectsKey";

NSString *const SZDidDeleteObjectsNotification = @"SZDidDeleteObjectsNotification";
NSString *const kSZDeletedObjectsKey = @"kSZDeletedObjectsKey";

NSString *const SZDidFetchObjectsNotification = @"SZDidFetchObjectsNotification";
NSString *const kSZFetchedObjectsKey = @"kSZFetchedObjectsKey";

NSString *const SocializeEntityLoaderDidFinishNotification = @"SocializeEntityLoaderDidFinishNotification";

NSString *const SocializeCLAuthorizationStatusDidChangeNotification = @"SocializeLocationManagerAuthorizationStatusDidChangeNotification";
NSString *const kSocializeCLAuthorizationStatusKey = @"kSocializeCLAuthorizationStatusKey";
NSString *const kSocializeShouldShareLocationKey = @"kSocializeShouldShareLocationKey";

NSString *const SZLocationDidChangeNotification = @"SZLocationDidChangeNotification";
NSString *const kSZNewLocationKey = @"kSZNewLocationKey";

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

NSString *const kSocializeDontPostToFacebookKey = kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY;
NSString *const kSocializeDontPostToTwitterKey = kSOCIALIZE_DONT_POST_TO_TWITTER_KEY;
NSString *const kSocializeAutoPostToSocialNetworksKey = @"kSocializeAutoPostToSocialNetworksKey";

NSString *const kSocializeFacebookStringForAPI = @"FaceBook";

// Authentication settings
NSString *const kSocializeAuthenticationNotRequired = @"kSocializeAuthenticationNotRequired";
NSString *const kSocializeLocationSharingDisabled = @"kSocializeLocationSharingDisabled";
NSString *const kSocializeAnonymousAllowed = @"kSocializeAnonymousAllowed";

NSString *const SocializeDidRegisterDeviceTokenNotification = @"SocializeDidRegisterDeviceTokenNotification";
NSString *const SZLikeButtonDidChangeStateNotification = @"SZLikeButtonDidChangeStateNotification";

NSString *const kSocializeOGLikeEnabled = @"kSocializeOGLikeEnabled";

NSString *const SocializeShouldDismissAllNotificationControllersNotification = @"SocializeShouldDismissAllNotificationControllersNotification";


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
@synthesize eventsService = _eventsService;

static Socialize *_sharedSocialize;

+ (void)initialize {
    if (self == [Socialize class]) {
//        Class dynamicTest = NSClassFromString(@"SocializeDynamicTest");
//        NSAssert(dynamicTest != nil, @"Dynamic Class Load Error -- does your application build settings for 'other linker flags' contain the flag '-all_load'?");
        
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
    [_eventsService release]; _eventsService = nil;
    
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
        _eventsService = [[SocializeEventService alloc] initWithObjectFactory:_objectFactory delegate:delegate];
        
        //iOS 7 navbar standard init
        if([[UIDevice currentDevice] systemMajorVersion] >= 7) {
            UIColor *barColor = [UIColor navigationBarBackgroundColor];
            NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor], NSForegroundColorAttributeName,
                                                       nil];
            [[UINavigationBar appearanceWhenContainedIn:[SZViewControllerWrapper class], nil] setBarTintColor:barColor];
            [[UINavigationBar appearanceWhenContainedIn:[SZViewControllerWrapper class], nil] setTintColor:[UIColor whiteColor]];
            [[UINavigationBar appearanceWhenContainedIn:[SZViewControllerWrapper class], nil] setTitleTextAttributes:navbarTitleTextAttributes];
        }
        
        //Loopy init
        [Socialize sharedLoopyAPIClient];
    }
    return self;
}

+ (id)sharedLoopyAPIClient {
    static STAPIClient *loopyAPIClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loopyAPIClient = [[STAPIClient alloc] initWithAPIKey:[Socialize loopyAppID]
                                                    loopyKey:[Socialize loopyKey]
                                           locationsDisabled:[self locationSharingDisabled]];
        [loopyAPIClient getSessionWithReferrer:@"www.facebook.com" //this is temporary until referrer clarified
                                   postSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       }];
    });
    return loopyAPIClient;
}

+ (NSString *)loopyAppID {
    //FIXME need Loopy keys to match Socialize keys
    return @"be6a5004-6abb-4382-a131-8d6812a9e74b";
    return [Socialize consumerKey];
}

+ (NSString *)loopyKey {
    //FIXME need Loopy keys
    return @"3d4pnhzpar8bz8t44w7hb42k";
    return [Socialize consumerSecret];
}

+ (NSString *)socializeVersion {
    return SOCIALIZE_VERSION_STRING;
}

- (void)cancelAllRequests {
    [_authService cancelAllRequests];
    [_likeService cancelAllRequests];
    [_commentsService cancelAllRequests];
    [_entityService cancelAllRequests];
    [_viewService cancelAllRequests];
    [_userService cancelAllRequests];
    [_activityService cancelAllRequests];
    [_shareService cancelAllRequests];
    [_deviceTokenService cancelAllRequests];
    [_subscriptionService cancelAllRequests];
    [_eventsService cancelAllRequests];
}

+(void)setEntityLoaderBlock:(SocializeEntityLoaderBlock)entityLoaderBlock {
    [SZEntityUtils setEntityLoaderBlock:entityLoaderBlock];
}

+(void)setNewCommentsNotificationBlock:(SocializeNewCommentsNotificationBlock)newCommentsBlock {
    [SZSmartAlertUtils setNewCommentsNotificationBlock:newCommentsBlock];
}

+(SocializeEntityLoaderBlock)entityLoaderBlock {
    return [SZEntityUtils entityLoaderBlock];
}

+ (void)setCanLoadEntityBlock:(SocializeCanLoadEntityBlock)canLoadEntityBlock {
    return [SZEntityUtils setCanLoadEntityBlock:canLoadEntityBlock];
}

+ (SocializeCanLoadEntityBlock)canLoadEntityBlock {
    return [SZEntityUtils canLoadEntityBlock];
}

+ (BOOL)canLoadEntity:(id<SocializeEntity>)entity {
    return [SZEntityUtils canLoadEntity:entity];
}

+(void)storeSocializeApiKey:(NSString*) key andSecret: (NSString*)secret;
{
    [self storeConsumerKey:key];
    [self storeConsumerSecret:secret];
}

+ (NSString*)consumerKey {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeConsumerKey];
}

+ (NSString*)consumerSecret {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeConsumerSecret];
}

+(void)storeConsumerKey:(NSString*)consumerKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    consumerKey = [consumerKey socializeTrim];
    
    NSString *existingKey = [[NSUserDefaults standardUserDefaults] objectForKey:SOCIALIZE_API_KEY];
    if (![existingKey isEqualToString:consumerKey]) {
        [[Socialize sharedSocialize] removeAuthenticationInfo];
        [[NSUserDefaults standardUserDefaults] setValue:consumerKey forKey:SOCIALIZE_API_KEY];
        [defaults synchronize];
    }
}

+(void)storeConsumerSecret:(NSString*)consumerSecret {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    consumerSecret = [consumerSecret socializeTrim];
    
    NSString *existingSecret = [[NSUserDefaults standardUserDefaults] objectForKey:SOCIALIZE_API_SECRET];
    if (![existingSecret isEqualToString:consumerSecret]) {
        [[Socialize sharedSocialize] removeAuthenticationInfo];
        [[NSUserDefaults standardUserDefaults] setValue:consumerSecret forKey:SOCIALIZE_API_SECRET];
        [defaults synchronize];
    }
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

+ (void)storeFacebookURLSchemeSuffix:(NSString *)facebookURLSchemeSuffix {
    [self storeFacebookLocalAppId:facebookURLSchemeSuffix];
}

SYNTH_DEFAULTS_PROPERTY(NSString, TwitterConsumerKey, twitterConsumerKey, kSocializeTwitterAuthConsumerKey)
SYNTH_DEFAULTS_PROPERTY(NSString, TwitterConsumerSecret, twitterConsumerSecret, kSocializeTwitterAuthConsumerSecret)

SYNTH_DEFAULTS_BOOL_PROPERTY(AuthenticationNotRequired, authenticationNotRequired, kSocializeAuthenticationNotRequired)
SYNTH_DEFAULTS_BOOL_PROPERTY(AnonymousAllowed, anonymousAllowed, kSocializeAnonymousAllowed);
SYNTH_DEFAULTS_BOOL_PROPERTY(OGLikeEnabled, OGLikeEnabled, kSocializeOGLikeEnabled);

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

//this should be set BEFORE initializing Loopy
//(i.e. before storing Socialize consumerKey and consumerSecret, which init Loopy)
+(void)storeLocationSharingDisabled:(BOOL)disableBranding {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:disableBranding] forKey:kSocializeLocationSharingDisabled];
    
    [defaults synchronize];
}

+(BOOL)locationSharingDisabled {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeLocationSharingDisabled] boolValue];
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
    return [SZNotificationHandler isSocializeNotification:userInfo];
}

+ (BOOL)openNotification:(NSDictionary*)userInfo {
    return [[SZNotificationHandler sharedNotificationHandler] openSocializeNotification:userInfo];
}

+ (BOOL)handleNotification:(NSDictionary*)userInfo {
    return [[SZNotificationHandler sharedNotificationHandler] handleSocializeNotification:userInfo];
}

#pragma mark authentication info

+(BOOL)handleOpenURL:(NSURL *)url {
    
    SDebugLog(2, @"Application was opened with URL: %@",  [url.absoluteString stringByRemovingPercentEncoding]);
    
    if ([[SZOpenURLHandler sharedOpenURLHandler] handleOpenURL:url]) {
        return YES;
    }
    
    if ([[SZPinterestEngine sharedInstance] handleOpenURL:url]) {
        return YES;
    }
    
    return [[SocializeFacebookAuthHandler sharedFacebookAuthHandler] handleOpenURL:url];
}

-(void)authenticateWithApiKey:(NSString*)apiKey 
          apiSecret:(NSString*)apiSecret
{
   [_authService authenticateWithApiKey:apiKey apiSecret:apiSecret]; 
}

-(void)authenticateWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure {
    [_authService authenticateWithApiKey:apiKey apiSecret:apiSecret success:success failure:failure]; 
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

- (void)linkToTwitterWithAccessToken:(NSString*)twitterAccessToken 
                   accessTokenSecret:(NSString *)twitterAccessTokenSecret
                             success:(void(^)(id<SZFullUser>))success
                             failure:(void(^)(NSError *error))failure {
    [SocializeThirdPartyTwitter storeLocalCredentialsWithAccessToken:twitterAccessToken accessTokenSecret:twitterAccessTokenSecret];
    [_authService linkToTwitterWithAccessToken:twitterAccessToken accessTokenSecret:twitterAccessTokenSecret success:success failure:failure];
}

- (void)linkToTwitterWithAccessToken:(NSString*)twitterAccessToken accessTokenSecret:(NSString*)twitterAccessTokenSecret {
    [self linkToTwitterWithAccessToken:twitterAccessToken accessTokenSecret:twitterAccessTokenSecret success:nil failure:nil];
}

- (void)linkToFacebookWithAccessToken:(NSString*)facebookAccessToken expirationDate:(NSDate*)expirationDate {
    [self linkToFacebookWithAccessToken:facebookAccessToken expirationDate:expirationDate success:nil failure:nil];
}

- (void)linkToFacebookWithAccessToken:(NSString*)facebookAccessToken 
                       expirationDate:(NSDate *)expirationDate
                              success:(void(^)(id<SZFullUser>))success
                              failure:(void(^)(NSError *error))failure {
    [SocializeThirdPartyFacebook storeLocalCredentialsWithAccessToken:facebookAccessToken expirationDate:[NSDate distantFuture]];
    [_authService linkToFacebookWithAccessToken:facebookAccessToken success:success failure:failure];
}

- (void)authenticateViaTwitterWithOptions:(SocializeTwitterAuthOptions*)options
                                  display:(id)display
                                  success:(void(^)())success
                                  failure:(void(^)(NSError *error))failure {
    
    [SZTwitterUtils linkWithViewController:display success:success failure:failure];
}

-(void)authenticateAnonymouslyWithSuccess:(void(^)())success
                                  failure:(void(^)(NSError *error))failure {
    
    NSString *apiKey = [Socialize apiKey];
    NSString *apiSecret = [Socialize apiSecret];
    
    NSAssert(apiKey != nil, @"Missing api key. API key must be configured before using socialize. [Socialize storeConsumerKey:]");
    NSAssert(apiSecret != nil, @"Missing api secret. API secret must be configured before using socialize.[Socialize storeConsumerSecret:]");
    
    [self authenticateWithApiKey:apiKey apiSecret:apiSecret success:success failure:failure];
}

-(void)authenticateAnonymously {
    [self authenticateAnonymouslyWithSuccess:nil failure:nil];
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

    /*
<<<<<<< HEAD:Socialize-noarc/_Socialize.m
    [SZFacebookUtils _linkWithSuccess:^(id<SZFullUser> user) {
        [self.delegate didAuthenticate:(id<SZUser>)user];
    } failure:^(NSError *error) {
        [self.delegate service:_authService didFail:error];
    }];
=======
    SocializeFacebookAuthOptions *options = [SocializeFacebookAuthOptions options];
    options.doNotPromptForPermission = YES;
    [SocializeFacebookAuthenticator authenticateViaFacebookWithOptions:options
                                                               display:nil
                                                               success:^{
                                                                   id<SocializeUser> authenticatedUser = [self authenticatedUser];
                                                                   if ([self.delegate respondsToSelector:@selector(didAuthenticate:)]) {
                                                                       [self.delegate didAuthenticate:authenticatedUser];
                                                                   }
                                                               } failure:^(NSError *error) {
                                                                   if ([self.delegate respondsToSelector:@selector(service:didFail:)]) {
                                                                       [self.delegate service:_authService didFail:error];
                                                                   }
                                                               }];
>>>>>>> master:Socialize/Classes/_Socialize.m
*/
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

-(id<SocializeFullUser>)authenticatedFullUser {
    return _authService.authenticatedFullUser;
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

#pragma mark object creation

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

- (void)deleteLikeForUser:(id<SZFullUser>)user entity:(id<SZEntity>)entity success:(void(^)(id<SZLike>))success failure:(void(^)(NSError *error))failure {
    [_userService deleteLikeForUser:user entity:entity success:success failure:failure];
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

#pragma mark comment related  stuff

-(void)getCommentById: (int) commentId{
    [_commentsService getCommentById:commentId];
}

-(void)getCommentList: (NSString*) entryKey first:(NSNumber*)first last:(NSNumber*)last{
    [_commentsService getCommentList:entryKey first:first last:last];
}

- (void)getCommentsWithIds:(NSArray*)commentIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [_commentsService getCommentsWithIds:commentIds success:success failure:failure];
}
- (void)getCommentsWithEntityKey:(NSString*)entityKey success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [_commentsService getCommentsWithEntityKey:entityKey success:success failure:failure];
}

- (void)getCommentsWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [_commentsService getCommentsWithFirst:first last:last success:success failure:failure];
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

- (void)createComments:(NSArray*)comments success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [_commentsService createComments:comments success:success failure:failure];
}

- (void)createComment:(id<SZComment>)comment success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    [_commentsService createComment:comment success:success failure:failure];
}

#pragma mark entity related stuff

-(void)getEntityByKey:(NSString *)entitykey{
    [_entityService entityWithKey:entitykey];
}

-(void)createEntity:(id<SocializeEntity>)entity {
    [_entityService createEntity:entity];
}

-(void)createEntityWithKey:(NSString*)entityKey name:(NSString*)name{
    [_entityService createEntityWithKey:entityKey andName:name];
}

-(void)createEntityWithUrl:(NSString*)entityKey andName:(NSString*)name{
    [self createEntityWithKey:entityKey name:name];
}

- (void)createEntities:(NSArray*)entities success:(void(^)(id entityOrEntities))success failure:(void(^)(NSError *error))failure {
    [_entityService createEntities:entities success:success failure:failure];
}

#pragma mark view related stuff

-(void)viewEntityWithKey:(NSString*)url longitude:(NSNumber*)lng latitude: (NSNumber*)lat {
    [_viewService createViewForEntityKey:url longitude:lng latitude:lat];
}

-(void)viewEntity:(id<SocializeEntity>)entity longitude:(NSNumber*)lng latitude: (NSNumber*)lat{
    [_viewService createViewForEntity:entity longitude:lng latitude:lat];
}

- (void)createView:(id<SocializeView>)view {
    [_viewService createView:view];
}

- (void)createViews:(NSArray*)views {
    [_viewService createViews:views];
}

- (void)createViews:(NSArray*)views success:(void(^)(NSArray *views))success failure:(void(^)(NSError *error))failure {
    [_viewService createViews:views success:success failure:failure];
}

- (void)createView:(id<SZView>)view success:(void(^)(id<SZView>))success failure:(void(^)(NSError *error))failure {
    [_viewService createView:view success:success failure:failure];
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

-(void) getUsersWithIds:(NSArray*)ids success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure {
    [_userService getUsersWithIds:ids success:success failure:failure];
}

-(void)updateUserProfile:(id<SocializeFullUser>)user
{
    [_userService updateUser:user];
}

-(void)updateUserProfile:(id<SocializeFullUser>)user profileImage:(id)profileImage
{
    [_userService updateUser:user profileImage:profileImage];
}

- (void)updateUserProfile:(id<SocializeFullUser>)user
             profileImage:(UIImage*)image
                  success:(void(^)(id<SocializeFullUser> user))success
                  failure:(void(^)(NSError *error))failure {
    [_userService updateUser:user profileImage:image success:success failure:failure];
}

- (void)getLikesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last {
    [_userService getLikesForUser:user entity:entity first:first last:last];
}

- (void)getSharesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last {
    [_userService getSharesForUser:user entity:entity first:first last:last];
}

- (void)getLikesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure {
    [_userService getLikesForUser:user entity:entity first:first last:last success:success failure:failure];
}

- (void)getSharesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure {
    [_userService getSharesForUser:user entity:entity first:first last:last success:success failure:failure];
}

- (void)getCommentsForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure {
    [_userService getCommentsForUser:user entity:entity first:first last:last success:success failure:failure];
}

- (void)getActivityForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure {
    [_userService getActivityForUser:user entity:entity first:first last:last success:success failure:failure];    
}

- (void)getLikesWithIds:(NSArray*)likeIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [_likeService getLikesWithIds:likeIds success:success failure:failure];
}

- (void)getLikesForEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *likes))success failure:(void(^)(NSError *error))failure {
    [_likeService getLikesForEntity:entity first:first last:last success:success failure:failure];
}

- (void)getLikesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [_likeService getLikesWithFirst:first last:last success:success failure:failure];
}

- (void)createLikes:(NSArray*)likes success:(void(^)(id entityOrEntities))success failure:(void(^)(NSError *error))failure {
    [_likeService createLikes:likes success:success failure:failure];
}

- (void)createLike:(id<SZLike>)like success:(void(^)(id<SZLike> like))success failure:(void(^)(NSError *error))failure {
    [_likeService createLike:like success:success failure:failure];
}

- (void)getActivityOfApplicationWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [_activityService getActivityOfApplicationWithFirst:first last:last success:success failure:failure];
}

- (void)getActivityOfEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [_activityService getActivityOfEntity:entity first:first last:last success:success failure:failure];
}


#pragma mark activity related stuff
-(void)getActivityOfCurrentApplication
{
    [_activityService getActivityOfCurrentApplication];
}

-(void)getActivityOfCurrentApplicationWithFirst:(NSNumber*)first last:(NSNumber*)last {
    [_activityService getActivityOfCurrentApplicationWithFirst:first last:last];
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

-(void)getSharesWithIds:(NSArray*)shareIds success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    [_shareService getSharesWithIds:shareIds success:success failure:failure];
}

-(void)getShareWithId:(NSNumber*)shareId success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    [_shareService getShareWithId:shareId success:success failure:failure];
}

- (void)getSharesForEntityKey:(NSString*)key first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    [_shareService getSharesForEntityKey:key first:first last:last success:success failure:failure];
}

- (void)getSharesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    [_shareService getSharesWithFirst:first last:last success:success failure:failure];
}


#pragma mark notification service stuff
+(void)registerDeviceToken:(NSData *)deviceToken development:(BOOL)development {
    [[SocializeDeviceTokenSender sharedDeviceTokenSender] registerDeviceToken:deviceToken development:development];
}   

+(void)registerDeviceToken:(NSData *)deviceToken {
    [self registerDeviceToken:deviceToken development:NO];
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

- (void)getSubscriptionsForEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *subscriptions))success failure:(void(^)(NSError *error))failure {
    [_subscriptionService getSubscriptionsForEntity:entity first:first last:last success:success failure:failure];
}

- (void)createSubscriptions:(NSArray*)subscriptions success:(void(^)(NSArray *subscriptions))success failure:(void(^)(NSError *error))failure {
    [_subscriptionService createSubscriptions:subscriptions success:success failure:failure];
}

- (void)createSubscription:(id<SZSubscription>)subscription success:(void(^)(id<SZSubscription>))success failure:(void(^)(NSError *error))failure {
    [_subscriptionService createSubscription:subscription success:success failure:failure];
}

- (BOOL)notificationsAreConfigured {
    BOOL entityLoaderDefined = [Socialize entityLoaderBlock] != nil;
    BOOL tokenAvailable = [[SocializeDeviceTokenSender sharedDeviceTokenSender] tokenAvailable];
    
    return entityLoaderDefined && tokenAvailable;
}

- (void)_registerDeviceTokenString:(NSString*)deviceTokenString development:(BOOL)development {
    [_deviceTokenService registerDeviceTokenString:deviceTokenString development:development];
}

- (void)_registerDeviceTokenString:(NSString*)deviceTokenString {
    [self _registerDeviceTokenString:deviceTokenString development:NO];
}

/*
+ (void)showShareActionSheetWithViewController:(UIViewController*)viewController entity:(id<SocializeEntity>)entity success:(void(^)())success failure:(void(^)(NSError *error))failure {
    SocializeUIShareOptions *options = [SocializeUIShareOptions UIShareOptionsWithEntity:entity];
    [SocializeUIShareCreator createShareWithOptions:options display:viewController success:success failure:failure];
}

+ (void)createShareWithOptions:(SocializeUIShareOptions*)options display:(id)display success:(void(^)())success failure:(void(^)(NSError *error))failure {
    [SocializeUIShareCreator createShareWithOptions:options display:display success:success failure:failure];
}

*/
- (void)getEntitiesWithIds:(NSArray*)entityIds {
    [_entityService getEntitiesWithIds:entityIds];
}

- (void)getEntitiesWithIds:(NSArray*)entityIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [_entityService getEntitiesWithIds:entityIds success:success failure:failure];
}

- (void)getEntityWithId:(NSNumber*)entityId {
    [_entityService getEntityWithId:entityId];
}

- (void)getEntityWithKey:(NSString*)entityKey success:(void(^)(NSArray *entities))success failure:(void(^)(NSError *error))failure {
    [_entityService getEntityWithKey:entityKey success:success failure:failure];
}

- (void)getEntitiesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *entities))success failure:(void(^)(NSError *error))failure {
    [_entityService getEntitiesWithFirst:first last:last success:success failure:failure];
}

- (void)getEntitiesWithSorting:(SZResultSorting)sorting first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *entities))success failure:(void(^)(NSError *error))failure {
    [_entityService getEntitiesWithSorting:sorting first:first last:last success:success failure:failure];
}

- (void)trackEventWithBucket:(NSString*)bucket values:(NSDictionary*)values {
    [_eventsService trackEventWithBucket:bucket values:values];
}

- (void)trackEventWithBucket:(NSString*)bucket values:(NSDictionary*)values success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    [_eventsService trackEventWithBucket:bucket values:values success:success failure:failure];
}

- (void)createShare:(id<SocializeShare>)share success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    [_shareService createShare:share success:success failure:failure];
}

- (void)createShare:(id<SocializeShare>)share
            success:(void(^)(id<SZShare> share))success
            failure:(void(^)(NSError *error))failure
       loopySuccess:(id)loopySuccess
       loopyFailure:(id)loopyFailure {
    [_shareService createShare:share success:success failure:failure loopySuccess:loopySuccess loopyFailure:loopyFailure];
}
@end
