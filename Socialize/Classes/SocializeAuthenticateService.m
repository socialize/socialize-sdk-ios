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
                    thirdPartyAuthTokenSecret:(NSString*)thirdPartyAuthTokenSecret {
    
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
    
    [self executeRequest:request];

}

- (void)linkToTwitterWithAccessToken:(NSString*)twitterAccessToken accessTokenSecret:(NSString*)twitterAccessTokenSecret {
    [self authenticateWithThirdPartyAuthType:SocializeThirdPartyAuthTypeTwitter
                         thirdPartyAuthToken:twitterAccessToken
                   thirdPartyAuthTokenSecret:twitterAccessTokenSecret];
}

- (void)linkToFacebookWithAccessToken:(NSString*)facebookAccessToken {
    [self authenticateWithThirdPartyAuthType:SocializeThirdPartyAuthTypeFacebook
                         thirdPartyAuthToken:facebookAccessToken
                   thirdPartyAuthTokenSecret:nil];
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
            
            // Post a global notification that the authenticated user has changed
            [[NSNotificationCenter defaultCenter] postNotificationName:SocializeAuthenticatedUserDidChangeNotification object:self.authenticatedUser];
            
        } else {
            [self failWithError:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseBody reason:@"Response Missing OAuth Token and Secret"]];
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

@end

