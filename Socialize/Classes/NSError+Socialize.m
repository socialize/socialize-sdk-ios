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

@implementation NSError (Socialize)

+ (NSError*)defaultSocializeErrorForCode:(NSUInteger)code {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:SocializeDefaultLocalizedErrorStringForCode(code) forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:SocializeErrorDomain code:code userInfo:userInfo];
    return error;
}

+ (NSError*)socializeUnexpectedJSONResponseErrorWithResponse:(NSString*)responseString description:(NSString*)description  {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:NSLocalizedString(description, @"") forKey:NSLocalizedDescriptionKey];
    [userInfo setObject:responseString forKey:kSocializeErrorResponseBodyKey];
    NSError *error = [NSError errorWithDomain:SocializeErrorDomain code:SocializeErrorUnexpectedJSONResponse userInfo:userInfo];
    return error;
}

+ (NSError*)socializeServerReturnedErrorsErrorWithErrorsArray:(NSArray*)errorsArray {
    id<SocializeError> firstError = [errorsArray objectAtIndex:0];
    NSString *description = firstError.error;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:NSLocalizedString(description, @"") forKey:NSLocalizedDescriptionKey];
    [userInfo setObject:errorsArray forKey:kSocializeErrorServerErrorsArrayKey];
    NSError *error = [NSError errorWithDomain:SocializeErrorDomain code:SocializeErrorServerReturnedErrors userInfo:userInfo];
    return error;
}

@end
