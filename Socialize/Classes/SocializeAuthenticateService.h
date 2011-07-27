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

@interface SocializeAuthenticateService : SocializeService<FBSessionDelegate> {
    @private
    Facebook *facebook;
    NSString* _apiKey;
    NSString* _apiSecret;
    NSString* _thirdPartyAppId;
}

@property (nonatomic, retain) Facebook *facebook;

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
