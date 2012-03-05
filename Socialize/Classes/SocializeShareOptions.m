//
//  SocializeShareOptions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/25/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeShareOptions.h"
#import "SocializeEntity.h"

@implementation SocializeShareOptions
@synthesize entity = entity_;
@synthesize facebookAuthOptions = facebookAuthOptions_;
@synthesize twitterAuthOptions = twitterAuthOptions_;

- (void)dealloc {
    self.entity = nil;
    self.facebookAuthOptions = nil;
    self.twitterAuthOptions = nil;
    
    [super dealloc];
}

+ (id)shareOptionsWithEntity:(id<SocializeEntity>)entity {
    return [[[self alloc] initWithEntity:entity] autorelease];
}

- (id)initWithEntity:(id<SocializeEntity>)entity {
    if (self = [super init]) {
        self.entity = entity;
    }
    return self;
}

@end
