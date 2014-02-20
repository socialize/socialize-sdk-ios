//
//  SZFacebookLinkOptions.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZFacebookLinkOptions.h"

@implementation SZFacebookLinkOptions
@synthesize permissions = _permissions;
@synthesize willSendLinkRequestToSocializeBlock = _willSendLinkRequestToSocializeBlock;

+ (SZFacebookLinkOptions*)defaultOptions {
    SZFacebookLinkOptions *options = [[SZFacebookLinkOptions alloc] init];
    
    return options;
}

@end
