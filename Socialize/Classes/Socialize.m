//
//  SocializeService.m
//  SocializeSDK
//
//  Created by William Johnson on 5/31/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "Socialize.h"


@implementation Socialize

- (void)dealloc {
    [super dealloc];
}

-(void)authenticateWithApiKey:(NSString*)apiKey 
          apiSecret:(NSString*)apiSecret
               udid:(NSString*)udid
            delegate:(id<SocializeAuthenticationDelegate>)delegate
         {
    _authService = [[SocializeAuthenticateService alloc] init];
   [_authService authenticateWithApiKey:apiKey apiSecret:apiSecret udid:udid delegate:delegate]; 
}

-(void)authenticateWithApiKey:(NSString*)apiKey 
                            apiSecret:(NSString*)apiSecret 
                                 udid:(NSString*)udid
                  thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                     thirdPartyUserId:(NSString*)thirdPartyUserId
                       thirdPartyName:(ThirdPartyAuthName)thirdPartyName
                             delegate:(id<SocializeAuthenticationDelegate>)delegate
                           {

    _authService = [[SocializeAuthenticateService alloc] init];
    [_authService  authenticateWithApiKey:apiKey 
                           apiSecret:apiSecret
                                udid:udid
                           thirdPartyAuthToken:thirdPartyAuthToken
                           thirdPartyUserId:thirdPartyUserId
                           thirdPartyName:thirdPartyName
                                delegate:delegate];
}

-(BOOL)isAuthenticated{
    return [SocializeAuthenticateService isAuthenticated];
}

@end