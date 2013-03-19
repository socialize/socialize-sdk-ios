//
//  ASIdentifierManager+Utilities.m
//  Socialize
//
//  Created by Nate Griswold on 3/19/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "ASIdentifierManager+Utilities.h"
#import "NSData+Base64.h"

@implementation ASIdentifierManager (Utilities)

+ (NSString*)advertisingIdentifierString {
    if (!NSClassFromString(@"ASIdentifierManager")) {
        return nil;
    }
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (NSString*)base64AdvertisingIdentifierString {
    NSString *adsId = [self advertisingIdentifierString];
    NSData *data = [adsId dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encoded = [data base64Encoding];
    return encoded;
}

@end
