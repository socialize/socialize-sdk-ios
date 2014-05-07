//
//  SocializeErrorDefinitions.m
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
NSString *const kSocializeErrorServerObjectsArrayKey = @"kSocializeErrorServerObjectsArrayKey";


static NSString *SocializeDefaultErrorStrings[SocializeNumErrors] = {
    @"Unexpected Server JSON Response",
    @"The Server Returned Errors",
    @"The Server Returned an HTTP Error Code",
    @"Facebook Authentication Cancelled",
    @"Facebook is not Configured",
    @"Facebook authentication was restarted before completion",
    @"Facebook authentication was failed",
    @"Twitter Authentication Cancelled",
    @"Twitter is not Configured",
    @"SMS Not Available",
    @"Email Not Available",
    @"Failed to Create Share",
    @"User Cancelled Share",
    @"Third party is not linked",
    @"Third party is not available",
    @"Third party link cancelled by user",
    @"Process cancelled by user",
    @"Comment cancelled by user",
    @"Location update was rejected by user",
    @"Location update timed out",
    @"Link cancelled by user",
    @"Linking is not possible",
    @"Network Selection Cancelled by user",
    @"Failed to send SMS",
    @"Like creation cancelled by user",
    @"The request was cancelled",
    @"Entity cannot be loaded",
    @"Pinterest sharing not available",
    @"Pinterest application failed share entity",
    @"WhatsApp sharing not available",
    @"WhatsApp application failed share entity",
    @"WhatsApp sharing cancelled by user",
};

NSString *SocializeDefaultErrorStringForCode(NSUInteger code) {
//    NSAssert(code < SocializeNumErrors, @"Bad error code %d", code);
    return SocializeDefaultErrorStrings[code];
}

NSString *SocializeDefaultLocalizedErrorStringForCode(NSUInteger code) {
    NSString *defaultString = SocializeDefaultErrorStringForCode(code);
    return NSLocalizedString(defaultString, @"");
}