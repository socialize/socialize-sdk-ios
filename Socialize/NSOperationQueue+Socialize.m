//
//  NSOperationQueue+Socialize.m
//  Socialize
//
//  Created by Nathaniel Griswold on 7/12/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "NSOperationQueue+Socialize.h"

static NSOperationQueue *socializeQueue;

@implementation NSOperationQueue (Socialize)

+ (void)initialize {
    if ([self class] == [NSOperationQueue class]) {
        socializeQueue = [[NSOperationQueue alloc] init];
        [socializeQueue setMaxConcurrentOperationCount:10];
    }
}

+ (NSOperationQueue*)socializeQueue {
    return socializeQueue;
}

@end
