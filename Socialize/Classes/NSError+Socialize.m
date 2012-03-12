//
//  NSError+Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/2/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "NSError+Socialize.h"
#import "SocializeErrorDefinitions.h"
#import "SocializeError.h"
#import "StringHelper.h"

@implementation NSError (Socialize)

+ (NSError*)socializeErrorWithCode:(NSUInteger)code description:(NSString*)description {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:NSLocalizedString(description, @"") forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:SocializeErrorDomain code:code userInfo:userInfo];
    return error;
}

+ (NSError*)defaultSocializeErrorForCode:(NSUInteger)code {
    return [self socializeErrorWithCode:code description:SocializeDefaultErrorStringForCode(code)];
}

+ (NSError*)socializeUnexpectedJSONResponseErrorWithResponse:(NSString*)responseString reason:(NSString*)reason  {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:SocializeDefaultErrorStringForCode(SocializeErrorUnexpectedJSONResponse) forKey:NSLocalizedDescriptionKey];
    [userInfo setObject:NSLocalizedFailureReasonErrorKey forKey:reason];
    [userInfo setObject:responseString forKey:kSocializeErrorResponseBodyKey];
    NSError *error = [NSError errorWithDomain:SocializeErrorDomain code:SocializeErrorUnexpectedJSONResponse userInfo:userInfo];
    return error;
}

+ (NSError*)socializeServerReturnedErrorsErrorWithErrorsArray:(NSArray*)errorsArray objectsArray:(NSArray*)objectsArray {
    id<SocializeError> firstError = [errorsArray objectAtIndex:0];
    NSString *description = firstError.error;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:NSLocalizedString(description, @"") forKey:NSLocalizedDescriptionKey];
    [userInfo setObject:errorsArray forKey:kSocializeErrorServerErrorsArrayKey];
    [userInfo setObject:objectsArray forKey:kSocializeErrorServerObjectsArrayKey];
    NSError *error = [NSError errorWithDomain:SocializeErrorDomain code:SocializeErrorServerReturnedErrors userInfo:userInfo];
    return error;
}

+ (NSError*)socializeServerReturnedHTTPErrorErrorWithResponse:(NSHTTPURLResponse*)response responseBody:(NSString*)responseBody {
    NSArray *lines = [responseBody componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *defaultDescription = SocializeDefaultLocalizedErrorStringForCode(SocializeErrorServerReturnedHTTPError);
    NSString *description = [NSString stringWithFormat:@"%@ (HTTP %d)", defaultDescription, [response statusCode]];
    if ([lines count]) {
        NSString *firstLine = [lines objectAtIndex:0];
        if ([firstLine length] > 0 && ![[firstLine lowercaseString] containsString:@"<html"]) {
            // Sometimes the server spits out more specific errors right in the response body.
            // It looks like we have one of these, so override the description
            description = [NSString stringWithFormat:@"%@ (HTTP %d)", firstLine, [response statusCode]];
        }
    }
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:defaultDescription forKey:NSLocalizedDescriptionKey];
    [userInfo setObject:description forKey:NSLocalizedDescriptionKey];
    [userInfo setObject:responseBody forKey:kSocializeErrorResponseBodyKey];
    [userInfo setObject:response forKey:kSocializeErrorNSHTTPURLResponseKey];
    NSError *error = [NSError errorWithDomain:SocializeErrorDomain code:SocializeErrorServerReturnedHTTPError userInfo:userInfo];
    return error;
}

- (BOOL)isSocializeErrorWithCode:(SocializeErrorCode)code {
    return ([[self domain] isEqualToString:SocializeErrorDomain] && [self code] == code);
}

@end
