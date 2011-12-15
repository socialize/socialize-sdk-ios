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
#import "Facebook+Socialize.h"
#import "NSTimer+BlocksKit.h"

#define SOCIALIZE_API_KEY @"socialize_api_key"
#define SOCIALIZE_API_SECRET @"socialize_api_secret"
#define SOCIALIZE_FACEBOOK_LOCAL_APP_ID @"socialize_facebook_local_app_id"
#define SOCIALIZE_FACEBOOK_APP_ID @"socialize_facebook_app_id"
#define SOCIALIZE_APPLICATION_LINK @"socialize_app_link"
#define SOCIALIZE_DEVICE_TOKEN @"socialize_device_token"

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
    [_sharedSocialize release]; _sharedSocialize = nil;
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

+(void)storeSocializeApiKey:(NSString*) key andSecret: (NSString*)secret;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:SOCIALIZE_API_KEY];
    [defaults setValue:secret forKey:SOCIALIZE_API_SECRET];
    [defaults synchronize];
}

+(void)storeDeviceToken:(NSString*)deviceToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:deviceToken forKey:SOCIALIZE_DEVICE_TOKEN];
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

-(NSString*) receiveFacebookAuthToken {
    return [_authService receiveFacebookAuthToken];
}

+(NSString *) deviceToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:SOCIALIZE_DEVICE_TOKEN];
}
+(NSString*) applicationLink
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:SOCIALIZE_APPLICATION_LINK];
}

#pragma mark authentication info

+(BOOL)handleOpenURL:(NSURL *)url {
    return [SocializeAuthenticateService handleOpenURL:url];
}

-(void)authenticateWithApiKey:(NSString*)apiKey 
          apiSecret:(NSString*)apiSecret
{
   if ([SocializeAuthenticateService isAuthenticated])
       [_authService removeAuthenticationInfo];

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
}

-(void)authenticateWithFacebook {
    NSLog(@"inside authenticateWithFacebook");
    
    NSString *apiKey = [Socialize apiKey];
    NSString *apiSecret = [Socialize apiSecret];
    NSString *facebookAppId = [Socialize facebookAppId];
    NSString *facebookLocalAppId = [Socialize facebookLocalAppId];
    
    NSAssert(apiKey != nil, @"Missing api key. API key must be configured before using socialize.");
    NSAssert(apiSecret != nil, @"Missing api secret. API secret must be configured before using socialize.");
    NSAssert(facebookAppId != nil, @"Missing facebook app id. Facebook app id is required to authenticate with facebook.");
    
    [self authenticateWithApiKey:apiKey apiSecret:apiSecret thirdPartyAppId:facebookAppId thirdPartyLocalAppId:facebookLocalAppId thirdPartyName:SocializeThirdPartyAuthTypeFacebook];
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
    if ([SocializeAuthenticateService isAuthenticated])
        [_authService removeAuthenticationInfo];
    
    [_authService  authenticateWithApiKey:apiKey 
                                apiSecret:apiSecret
                      thirdPartyAuthToken:thirdPartyAuthToken
                          thirdPartyAppId:thirdPartyAppId
                           thirdPartyName:thirdPartyName
     ];
}     

-(void)authenticateWithApiKey:(NSString*)apiKey
                    apiSecret:(NSString*)apiSecret
              thirdPartyAppId:(NSString*)thirdPartyAppId 
         thirdPartyLocalAppId:(NSString*)thirdPartyLocalAppId 
               thirdPartyName:(SocializeThirdPartyAuthType)thirdPartyName
{
    if ([SocializeAuthenticateService isAuthenticated])
        [_authService removeAuthenticationInfo];
    
    [_authService authenticateWithApiKey:apiKey apiSecret:apiSecret thirdPartyAppId:thirdPartyAppId thirdPartyLocalAppId:thirdPartyLocalAppId thirdPartyName:thirdPartyName];
}

-(void)authenticateWithApiKey:(NSString*)apiKey
                    apiSecret:(NSString*)apiSecret
              thirdPartyAppId:(NSString*)thirdPartyAppId 
               thirdPartyName:(SocializeThirdPartyAuthType)thirdPartyName
{
    if ([SocializeAuthenticateService isAuthenticated])
        [_authService removeAuthenticationInfo];
    
    [_authService authenticateWithApiKey:apiKey apiSecret:apiSecret thirdPartyAppId:thirdPartyAppId thirdPartyName:thirdPartyName];
}

-(id<SocializeUser>)authenticatedUser {
    return _authService.authenticatedUser;
}

-(BOOL)isAuthenticated{
    return [SocializeAuthenticateService isAuthenticated];
}

-(BOOL)isAuthenticatedWithFacebook
{
    if (![self isAuthenticated]) {
        return NO;
    }
    
    if (![FacebookAuthenticator hasValidToken]) {
        return NO;
    }
    
    for (NSDictionary *auth in [[self authenticatedUser] thirdPartyAuth]) {
        if ([[auth objectForKey:@"auth_type"] isEqualToString:@"FaceBook"]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)facebookAvailable {
    NSString *facebookAppId = [Socialize facebookAppId];
    NSString *facebookLocalAppId = [Socialize facebookLocalAppId];
    if (facebookAppId == nil) {
        return NO;
    }
    
    NSURL *testURL = [NSURL URLWithString:[SocializeFacebook baseUrlForAppId:facebookAppId localAppId:facebookLocalAppId]];
    if (![[UIApplication sharedApplication] canOpenURL:testURL]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)facebookSessionValid {
    return [FacebookAuthenticator hasValidToken];
}

-(void)removeAuthenticationInfo{
    [_authService removeAuthenticationInfo];
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


#pragma entity related stuff

-(void)getEntityByKey:(NSString *)entitykey{
    [_entityService entityWithKey:entitykey];
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

/* REGISTER DEVICE TOKEN SERVICE CALLS */
#pragma mark notification service stuff
+(void)registerDeviceToken:(NSData *)deviceToken {
    Socialize *socialize = [Socialize sharedSocialize];
    [socialize.deviceTokenService registerDeviceToken:deviceToken];

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

@end
