//
//  SZIdentifierUtils.m
//  Socialize
//
//  Created by David Jedeikin on 4/30/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import "SZIdentifierUtils.h"
#import "NSData+Base64.h"

//set to 1 to use it, 0 to use IDFV instead
#define SHOULD_USE_IDFA 1

@implementation SZIdentifierUtils

NSString *const IDFAUnavailable = @"UNAVAILABLE";

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
    identifier = [NSString stringWithString:IDFAUnavailable];
#endif
    
    return identifier;
}

+ (NSString *)base64AdvertisingIdentifierString {
    NSString *adsId = [self advertisingIdentifierString];
    return [self base64StringFromString:adsId];
}

+ (NSString *)vendorIdentifierString {
    UIDevice *device = [UIDevice currentDevice];
    NSString *identifier = [device.identifierForVendor UUIDString];
    return identifier;
}

+ (NSString *)base64VendorIdentifierString {
    NSString *vendor = [self vendorIdentifierString];
    return [self base64StringFromString:vendor];
}

+ (NSString *)base64StringFromString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encoded = [data base64Encoding];
    return encoded;
}

@end
