//
//  SocializeAuthenticateService.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/13/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeCommonDefinitions.h"
#import "SocializeProvider.h"
#import "SocializeRequest.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeService.h"
#import "FBConnect.h"

@class SocializeAuthenticateService;

@interface FacebookAuthenticator : NSObject<FBSessionDelegate> {
@private
    Facebook* facebook;
    NSString* apiKey;
    NSString* apiSecret;
    NSString* thirdPartyAppId;
    SocializeAuthenticateService* service;
}
-(id) initWithFramework: (Facebook*) fb apiKey: (NSString*) key apiSecret: (NSString*) secret appId: (NSString*)appId service: (SocializeAuthenticateService*) authService;
-(void) performAuthentication;
-(BOOL) handleOpenURL:(NSURL *)url;

@end

/**
in progress
 */
@interface SocializeAuthenticateService : SocializeService<FBSessionDelegate> {
    @private
    FacebookAuthenticator* fbAuth;
}

-(void)authenticateWithApiKey:(NSString*)apiKey  
                    apiSecret:(NSString*)apiSecret;

-(void)authenticateWithApiKey:(NSString*)apiKey 
                            apiSecret:(NSString*)apiSecret 
                  thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                     thirdPartyAppId:(NSString*)thirdPartyAppId
                        thirdPartyName:(ThirdPartyAuthName)thirdPartyName;

-(void)authenticateWithApiKey:(NSString*)apiKey 
                    apiSecret:(NSString*)apiSecret 
              thirdPartyAppId:(NSString*)thirdPartyAppId 
               thirdPartyName:(ThirdPartyAuthName)thirdPartyName;

+(BOOL)isAuthenticated;
-(void)removeAuthenticationInfo;
-(BOOL)handleOpenURL:(NSURL *)url;

@end
