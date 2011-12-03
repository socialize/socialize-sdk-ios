//
//  NSError+Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/2/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "NSError+Socialize.h"
#import "SocializeErrorDefinitions.h"

@implementation NSError (Socialize)

+ (NSError*)defaultSocializeErrorForCode:(NSUInteger)code {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:SocializeDefaultLocalizedErrorStringForCode(code) forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:SocializeErrorDomain code:code userInfo:userInfo];
    return error;
}

+ (NSError*)socializeUnexpectedJSONResponseErrorForResponse:(NSString*)responseString {
    NSError *error = [self defaultSocializeErrorForCode:SocializeErrorUnexpectedJSONResponse];
    return error;
}

@end
