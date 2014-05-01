	//
//  SocializeAuthenticateService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/13/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeAuthenticateService.h"
#import "SocializeRequest.h"
#import <OAuthConsumer/OAuthConsumer.h>
#import <UIKit/UIKit.h>
#import <SZJSONKit/JSONKit.h>
#import "SocializePrivateDefinitions.h"
#import "SocializeFullUser.h"
#import "socialize_globals.h"
#import "NSData+Base64.h"
#import "SZIdentifierUtils.h"
#import "SZAPIClientHelpers.h"

static NSString *SZDefaultUDID = @"105105105105";

@interface SocializeAuthenticateService()
-(NSString*)getSocializeToken;
-(void)persistConsumerInfo:(NSString*)apiKey andApiSecret:(NSString*)apiSecret;
@end

@implementation SocializeAuthenticateService

NSString *const UDIDKey = @"udid";
NSString *const IDFAKey = @"a";
NSString *const IDFVKey = @"v";

@synthesize authenticatedUser;

-(void)dealloc
{
    [super dealloc];
}

#define AUTHENTICATE_METHOD @"authenticate/"
#define ASSOCIATE_METHOD @"third_party_authenticate/"

-(void)authenticateWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:SZDefaultUDID forKey:UDIDKey];
    
    NSString *adsId = [SZIdentifierUtils base64AdvertisingIdentifierString];
    if ([adsId length] > 0) {
        [params setObject:adsId forKey:IDFAKey];
    }
    
    NSString *vendorId = [SZIdentifierUtils base64VendorIdentifierString];
    if ([vendorId length] > 0) {
        [params setObject:vendorId forKey:IDFVKey];
    }

    [self persistConsumerInfo:apiKey andApiSecret:apiSecret];
    SocializeRequest *request = [SocializeRequest secureRequestWithHttpMethod:@"POST"
                                                                 resourcePath:AUTHENTICATE_METHOD
                                                           expectedJSONFormat:SocializeDictionary
                                                                       params:params];
    
    // Flag this as a token request so we do not send the existing token
    request.tokenRequest = YES;
    request.successBlock = success;
    request.failureBlock = failure;
    
    [self executeRequest:request];
}

-(void)authenticateWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret {
    [self authenticateWithApiKey:apiKey apiSecret:apiSecret success:nil failure:nil];
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
                                   SZDefaultUDID, @"udid",
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
                                   authType, @"auth_type",
                                   thirdPartyAuthToken, @"auth_token",
                                   SZDefaultUDID, @"udid",
                                   nil];
    
    if (thirdPartyAuthTokenSecret != nil) {
        [params setObject:thirdPartyAuthTokenSecret forKey:@"auth_token_secret"];
    }

    NSString *adsId = [SZIdentifierUtils base64AdvertisingIdentifierString];
    if ([adsId length] > 0) {
        [params setObject:adsId forKey:@"a"];
    }
    
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

- (void)linkToTwitterWithAccessToken:(NSString*)twitterAccessToken
                   accessTokenSecret:(NSString*)twitterAccessTokenSecret
                             success:(void(^)(id<SZFullUser>))success
                             failure:(void(^)(NSError *error))failure {
    
    [self authenticateWithThirdPartyAuthType:SocializeThirdPartyAuthTypeTwitter
                         thirdPartyAuthToken:twitterAccessToken
                   thirdPartyAuthTokenSecret:twitterAccessTokenSecret
                                     success:success
                                     failure:failure];
}

- (void)linkToTwitterWithAccessToken:(NSString*)twitterAccessToken accessTokenSecret:(NSString*)twitterAccessTokenSecret {
    [self linkToTwitterWithAccessToken:twitterAccessToken accessTokenSecret:twitterAccessTokenSecret success:nil failure:nil];
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
            
            NSDictionary *fullUserDictionary = [jsonObject objectForKey:@"user"];
            id<SZFullUser> fullUser = [_objectCreator createObjectFromDictionary:fullUserDictionary forProtocol:@protocol(SZFullUser)];
            SZHandleUserChange(fullUser);

            if (request.successBlock != nil) {
                request.successBlock(self.authenticatedUser);
            } else if (([_delegate respondsToSelector:@selector(didAuthenticate:)])) {
                [_delegate didAuthenticate:self.authenticatedUser];
            }
            
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

- (id<SocializeUser>)authenticatedUser {  
    return SZUnarchiveUser(@protocol(SocializeUser));
}

- (id<SocializeFullUser>)authenticatedFullUser {    
    return SZUnarchiveUser(@protocol(SocializeFullUser));
}


@end

