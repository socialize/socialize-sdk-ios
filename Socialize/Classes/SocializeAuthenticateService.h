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
#import "SocializeFBConnect.h"

@class SocializeAuthenticateService;

@interface FacebookAuthenticator : NSObject<SocializeFBSessionDelegate> {
@private
    SocializeFacebook* facebook;
    NSString* apiKey;
    NSString* apiSecret;
    NSString* thirdPartyAppId;
    NSString* thirdPartyLocalAppId;
    SocializeAuthenticateService* service;
}
-(id) initWithFramework: (SocializeFacebook*) fb apiKey: (NSString*) key apiSecret: (NSString*) secret appId: (NSString*)appId service: (SocializeAuthenticateService*) authService;
-(id) initWithFramework: (SocializeFacebook*) fb apiKey: (NSString*) key apiSecret: (NSString*) secret appId: (NSString*)appId localAppId: (NSString*)localAppId service: (SocializeAuthenticateService*) authService;
-(void) performAuthentication;
-(BOOL) handleOpenURL:(NSURL *)url;
+ (BOOL)hasValidToken;
+ (BOOL)handleOpenURL:(NSURL*)url;
- (void)logout;

@end

/**
Socialize authentication service is the authentication engine. It performs anonymously and third party authentication.
 */
@interface SocializeAuthenticateService : SocializeService<SocializeFBSessionDelegate> {
    @private
    FacebookAuthenticator* fbAuth;
}

@property (nonatomic, readonly) id<SocializeUser>authenticatedUser;

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


/**@name Third party authentication*/

/**
 Third party authentication.
 
 Third Party Authentication uses a service like Facebook to verify the user. Using third party authentication allows the user to maintain a profile that is linked to their activity. Without using Third Party Authentication, the user will still be able to access socialize features but these actions will not be linked to the user’s profile.
 
 Find information how to get API key and secert on [Socialize.](http://www.getsocialize.com/)
 
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
                        thirdPartyName:(SocializeThirdPartyAuthType)thirdPartyName;

/**
 Convenience method
 
 @see authenticateWithApiKey:apiSecret:thirdPartyAuthToken:thirdPartyAppId:thirdPartyLocalAppId:thirdPartyName:
 */
-(void)authenticateWithApiKey:(NSString*)apiKey 
                    apiSecret:(NSString*)apiSecret 
              thirdPartyAppId:(NSString*)thirdPartyAppId 
               thirdPartyName:(SocializeThirdPartyAuthType)thirdPartyName;

/**
 Third party authentication via SDK service.
 
 Third Party Authentication uses a service like Facebook to verify the user. Using third party authentication allows the user to maintain a profile that is linked to their activity. Without using Third Party Authentication, the user will still be able to access socialize features but these actions will not be linked to the user’s profile.
 
 Find information how to get API key and secret on [Socialize.](http://www.getsocialize.com/)
 
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
 Third party associate.
 
 Associate third party info with an existing (Socialize oauth-verified) account
 */
- (void)associateWithThirdPartyAuthType:(SocializeThirdPartyAuthType)type
                                  token:(NSString*)token
                            tokenSecret:(NSString*)tokenSecret;

- (void)authenticateWithThirdPartyAuthType:(SocializeThirdPartyAuthType)type
                       thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                 thirdPartyAuthTokenSecret:(NSString*)thirdPartyAuthTokenSecret;

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
 This method is used for Facebook authentication.
 
 Make call to this method from your application delegate.
        - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
        {
            return [socialize.authService handleOpenURL: url];
        }
 @param url Unique URL to the user application.
 */
-(BOOL)handleOpenURL:(NSURL *)url;

/**
 This is a class method version of above, intended to make it easier for the user to
 plug socialize into their application
 @param url Unique URL to the user application.
 */
+(BOOL)handleOpenURL:(NSURL *)url;

/**
 Authenticate with Twitter using stored credentials
 @see storeSocializeTwitterAccessToken:
 @see storeSocializeTwitterAccessTokenSecret:
 */
- (void)authenticateViaTwitterUsingStoredCredentials;

- (void)authenticateViaTwitterAccessToken:(NSString*)twitterAccessToken
                  twitterAccessTokenSecret:(NSString*)twitterAccessTokenSecret;

@end
