//
//  Blah.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/2/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeErrorDefinitions.h"

NSString *const SocializeErrorDomain = @"Socialize";


// userInfo definitions
NSString *const kSocializeErrorResponseBodyKey = @"kSocializeErrorResponseBodyKey";
NSString *const kSocializeErrorNSHTTPURLResponseKey = @"kSocializeErrorNSHTTPURLResponseKey";
NSString *const kSocializeErrorServerErrorsArrayKey = @"kSocializeErrorServerErrorsArrayKey";


static NSString *SocializeDefaultErrorStrings[SocializeNumErrors] = {
    @"Unexpected Server JSON Response",
    @"The Server Returned Errors",
    @"The Server Returned an HTTP Error Code",
    @"User Cancelled Facebook Authentication",
};

NSString *SocializeDefaultLocalizedErrorStringForCode(NSUInteger code) {
//    NSAssert(code < SocializeNumErrors, @"Bad error code %d", code);
    NSString *defaultString = SocializeDefaultErrorStrings[code];
    return NSLocalizedString(defaultString, @"");
}