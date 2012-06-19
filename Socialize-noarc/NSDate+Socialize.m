//
//  NSDate+Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "NSDate+Socialize.h"

@implementation NSDate (Socialize)

+ (NSDate*)dateWithSocializeDateString:(NSString*)socializeDateString {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
    NSDate *date = [df dateFromString:socializeDateString];
    [df release];
    return date;
}

@end
