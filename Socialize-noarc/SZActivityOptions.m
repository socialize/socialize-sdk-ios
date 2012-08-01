//
//  SZActivityOptions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/24/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZActivityOptions.h"

@implementation SZActivityOptions
@synthesize dontShareLocation = dontShareLocation_;
@synthesize willPostToSocialNetworkBlock = willPostToSocialNetworkBlock_;
@synthesize didPostToSocialNetworkBlock = didPostToSocialNetworkBlock_;
@synthesize didFailToPostToSocialNetworkBlock = _didFailToPostToSocialNetworkBlock;
@synthesize willAttemptPostingToSocialNetworkBlock = _willAttemptPostingToSocialNetworkBlock;
@synthesize didSucceedPostingToSocialNetworkBlock = _didSucceedPostingToSocialNetworkBlock;
@synthesize didFailPostingToSocialNetworkBlock = _didFailPostingToSocialNetworkBlock;

+ (id)defaultOptions {
    return [[self alloc] init];
}

@end
