//
//  NSString+NSString_Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/23/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "NSString+Socialize.h"

@implementation NSString (Socialize)

+(NSString *) stringWithHumanReadableIntegerAndSuffixSinceDate:(NSDate *)date {
	NSInteger timeInterval = (NSInteger) MAX(ceil(-[date timeIntervalSinceNow]), 0);
	
	NSString *suffix;
    NSInteger integer;
	if (timeInterval/(24*3600) > 0) {
        suffix = @"d";
        integer = timeInterval / (24*3600);
	} else if (timeInterval/3600 > 0) {
        suffix = @"h";
        integer = timeInterval / (3600);
	} else if (timeInterval/60 > 0) {
        suffix = @"m";
        integer = timeInterval / 60;
	} else {
        suffix = @"s";
        integer = timeInterval;
    }
	
	return [NSString stringWithFormat:@"%i%@",integer, suffix];
}

@end
