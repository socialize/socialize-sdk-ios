//
//  SZShareOptions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/17/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZShareOptions.h"

@implementation SZShareOptions
@synthesize dontShareLocation = dontShareLocation_;
@synthesize shareTo = shareTo_;
@synthesize willPostToSocialNetworkBlock = willPostToSocialNetworkBlock_;
@synthesize didPostToSocialNetworkBlock = didPostToSocialNetworkBlock_;

+ (SZShareOptions*)defaultOptions {
    return [[[self alloc] init] autorelease];
}

@end