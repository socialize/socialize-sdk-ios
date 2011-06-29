//
//  SocializeService.m
//  SocializeSDK
//
//  Created by William Johnson on 5/31/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "Socialize.h"


@implementation Socialize
@synthesize commentService = _commentsService;
@synthesize entityService = _entityService;
@synthesize likeService = _likeService;

- (void)dealloc {
    [_objectFactory release]; _objectFactory = nil;
    [_provider release]; _provider = nil;
    [_authService release]; _authService = nil;
    [_commentsService release]; _commentsService = nil;
    [_likeService release]; _likeService = nil;
    [super dealloc];
}

-(id) init
{
    self = [super init];
    if(self != nil)
    {
        _objectFactory = [[SocializeObjectFactory alloc]init];
        _provider = [[SocializeProvider alloc] init];
        _authService = [[SocializeAuthenticateService alloc] initWithProvider:_provider];
        _commentsService = [[SocializeCommentsService alloc] initWithProvider:_provider objectFactory:_objectFactory delegate:nil];
        _entityService = [[SocializeEntityService alloc]initWithProvider:_provider objectFactory:_objectFactory delegate:nil];
        _likeService  = [[SocializeLikeService alloc] initWithProvider:_provider objectFactory:_objectFactory delegate:nil];
    }
    return self;
}

-(void)authenticateWithApiKey:(NSString*)apiKey 
          apiSecret:(NSString*)apiSecret
               udid:(NSString*)udid
            delegate:(id<SocializeAuthenticationDelegate>)delegate
{
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