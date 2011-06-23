//
//  SocializeService.h
//  SocializeSDK
//
//  Created by William Johnson on 5/31/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeProvider.h"
#import "SocializeObjectFactory.h"
#import "SocializeRequest.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeAuthenticateService.h"
#import "SocializeCommentsService.h"


//**************************************************************************************************//
//This is a general facade of the SDK`s API. Through it a third party developers could use the API. //
//**************************************************************************************************//




@interface Socialize : NSObject 
{
    @private
        SocializeObjectFactory* _objectFactory;
        SocializeProvider               *_provider;
    
        SocializeAuthenticateService    *_authService;
        SocializeCommentsService        *_commentsService;
        ThirdPartyAuthName              _type;
}

-(void)authenticateWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret    
               udid:(NSString*)udid
  delegate:(id<SocializeAuthenticationDelegate>)delegate;

-(void)authenticateWithApiKey:(NSString*)apiKey 
                            apiSecret:(NSString*)apiSecret 
                                 udid:(NSString*)udid
                  thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                     thirdPartyUserId:(NSString*)thirdPartyUserId
                       thirdPartyName:(ThirdPartyAuthName)thirdPartyName
                             delegate:(id<SocializeAuthenticationDelegate>)delegate;

-(BOOL)isAuthenticated;

@property (nonatomic, readonly) SocializeCommentsService* commentService;

@end