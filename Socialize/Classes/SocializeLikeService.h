//
//  SocializeLikeService.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/22/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeRequest.h"
#import "SocializeService.h"

@class SocializeProvider;
@class SocializeObjectFactory;

@protocol SocializeEntity;
@protocol SocializeLike;

@interface SocializeLikeService : SocializeService{
    
}


-(void)getLikesForEntityKey:(NSString*)key;
-(void)getLikesForEntity:(id<SocializeEntity>)entity;
-(void)getLike:(NSInteger)likeId;
-(void)deleteLike:(id<SocializeLike>)like;
-(void)postLikeForEntityKey:(NSString*)key andLongitude:(NSNumber*)lng latitude: (NSNumber*)lat; 
-(void)postLikeForEntity:(id<SocializeEntity>)entity andLongitude:(NSNumber*)lng latitude: (NSNumber*)lat;

@end
