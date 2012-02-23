//
//  Utilities+NSHTTPCookieStorage.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "NSHTTPCookieStorage+Utilities.h"

@implementation NSHTTPCookieStorage (Utilities)

+ (void)removeCookiesInDomain:(NSString*)domain {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        if ([[cookie domain] isEqualToString:domain]) {
            [storage deleteCookie:cookie];
        }
    }
}

@end
