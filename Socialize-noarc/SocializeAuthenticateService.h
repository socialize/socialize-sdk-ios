//
//  SocializeAuthenticateService.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/13/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeCommonDefinitions.h"
#import "SocializeService.h"

@protocol SocializeFullUser;

/**
Socialize authentication service is the authentication engine. It performs anonymously and third party authentication.
 */
@interface SocializeAuthenticateService : SocializeService

extern NSString *const UDIDKey;
extern NSString *const IDFAKey;
extern NSString *const IDFVKey;

@property (nonatomic, readonly) id<SocializeUser>authenticatedUser;
@property (nonatomic, readonly) id<SocializeFullUser>authenticatedFullUser;

/**@name Anonymous authentication*/
/**
 Authenticate with API key and API secret.
 
 This method is used to perform anonymous authentication. It means that uses could not do any action with his profile.  
 Find information how to get API key and secret on [Socialize.](http://www.getsocialize.com/)
 
 @param apiKey API access key.
 @param apiSecret API access secret.
 @see authenticateWithApiKey:apiSecret:thirdPartyAppId:thirdPartyName:
 @see authenticateWithApiKey:apiSecret:thirdPartyAuthToken:thirdPartyAppId:thirdPartyName:
 */
-(void)authenticateWithApiKey:(NSString*)apiKey  
                    apiSecret:(NSString*)apiSecret;


-(void)authenticateWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;

/**@name Third party authentication*/

- (void)authenticateWithThirdPartyAuthType:(SocializeThirdPartyAuthType)type
                       thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                 thirdPartyAuthTokenSecret:(NSString*)thirdPartyAuthTokenSecret;

- (void)authenticateWithThirdPartyAuthType:(SocializeThirdPartyAuthType)type
                       thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                 thirdPartyAuthTokenSecret:(NSString*)thirdPartyAuthTokenSecret
                                   success:(void(^)(id<SZFullUser>))success
                                   failure:(void(^)(NSError *error))failure;

/**
 * This API call is currently unused
 */
- (void)associateWithThirdPartyAuthType:(SocializeThirdPartyAuthType)type
                                  token:(NSString*)token
                            tokenSecret:(NSString*)tokenSecret;

/**@name Other methods*/

/**
 Check if authentication credentials still valid.
 
 @return YES if valid and NO if access token was expired.
 */
+(BOOL)isAuthenticated;

/**
 Remove old authentication information.
 
 If user would like to re-authenticate he has to remove previous authentication information.
 */
-(void)removeSocializeAuthenticationInfo;
/**
 Link Socialize user to an existing Twitter session
 */
- (void)linkToTwitterWithAccessToken:(NSString*)twitterAccessToken accessTokenSecret:(NSString*)twitterAccessTokenSecret;
- (void)linkToTwitterWithAccessToken:(NSString*)twitterAccessToken
                   accessTokenSecret:(NSString*)twitterAccessTokenSecret
                             success:(void(^)(id<SZFullUser>))success
                             failure:(void(^)(NSError *error))failure;

- (void)linkToFacebookWithAccessToken:(NSString*)facebookAccessToken;

- (void)linkToFacebookWithAccessToken:(NSString*)facebookAccessToken 
                              success:(void(^)(id<SZFullUser>))success
                              failure:(void(^)(NSError *error))failure;

@end
