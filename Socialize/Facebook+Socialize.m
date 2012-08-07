//
//  Facebook+Socialize.m
//  Socialize
//
//  Created by Nathaniel Griswold on 8/7/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "Facebook+Socialize.h"
#import "SZFacebookUtils.h"

@implementation Facebook (Socialize)

- (BOOL)isForCurrentSocializeSession {
    NSString *sAccessToken = [SZFacebookUtils accessToken];
    NSString *sURLSchemeSuffix = [SZFacebookUtils urlSchemeSuffix];
    
    return [[self accessToken] isEqualToString:sAccessToken] && ([self urlSchemeSuffix] == sURLSchemeSuffix || [[self urlSchemeSuffix] isEqualToString:sURLSchemeSuffix]);
}

@end
