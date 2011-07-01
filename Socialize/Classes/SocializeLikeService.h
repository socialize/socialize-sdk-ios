//
//  SocializeLikeService.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/22/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeRequest.h"

@class SocializeProvider;
@class SocializeObjectFactory;

@protocol SocializeLikeServiceDelegate;
@protocol SocializeEntity;
@protocol SocializeLike;

@interface SocializeLikeService : NSObject<SocializeRequestDelegate> {
    
@private
    id<SocializeLikeServiceDelegate> _delegate;
    SocializeProvider                *_provider;
    SocializeObjectFactory           *_objectCreator;
}

@property (nonatomic, assign) id<SocializeLikeServiceDelegate> delegate;
@property (nonatomic, retain) SocializeProvider                *provider;
@property (nonatomic, retain) SocializeObjectFactory           *objectCreator;

-(id) initWithProvider: (SocializeProvider*)provider objectFactory: (SocializeObjectFactory*) objectFactory delegate: (id<SocializeLikeServiceDelegate>) delegate;
-(void)getLikesForEntityKey:(NSString*)key;
-(void)getLikesForEntity:(id<SocializeEntity>)entity;
-(void)getLike:(NSInteger)likeId;
-(void)deleteLike:(id<SocializeLike>)like;
-(void)postLikeForEntityKey:(NSString*)key;
-(void)postLikeForEntity:(id<SocializeEntity>)entity;

@end
