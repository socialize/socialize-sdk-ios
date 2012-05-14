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
#import "SocializeFullUser.h"

@interface SocializeAuthenticateService()
-(NSString*)getSocializeToken;
-(void)persistUserInfo:(NSDictionary*)dictionary;
-(void)persistConsumerInfo:(NSString*)apiKey andApiSecret:(NSString*)apiSecret;
@end

@implementation SocializeAuthenticateService
@synthesize authenticatedUser;

-(void)dealloc
{
    [super dealloc];
}

#define AUTHENTICATE_METHOD @"authenticate/"
#define ASSOCIATE_METHOD @"third_party_authenticate/"

-(void)authenticateWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret{            
    NSString* payloadJson = [NSString stringWithFormat:@"{\"udid\":\"%@\"}", [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]];
    NSMutableDictionary* paramsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                payloadJson, @"jsonData",
                                                nil];

    [self persistConsumerInfo:apiKey andApiSecret:apiSecret];
    SocializeRequest *request = [SocializeRequest secureRequestWithHttpMethod:@"POST"
                                                                 resourcePath:AUTHENTICATE_METHOD
                                                           expectedJSONFormat:SocializeDictionary
                                                                       params:paramsDict];
    
    // Flag this as a token request so we do not send the existing token
    request.tokenRequest = YES;
    
    [self executeRequest:request];
}

+(BOOL)isAuthenticated {
    OAToken *authToken = [[[OAToken alloc ]initWithUserDefaultsUsingServiceProviderName:kPROVIDER_NAME prefix:kPROVIDER_PREFIX] autorelease];
    if (authToken.key)
        return YES;
    else
        return NO;
}

-(void)persistConsumerInfo:(NSString*)apiKey andApiSecret:(NSString*)apiSecret{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userDefaults){
        [userDefaults setObject:apiKey forKey:kSocializeConsumerKey];
        [userDefaults setObject:apiSecret forKey:kSocializeConsumerSecret];
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

- (void)associateWithThirdPartyAuthType:(SocializeThirdPartyAuthType)type
                                  token:(NSString*)token
                            tokenSecret:(NSString*)tokenSecret {
    
    NSString *authType = [NSString stringWithFormat:@"%d", type];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                   authType, @"auth_type",
                                   token, @"auth_token",
                                   tokenSecret, @"auth_token_secret",
                                   nil];

    SocializeRequest *request = [SocializeRequest secureRequestWithHttpMethod:@"POST"
                                                                 resourcePath:ASSOCIATE_METHOD
                                                           expectedJSONFormat:SocializeDictionary
                                                                       params:params];
    [self executeRequest:request];
}

- (void)authenticateWithThirdPartyAuthType:(SocializeThirdPartyAuthType)type
                       thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                    thirdPartyAuthTokenSecret:(NSString*)thirdPartyAuthTokenSecret
                                   success:(void(^)(id<SZFullUser>))success
                                   failure:(void(^)(NSError *error))failure
{
    
    NSString *authType = [NSString stringWithFormat :@"%d", type];

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                   [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier],@"udid", 
                                   authType, @"auth_type",
                                   thirdPartyAuthToken, @"auth_token",
                                   thirdPartyAuthTokenSecret, @"auth_token_secret",
                                   nil];
    
    SocializeRequest *request = [SocializeRequest secureRequestWithHttpMethod:@"POST"
                                                                 resourcePath:AUTHENTICATE_METHOD
                                                           expectedJSONFormat:SocializeDictionary
                                                                       params:params];
    
    request.successBlock = success;
    request.failureBlock = failure;
    
    [self executeRequest:request];

}

- (void)authenticateWithThirdPartyAuthType:(SocializeThirdPartyAuthType)type
                       thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                 thirdPartyAuthTokenSecret:(NSString*)thirdPartyAuthTokenSecret {
    [self authenticateWithThirdPartyAuthType:type
                         thirdPartyAuthToken:thirdPartyAuthToken
                   thirdPartyAuthTokenSecret:thirdPartyAuthTokenSecret
                                     success:nil
                                     failure:nil];
}

- (void)linkToTwitterWithAccessToken:(NSString*)twitterAccessToken accessTokenSecret:(NSString*)twitterAccessTokenSecret {
    [self authenticateWithThirdPartyAuthType:SocializeThirdPartyAuthTypeTwitter
                         thirdPartyAuthToken:twitterAccessToken
                   thirdPartyAuthTokenSecret:twitterAccessTokenSecret];
}

- (void)linkToFacebookWithAccessToken:(NSString*)facebookAccessToken 
                              success:(void(^)(id<SZFullUser>))success
                              failure:(void(^)(NSError *error))failure
{
    [self authenticateWithThirdPartyAuthType:SocializeThirdPartyAuthTypeFacebook
                         thirdPartyAuthToken:facebookAccessToken
                   thirdPartyAuthTokenSecret:nil
                                     success:success failure:failure];
}

- (void)linkToFacebookWithAccessToken:(NSString*)facebookAccessToken {
    [self linkToFacebookWithAccessToken:facebookAccessToken success:nil failure:nil];
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

            if (request.successBlock != nil) {
                request.successBlock(self.authenticatedUser);
            } else if (([_delegate respondsToSelector:@selector(didAuthenticate:)])) {
                [_delegate didAuthenticate:self.authenticatedUser];
            }
            
            // Post a global notification that the authenticated user has changed
            [[NSNotificationCenter defaultCenter] postNotificationName:SocializeAuthenticatedUserDidChangeNotification object:self.authenticatedUser];
            
        } else {
            SDebugLog0(@"Unexpected JSON Response: %@", responseBody);
            [self failWithRequest:request error:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseBody reason:@"Response Missing OAuth Token and Secret"]];
        }            
    }
    
    [responseBody release];
    [self freeDelegate];
}

-(void)removeSocializeAuthenticationInfo
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* key = [NSString stringWithFormat:@"OAUTH_%@_%@_KEY", kPROVIDER_PREFIX, kPROVIDER_NAME];
    NSString* secret = [NSString stringWithFormat:@"OAUTH_%@_%@_SECRET", kPROVIDER_PREFIX, kPROVIDER_NAME];
    
    [defaults removeObjectForKey:key];
    [defaults removeObjectForKey:secret];
    
    // Remove persisted local user data
    [defaults removeObjectForKey:kSOCIALIZE_AUTHENTICATED_USER_KEY];

    [defaults synchronize]; 
}

- (id)unarchiveFullUserWithProtocol:(Protocol*)protocol {
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:kSOCIALIZE_AUTHENTICATED_USER_KEY];
    if (userData != nil) {
        NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        return [_objectCreator createObjectFromDictionary:info forProtocol:protocol];
    }
    
    // Not available
    return nil;
}

- (id<SocializeUser>)authenticatedUser {  
    return [self unarchiveFullUserWithProtocol:@protocol(SocializeUser)];
}

- (id<SocializeFullUser>)authenticatedFullUser {    
    return [self unarchiveFullUserWithProtocol:@protocol(SocializeFullUser)];
}


@end

