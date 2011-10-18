	//
//  SocializeAuthenticateService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/13/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeAuthenticateService.h"
#import "SocializeRequest.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OAAsynchronousDataFetcher.h"
#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "SocializePrivateDefinitions.h"
#import "UIDevice+IdentifierAddition.h"

@interface SocializeAuthenticateService()
-(NSString*)getSocializeToken;
-(void)persistUserInfo:(NSDictionary*)dictionary;
-(void)persistConsumerInfo:(NSString*)apiKey andApiSecret:(NSString*)apiSecret;
@end

@implementation SocializeAuthenticateService
@synthesize authenticatedUser;

-(void)dealloc
{
    [fbAuth release]; fbAuth = nil;
    [super dealloc];
}

#define AUTHENTICATE_METHOD @"authenticate/"

-(void)authenticateWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret{            
    NSString* payloadJson = [NSString stringWithFormat:@"{\"udid\":\"%@\"}", [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]];
    NSMutableDictionary* paramsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                payloadJson, @"jsonData",
                                                nil];

    [self persistConsumerInfo:apiKey andApiSecret:apiSecret];
    [self executeRequest:
     [SocializeRequest secureRequestWithHttpMethod:@"POST"
                                resourcePath:AUTHENTICATE_METHOD
                          expectedJSONFormat:SocializeDictionary
                                      params:paramsDict]
     ];

}

+(BOOL)isAuthenticated {
    OAToken *authToken = [[[OAToken alloc ]initWithUserDefaultsUsingServiceProviderName:kPROVIDER_NAME prefix:kPROVIDER_PREFIX] autorelease];
    if (authToken.key)
        return YES;
    else
        return NO;
}

+ (BOOL)isAuthenticatedWithFacebook {
    return [self isAuthenticated] && [FacebookAuthenticator hasValidToken];
}

-(void)persistConsumerInfo:(NSString*)apiKey andApiSecret:(NSString*)apiSecret{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userDefaults){
        [userDefaults setObject:apiKey forKey:kSOCIALIZE_API_KEY_KEY];
        [userDefaults setObject:apiSecret forKey:kSOCIALIZE_API_SECRET_KEY];
        [userDefaults synchronize];
    }
}

-(void)persistUserInfo:(NSDictionary*)dictionary{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userDefaults){
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
        [userDefaults setObject:data forKey:kSOCIALIZE_AUTHENTICATED_USER_KEY];
        [userDefaults synchronize];
    }
}

-(NSString*)getSocializeToken{
    OAToken *authToken = [[[OAToken alloc ]initWithUserDefaultsUsingServiceProviderName:kPROVIDER_NAME prefix:kPROVIDER_PREFIX] autorelease];
    if (authToken.key)
        return authToken.key;
    else 
        return nil;
}

-(void)authenticateWithApiKey:(NSString*)apiKey
                            apiSecret:(NSString*)apiSecret 
                  thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                     thirdPartyAppId:(NSString*)thirdPartyAppId
                       thirdPartyName:(ThirdPartyAuthName)thirdPartyName
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                             [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier],@"udid", 
                             @"1"/* auth type is for facebook*/ , @"auth_type", //TODO:: should be changed
                             thirdPartyAuthToken, @"auth_token",
                             thirdPartyAppId, @"auth_id" , nil] ;                        
                               
    [self persistConsumerInfo:apiKey andApiSecret:apiSecret];
    [self executeRequest:
     [SocializeRequest secureRequestWithHttpMethod:@"POST"
                                      resourcePath:AUTHENTICATE_METHOD
                                expectedJSONFormat:SocializeDictionary
                                            params:params]
     ];

}

- (NSString *)getFacebookBaseUrlForAppId:(NSString*)appId localAppId:(NSString*)localAppId {
    return [NSString stringWithFormat:@"fb%@%@://authorize",
            appId,
            localAppId ? localAppId : @""];
}

