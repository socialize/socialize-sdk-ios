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
#import "SocializeEntityService.h"
#import "SocializeLikeService.h"
#import "SocializeViewService.h"
#import "SocializeUserService.h"
#import "SocializeCommonDefinitions.h"

//********************x******************************************************************************//
//This is a general facade of the   SDK`s API. Through it a third party developers could use the API. //
//**************************************************************************************************//




@interface Socialize : NSObject 
{
    @private
    SocializeObjectFactory          *_objectFactory;
    SocializeProvider               *_provider;

    SocializeAuthenticateService    *_authService;
    SocializeLikeService            *_likeService;
}

@property (nonatomic, readonly) SocializeLikeService *     likeService;


-(void)authenticateWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret    ;


-(BOOL)isAuthenticated;
-(void)removeAuthenticationInfo;
-(id)initWithDelegate:(id<SocializeServiceDelegate>)delegate;

/** like related stuff **/
-(void)likeEntityWithKey:(NSString*)key andLongitude:(NSNumber*)lng latitude: (NSNumber*)lat;
-(void)unlikeEntity:(id<SocializeLike>)like;
@end