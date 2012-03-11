//
//  SocializeShareOptions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/25/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeUIShareOptions.h"
#import "SocializeEntity.h"

@implementation SocializeUIShareOptions
@synthesize entity = entity_;
@synthesize facebookAuthOptions = facebookAuthOptions_;
@synthesize twitterAuthOptions = twitterAuthOptions_;

- (void)dealloc {
    self.entity = nil;
    self.facebookAuthOptions = nil;
    self.twitterAuthOptions = nil;
    
    [super dealloc];
}

+ (id)UIShareOptionsWithEntity:(id<SocializeEntity>)entity {
    return [[[self alloc] initWithEntity:entity] autorelease];
}

- (id)initWithEntity:(id<SocializeEntity>)entity {
    if (self = [super init]) {
        self.entity = entity;
    }
    return self;
}

@end