-(void)authenticateWithApiKey:(NSString*)apiKey 
                    apiSecret:(NSString*)apiSecret 
              thirdPartyAppId:(NSString*)thirdPartyAppId 
         thirdPartyLocalAppId:(NSString*)thirdPartyLocalAppId 
               thirdPartyName:(ThirdPartyAuthName)thirdPartyName
{
    SocializeFacebook* fb = [[SocializeFacebook alloc] initWithAppId:thirdPartyAppId];

    NSURL *testURL = [NSURL URLWithString:[self getFacebookBaseUrlForAppId:thirdPartyAppId localAppId:thirdPartyLocalAppId]];
    NSAssert([[UIApplication sharedApplication] canOpenURL:testURL], @"Socialize -- Can not authenticate with facebook! Please ensure you have registered a facebook URL scheme for your app as described at http://socialize.github.com/socialize-sdk-ios/socialize_ui.html#adding-facebook-support");
    [fbAuth release]; fbAuth = nil;
    fbAuth = [[FacebookAuthenticator alloc] initWithFramework:fb apiKey:apiKey apiSecret:apiSecret appId:thirdPartyAppId localAppId:thirdPartyLocalAppId service:self];
    [fb release]; fb = nil; 
    
    [fbAuth performAuthentication];
}

-(void)authenticateWithApiKey:(NSString*)apiKey 
                    apiSecret:(NSString*)apiSecret 
              thirdPartyAppId:(NSString*)thirdPartyAppId 
               thirdPartyName:(ThirdPartyAuthName)thirdPartyName
{
    [self authenticateWithApiKey:apiKey
                       apiSecret:apiSecret
                 thirdPartyAppId:thirdPartyAppId
            thirdPartyLocalAppId:nil
                  thirdPartyName:thirdPartyName];
}


/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error{
    [_delegate service:self didFail:error];
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on the format of the API response.
 */

- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    id jsonObject = [jsonKitDecoder objectWithData:data];
    
    if ([jsonObject isKindOfClass:[NSDictionary class]]){
        
        NSString* token_secret = [jsonObject objectForKey:@"oauth_token_secret"];
        NSString* token = [jsonObject objectForKey:@"oauth_token"];
        
        if (token_secret && token){
            OAToken *requestToken = [[OAToken alloc] initWithKey:token secret:token_secret];
            [requestToken storeInUserDefaultsWithServiceProviderName:kPROVIDER_NAME prefix:kPROVIDER_PREFIX];
            [requestToken release]; requestToken = nil;
            [self persistUserInfo:[jsonObject objectForKey:@"user"]];
            
            if (([((NSObject*)_delegate) respondsToSelector:@selector(didAuthenticate:)]) )
                [_delegate didAuthenticate:self.authenticatedUser];
        }
        else if (([((NSObject*)_delegate) respondsToSelector:@selector(service:didFail:)]) ) {
            [_delegate service:self didFail:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
        }
            
    }
    
    [responseBody release];
    [self freeDelegate];
}

-(void)removeAuthenticationInfo
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* key = [NSString stringWithFormat:@"OAUTH_%@_%@_KEY", kPROVIDER_PREFIX, kPROVIDER_NAME];
    NSString* secret = [NSString stringWithFormat:@"OAUTH_%@_%@_SECRET", kPROVIDER_PREFIX, kPROVIDER_NAME];
    
    if ([defaults objectForKey:key] && [defaults objectForKey:secret]) 
    {
        [defaults removeObjectForKey:key];
        [defaults removeObjectForKey:secret];
    }

    // Remove local facebook authentication info
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    
    // Remove persisted local user data
    [defaults removeObjectForKey:kSOCIALIZE_AUTHENTICATED_USER_KEY];
    
    [defaults synchronize]; 
}

- (id<SocializeUser>)authenticatedUser {    
    // Also search persistent storage
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:kSOCIALIZE_AUTHENTICATED_USER_KEY];
    if (userData != nil) {
        NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        return [_objectCreator createObjectFromDictionary:info forProtocol:@protocol(SocializeUser)];;
    }
    
    // Not available
    return nil;
}

+(BOOL)handleOpenURL:(NSURL *)url 
{    
    return [FacebookAuthenticator handleOpenURL:url]; 
}

-(BOOL)handleOpenURL:(NSURL *)url 
{    
    return [fbAuth handleOpenURL:url]; 
}

