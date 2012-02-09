//
//  AssociativeArray.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "NSArray+AssociativeArray.h"

@implementation NSArray (Associative)

- (NSDictionary*)dictionaryFromPairs {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (NSArray *pair in self) {
        if ([pair count] != 2)
            return nil;
        
        [dictionary setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
    }
    
    return dictionary;
}

@end