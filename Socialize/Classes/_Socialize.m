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
#import "SocializeShareService.h"
#import "Facebook+Socialize.h"

#define SOCIALIZE_API_KEY @"socialize_api_key"
#define SOCIALIZE_API_SECRET @"socialize_api_secret"
#define SOCIALIZE_FACEBOOK_LOCAL_APP_ID @"socialize_facebook_local_app_id"
#define SOCIALIZE_FACEBOOK_APP_ID @"socialize_facebook_app_id"

@implementation Socialize

@synthesize authService = _authService;
@synthesize likeService = _likeService;
@synthesize commentsService = _commentsService;
@synthesize entityService = _entityService;
@synthesize viewService = _viewService;
@synthesize userService = _userService;
@synthesize delegate = _delegate;
@synthesize activityService = _activityService;

- (void)dealloc {
    [_objectFactory release]; _objectFactory = nil;
    [_authService release]; _authService = nil;
    [_likeService release]; _likeService = nil;
    [_commentsService release]; _commentsService = nil;
    [_entityService release]; _entityService = nil;
    [_viewService release]; _viewService = nil;
    [_userService release]; _userService = nil;
    [_activityService release]; _activityService = nil;
    
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
    
    [self authenticateWithApiKey:apiKey apiSecret:apiSecret thirdPartyAppId:facebookAppId thirdPartyLocalAppId:facebookLocalAppId thirdPartyName:FacebookAuth];
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
               thirdPartyName:(ThirdPartyAuthName)thirdPartyName
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
               thirdPartyName:(ThirdPartyAuthName)thirdPartyName
{
    if ([SocializeAuthenticateService isAuthenticated])
        [_authService removeAuthenticationInfo];
    
    [_authService authenticateWithApiKey:apiKey apiSecret:apiSecret thirdPartyAppId:thirdPartyAppId thirdPartyLocalAppId:thirdPartyLocalAppId thirdPartyName:thirdPartyName];
}

-(void)authenticateWithApiKey:(NSString*)apiKey
                    apiSecret:(NSString*)apiSecret
              thirdPartyAppId:(NSString*)thirdPartyAppId 
               thirdPartyName:(ThirdPartyAuthName)thirdPartyName
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
    return [SocializeAuthenticateService isAuthenticatedWithFacebook];
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

-(void)createCommentForEntity:(id<SocializeEntity>) entity comment: (NSString*) comment longitude:(NSNumber*)lng latitude:(NSNumber*)lat{
    [_commentsService createCommentForEntity:entity comment:comment longitude: lng latitude: lat];
}

#pragma entity related stuff

-(void)getEntityByKey:(NSString *)entitykey{
    [_entityService entityWithKey:entitykey];
}

-(void)createEntityWithUrl:(NSString*)entityKey andName:(NSString*)name{
    [_entityService createEntityWithKey:entityKey andName:name];
}

#pragma view related stuff

-(void)viewEntity:(id<SocializeEntity>)entity longitude:(NSNumber*)lng latitude: (NSNumber*)lat{
    [_viewService createViewForEntity:entity longitude:lng latitude:lat];
}

#pragma user related stuff
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

#pragma activity related stuff
-(void)getActivityOfCurrentApplication
{
    [_activityService getActivityOfCurrentApplication];
}

-(void)getActivityOfUser:(id<SocializeUser>)user
{
    [_activityService getActivityOfUser:user];
}
@end