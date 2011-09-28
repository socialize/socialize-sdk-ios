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
    SocializeAuthenticateService* service;
}
-(id) initWithFramework: (SocializeFacebook*) fb apiKey: (NSString*) key apiSecret: (NSString*) secret appId: (NSString*)appId service: (SocializeAuthenticateService*) authService;
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
                        thirdPartyName:(ThirdPartyAuthName)thirdPartyName;

/**
 Third party authentication via SDK service.
 
 Third Party Authentication uses a service like Facebook to verify the user. Using third party authentication allows the user to maintain a profile that is linked to their activity. Without using Third Party Authentication, the user will still be able to access socialize features but these actions will not be linked to the user’s profile.
 
 Find information how to get API key and secret on [Socialize.](http://www.getsocialize.com/)
 
 @param apiKey API access key.
 @param apiSecret API access secret.
 @param thirdPartyAppId Extern service application id.
 @param thirdPartyName Third party authentication name. Current verion of SDK suports only FacebookAuth value.
 @warning *Note:* In current SDK version only Facebook authentication is available.
 
 @see authenticateWithApiKey:apiSecret:thirdPartyAuthToken:thirdPartyAppId:thirdPartyName:
 @see authenticateWithApiKey:apiSecret:
 */
-(void)authenticateWithApiKey:(NSString*)apiKey 
                    apiSecret:(NSString*)apiSecret 
              thirdPartyAppId:(NSString*)thirdPartyAppId 
               thirdPartyName:(ThirdPartyAuthName)thirdPartyName;

/**@name Other methods*/

/**
 Check if authentication credentials still valid.
 
 @return YES if valid and NO if access token was expired.
 */
+(BOOL)isAuthenticated;

/**
 Check if authentication credentials still valid /and/ that this is a facebook authentication.
 
 @return YES if credentials are valid and facebook was used for authentication, and NO otherwise
 */
+ (BOOL)isAuthenticatedWithFacebook;

/**
 Remove old authentication information.
 
 If user would like to re-authenticate he has to remove previous authentication information.
 */
-(void)removeAuthenticationInfo;

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
 Allows get facebook authentication token
 
 @return facebook authentication toke
 */
-(NSString*)receiveFacebookAuthToken;

@end
