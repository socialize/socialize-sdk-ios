//
//  NSObject+Observer.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/28/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "NSObject+Observer.h"
#import "JRSwizzle.h"

NSString *const NSObjectClassDidDeallocateNotification = @"NSObjectClassDidDeallocateNotification";
NSString *const NSObjectDeallocatedAddressKey = @"NSObjectDeallocatedAddressKey";

static NSMutableSet *observedClasses;

@implementation NSObject (Observer)

+ (void)load {
    NSError *error = nil;
    [self jr_swizzleMethod:@selector(dealloc) withMethod:@selector(observerDealloc) error:&error];
    NSAssert(error == nil, @"error swizzling");
}

+ (NSMutableSet*)observedClasses {
    if (observedClasses == nil) {
        observedClasses = [[NSMutableSet alloc] init];
    }
    
    return observedClasses;
}

+ (void)startObservingDeallocationsForClass:(Class)class {
    [[self observedClasses] addObject:class];
}

- (void)observerDealloc {
    if ([observedClasses containsObject:[self class]]) {
        NSValue *address = [[[NSValue valueWithPointer:self] copy] autorelease];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:address forKey:NSObjectDeallocatedAddressKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NSObjectClassDidDeallocateNotification object:[self class] userInfo:userInfo];
    }
    
    // Call the real dealloc
    [self observerDealloc];
}

@end
