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


@interface SocializeAuthenticateService : NSObject<SocializeRequestDelegate> {
    id<SocializeAuthenticationDelegate>     _delegate;
    SocializeProvider*                      _provider;
}

-(void)authenticateWithApiKey:(NSString*)apiKey 
                    apiSecret:(NSString*)apiSecret
                         udid:(NSString*)udid
                    delegate:(id<SocializeAuthenticationDelegate>)delegate;

-(void)authenticateWithApiKey:(NSString*)apiKey 
                            apiSecret:(NSString*)apiSecret 
                                 udid:(NSString*)udid
                  thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                     thirdPartyUserId:(NSString*)thirdPartyUserId
                        thirdPartyName:(ThirdPartyAuthName)thirdPartyName
                            delegate:(id<SocializeAuthenticationDelegate>)delegate;

+(BOOL)isAuthenticated;

@property (nonatomic, assign) SocializeProvider* provider;

@end
