//
//  SZIdentifierUtils.m
//  Socialize
//
//  Created by David Jedeikin on 4/30/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import "SZIdentifierUtils.h"
#import "NSData+Base64.h"

//set to 1 to use it, 0 to use generic UUID that's cached
#define SHOULD_USE_IDFA 1

@implementation SZIdentifierUtils

//Returns IDFA UNLESS directive forces it to return IDFV
+ (NSString *)advertisingIdentifierString {
    NSString *identifier;
    
#if SHOULD_USE_IDFA
    if (!NSClassFromString(@"ASIdentifierManager")) {
        return nil;
    }
    ASIdentifierManager *idManager = [ASIdentifierManager sharedManager];
    identifier = [idManager.advertisingIdentifier UUIDString];
#else
    UIDevice *device = [UIDevice currentDevice];
    identifier = [device.identifierForVendor UUIDString];
#endif
    
    return identifier;
}

+ (NSString *)base64AdvertisingIdentifierString {
    NSString *adsId = [self advertisingIdentifierString];
    NSData *data = [adsId dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encoded = [data base64Encoding];
    return encoded;
}

@end
