//
//  SocializeEntity.m
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeEntity.h"


@implementation SocializeEntity


@synthesize  key   = _key;
@synthesize  name  = _name;
@synthesize  views = _views; 
@synthesize  likes = _likes;
@synthesize  comments = _comments;
@synthesize  shares = _shares;
@synthesize  meta = _meta;

-(void)dealloc
{
    [_key release];
    [_name release];
    [_meta release];
    
    [super dealloc];
}

+ (SocializeEntity*)entityWithKey:(NSString*)key name:(NSString*)name {
    SocializeEntity *entity = [[[self alloc] init] autorelease];
    entity.key = key;
    entity.name = name;
    return entity;
}

@end
