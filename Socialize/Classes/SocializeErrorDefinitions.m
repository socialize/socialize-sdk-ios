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
NSString *const kSocializeErrorFullResponseBodyKey = @"kSocializeErrorFullResponseBodyKey";


static NSString *SocializeDefaultErrorStrings[SocializeNumErrors] = {
    @"Unexpected Server JSON Response",
};

NSString *SocializeDefaultLocalizedErrorStringForCode(NSUInteger code) {
//    NSAssert(code < SocializeNumErrors, @"Bad error code %d", code);
    NSString *defaultString = SocializeDefaultErrorStrings[code];
    return NSLocalizedString(defaultString, @"");
}