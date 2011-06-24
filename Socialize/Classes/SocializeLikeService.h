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

@interface SocializeLikeService : NSObject<SocializeRequestDelegate> {
    
@private
    id<SocializeLikeServiceDelegate> _delegate;
    SocializeProvider                *_provider;
    SocializeObjectFactory           *_objectCreator;
}

@property (nonatomic, assign) id<SocializeLikeServiceDelegate> delegate;
@property (nonatomic, assign) SocializeProvider                *provider;
@property (nonatomic, assign) SocializeObjectFactory           *objectCreator;

-(id) initWithProvider: (SocializeProvider*)provider objectFactory: (SocializeObjectFactory*) objectFactory delegate: (id<SocializeLikeServiceDelegate>) delegate;
-(void)getLikes:(NSString*)key, ...;
-(void)getLike:(NSInteger)likeId;
-(void)deleteLike:(NSInteger)likeId;
-(void)postLikes:(NSArray*)array;// array of entities or a string

@end