-(NSString*)receiveFacebookAuthToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"FBAccessTokenKey"];
}


@end


#pragma mark - Facebook authenticator

@interface FacebookAuthenticator()
    @property (nonatomic, retain) SocializeFacebook* facebook;
    @property (nonatomic, retain) NSString* apiKey;
    @property (nonatomic, retain) NSString* apiSecret;
    @property (nonatomic, retain) NSString* thirdPartyAppId;
    @property (nonatomic, retain) NSString* thirdPartyLocalAppId;
    @property (nonatomic, assign) SocializeAuthenticateService* service;

+ (void)setLastUsedAuthenticator:(FacebookAuthenticator*)newAuthenticator;

@end

static FacebookAuthenticator *FacebookAuthenticatorLastUsedAuthenticator;

@implementation FacebookAuthenticator
@synthesize facebook;
@synthesize apiKey;
@synthesize apiSecret;
@synthesize thirdPartyAppId;
@synthesize thirdPartyLocalAppId;
@synthesize service;

-(void)dealloc
{
    self.facebook = nil;
    [super dealloc];
}

-(id) initWithFramework: (SocializeFacebook*) fb 
                 apiKey: (NSString*) key 
              apiSecret: (NSString*) secret
                  appId: (NSString*)appId 
                service: (SocializeAuthenticateService*) authService
{
    return [self initWithFramework:fb apiKey:key apiSecret:secret appId:appId localAppId:nil service:authService];
}

-(id) initWithFramework: (SocializeFacebook*) fb 
                 apiKey: (NSString*) key 
              apiSecret: (NSString*) secret
                  appId: (NSString*)appId 
                  localAppId: (NSString*)localAppId 
                service: (SocializeAuthenticateService*) authService
{
    self = [super init];
    if(self)
    {
        self.facebook  = fb;
        self.apiKey = key;
        self.apiSecret = secret;
        self.thirdPartyAppId = appId;
        self.thirdPartyLocalAppId = localAppId;
        self.service = authService;
    }
    
    return self;
}

+ (BOOL)hasValidToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"FBAccessTokenKey"] != nil &&
        [[defaults objectForKey:@"FBExpirationDateKey"] timeIntervalSinceNow] > 0;
}

- (void)copyDefaultsToFacebookObject {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
}

-(void) performAuthentication
{
    [self copyDefaultsToFacebookObject];
    if (![self.facebook isSessionValid]) {

        // Store this authenticator for later retrieval from static class method handleOpenURL:
        [FacebookAuthenticator setLastUsedAuthenticator:self];
        [self.facebook authorize:nil delegate:self localAppId:self.thirdPartyLocalAppId];
    }
    else
    {
        [self.service authenticateWithApiKey:self.apiKey apiSecret:self.apiSecret thirdPartyAuthToken:self.facebook.accessToken thirdPartyAppId:self.thirdPartyAppId thirdPartyName:FacebookAuth];
    }

}

- (void)logout {
    [self copyDefaultsToFacebookObject];
    [self.facebook logout:self];
}

#pragma mark - Facebook delegate

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [service authenticateWithApiKey:self.apiKey apiSecret:self.apiSecret thirdPartyAuthToken:self.facebook.accessToken thirdPartyAppId:self.thirdPartyAppId thirdPartyName:FacebookAuth];
    
    [FacebookAuthenticator setLastUsedAuthenticator:nil];
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
    NSLog(@"User cancelled authentication");
    if(cancelled)
        [service request:nil didFailWithError:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
    
    [FacebookAuthenticator setLastUsedAuthenticator:nil];
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

+ (void)setLastUsedAuthenticator:(FacebookAuthenticator*)newAuthenticator {
    [newAuthenticator retain];
    [FacebookAuthenticatorLastUsedAuthenticator release];
    FacebookAuthenticatorLastUsedAuthenticator = newAuthenticator;
}

+ (BOOL)handleOpenURL:(NSURL*)url {
    return [FacebookAuthenticatorLastUsedAuthenticator handleOpenURL:url];
}

-(BOOL) handleOpenURL:(NSURL *)url
{
    return [self.facebook handleOpenURL: url];
}

@end