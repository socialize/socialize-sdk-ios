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

-(id) initWithProvider:(SocializeProvider*) provider delegate:(id<SocializeAuthenticationDelegate>)delegate;

-(void)authenticateWithApiKey:(NSString*)apiKey  //TODO:: remove apiKey and secret from params list
                    apiSecret:(NSString*)apiSecret
                         udid:(NSString*)udid;

-(void)authenticateWithApiKey:(NSString*)apiKey 
                            apiSecret:(NSString*)apiSecret 
                                 udid:(NSString*)udid
                  thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                     thirdPartyUserId:(NSString*)thirdPartyUserId
                        thirdPartyName:(ThirdPartyAuthName)thirdPartyName;

+(BOOL)isAuthenticated;

-(void)removeAuthenticationInfo;

@property (nonatomic, assign) SocializeProvider* provider;
@property (nonatomic, assign) id<SocializeAuthenticationDelegate> delegate;

@end
