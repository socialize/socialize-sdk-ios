//
//  SocializeLike.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/22/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeLike.h"


@implementation SocializeLike
+ (SocializeLike*)likeWithEntity:(id<SocializeEntity>)entity {
    SocializeLike *like = [[[SocializeLike alloc] init] autorelease];
    like.entity = entity;
    return like;
}
@end
