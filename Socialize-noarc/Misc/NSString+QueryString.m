//
//  NSString+QueryString.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "NSString+QueryString.h"

@implementation NSString (QueryString)

- (NSArray*)parseQueryString {
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    for (NSString *pairString in pairs) {
        NSArray *pair = [pairString componentsSeparatedByString:@"="];
        if ([pair count] == 2) {
            [result addObject:pair];
        }
    }
    
    if ([result count] == 0)
        return nil;
    
    return result;
}

@end
