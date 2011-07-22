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


/***************************************************************************************************
                                            NOTE
Every thing in socialize revolves around the concept of “Entity”. An entity be liked, unliked, commented on etc. 
In Socialize an entity can only be a url. So when creating an entity always remember to input the key for the entity as a url 
otherwise you will get a failure.  
*/


@interface Socialize : NSObject 
{
    @private
    SocializeObjectFactory          *_objectFactory;
    SocializeProvider               *_provider;

    SocializeAuthenticateService    *_authService;
    SocializeLikeService            *_likeService;
    SocializeCommentsService        *_commentsService;
    SocializeEntityService          *_entityService;
    SocializeViewService            *_viewService;
}

@property (nonatomic, retain) SocializeAuthenticateService    *authService;
@property (nonatomic, retain) SocializeLikeService            *likeService;
@property (nonatomic, retain) SocializeCommentsService        *commentsService;
@property (nonatomic, retain) SocializeEntityService          *entityService;
@property (nonatomic, retain) SocializeViewService            *viewService;

-(id)initWithDelegate:(id<SocializeServiceDelegate>)delegate;
-(void)setDelegate:(id<SocializeServiceDelegate>)delegate;
/* local in memory object creation */
-(id)createObjectForProtocol:(Protocol *)protocol;

/*** Authentication related info ***/
-(void)authenticateWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret;
-(BOOL)isAuthenticated;
-(void)removeAuthenticationInfo;

/** like related stuff **/
-(void)likeEntityWithKey:(NSString*)url longitude:(NSNumber*)lng latitude:(NSNumber*)lat;
-(void)unlikeEntity:(id<SocializeLike>)like;
-(void)getLikesForEntityKey:(NSString*)url  first:(NSNumber*)first last:(NSNumber*)last;

/* comments */
-(void) getCommentById: (int) commentId;
-(void) getCommentList: (NSString*) entryKey first:(NSNumber*)first last:(NSNumber*)last;

-(void) createCommentForEntityWithKey: (NSString*) url comment: (NSString*) comment;
-(void) createCommentForEntity:(id<SocializeEntity>) entity comment: (NSString*) comment;

/* Entity methods*/
-(void)getEntityByKey:(NSString *)url;

/* View methods*/
-(void)viewEntity:(id<SocializeEntity>)entity;
@end