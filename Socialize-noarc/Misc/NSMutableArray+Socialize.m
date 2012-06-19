//
//  NSArray+Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/28/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "NSMutableArray+Socialize.h"

@implementation NSMutableArray (Socialize)

- (void)removeObjectsFromIndex:(NSUInteger)index {
    NSUInteger count = [self count];
    NSAssert(index < count, @"Index out of bounds");
    NSUInteger size = count - index;
    NSAssert(size > 0, @"Size not larger than 0");
    
    NSRange range = NSMakeRange(index, size);
    [self removeObjectsInRange:range];        
}

- (void)removeObjectsAfterIndex:(NSUInteger)index {
    [self removeObjectsFromIndex:index + 1];
}

- (void)removeObjectsAfterObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    [self removeObjectsAfterIndex:index];
}

@end
