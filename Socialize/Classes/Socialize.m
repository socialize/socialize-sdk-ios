//
//  SocializeService.m
//  SocializeSDK
//
//  Created by William Johnson on 5/31/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "Socialize.h"
@implementation Socialize
@synthesize likeService = _likeService;
//@synthesize viewService = _viewService;
//@synthesize userService = _userService;
//@synthesize commentService = _commentsService;
//@synthesize entityService = _entityService;

- (void)dealloc {
    [_objectFactory release]; _objectFactory = nil;
    [_provider release]; _provider = nil;
    [_authService release]; _authService = nil;
    [_likeService release]; _likeService = nil;
//    [_viewService release]; _viewService = nil;
//    [_userService release]; _userService = nil;
//    [_commentsService release]; _commentsService = nil;
    
    [super dealloc];
}

-(id) initWithDelegate:(id<SocializeServiceDelegate>)delegate
{
    self = [super init];
    if(self != nil)
    {
        _objectFactory = [[SocializeObjectFactory alloc]init];
        _provider = [[SocializeProvider alloc] init];
        _authService = [[SocializeAuthenticateService alloc] initWithProvider:_provider objectFactory:_objectFactory delegate:delegate];
        _likeService  = [[SocializeLikeService alloc] initWithProvider:_provider objectFactory:_objectFactory delegate:delegate];
        //       _viewService  = [[SocializeViewService alloc] initWithProvider:_provider objectFactory:_objectFactory delegate:delegate];
        //        _userService = [[SocializeUserService alloc] initWithProvider:_provider objectFactory:_objectFactory delegate:delegate];
       //         _commentsService = [[SocializeCommentsService alloc] initWithProvider:_provider objectFactory:_objectFactory delegate:delegate];
        //        _entityService = [[SocializeEntityService alloc]initWithProvider:_provider objectFactory:_objectFactory delegate:delegate];
    }
    return self;
}


#pragma mark authentication info
-(void)authenticateWithApiKey:(NSString*)apiKey 
          apiSecret:(NSString*)apiSecret
{
//    _authService.delegate = delegate;
   [_authService authenticateWithApiKey:apiKey apiSecret:apiSecret]; 
}


/*
-(void)authenticateWithApiKey:(NSString*)apiKey 
                            apiSecret:(NSString*)apiSecret 
                                 udid:(NSString*)udid
                  thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                     thirdPartyUserId:(NSString*)thirdPartyUserId
                       thirdPartyName:(ThirdPartyAuthName)thirdPartyName
                             delegate:(id<SocializeAuthenticationDelegate>)delegate
{
    _authService.delegate = delegate;
    [_authService  authenticateWithApiKey:apiKey 
                           apiSecret:apiSecret
                                udid:udid
                           thirdPartyAuthToken:thirdPartyAuthToken
                           thirdPartyUserId:thirdPartyUserId
                           thirdPartyName:thirdPartyName
                                ];
}
 */

-(BOOL)isAuthenticated{
    return [SocializeAuthenticateService isAuthenticated];
}

-(void)removeAuthenticationInfo
{
    [_authService removeAuthenticationInfo];
}

#pragma mark like related stuff

-(void)likeEntityWithKey:(NSString*)key andLongitude:(NSNumber*)lng latitude: (NSNumber*)lat
{
    [_likeService postLikeForEntityKey:key andLongitude:lng latitude:lat]; 
}

-(void)unlikeEntity:(id<SocializeLike>)like
{
    [_likeService deleteLike:like]; 
}

@end