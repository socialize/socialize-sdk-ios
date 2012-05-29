//
//  NSArray+Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/28/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "NSMutableArray+Socialize.h"

@implementation NSMutableArray (Socialize)

- (void)removeObjectsAfterIndex:(NSUInteger)index {
    NSRange range = NSMakeRange(index, [self count] - index);
    [self removeObjectsInRange:range];    
}

- (void)removeObjectsAfterObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    [self removeObjectsAfterIndex:index];
}

@end
