//
//  SocializeShare.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeShare.h"


@implementation SocializeShare

+ (SocializeShare*)shareWithEntity:(id<SocializeEntity>)entity text:(NSString*)text medium:(SocializeShareMedium)medium {
    SocializeShare *share = [[[self alloc] init] autorelease];
    share.entity = entity;
    share.text = text;
    share.medium = medium;
    return share;
}

@synthesize medium = _medium;

@end
