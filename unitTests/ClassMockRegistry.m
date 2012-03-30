//
//  ClassMockRegistry.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/30/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "ClassMockRegistry.h"
#import <objc/runtime.h>

@interface OCMockObject ()
// Exposing a private OCClassMockObject method to make our implementation simpler
- (Class)mockedClass;
@end



static NSMutableDictionary *classMocks;
static NSMutableDictionary *copiedClasses;

@implementation ClassMockRegistry

+ (void)stopMockingAllClasses {
    [[self classMocks] enumerateKeysAndObjectsUsingBlock:^(id key, id mock, BOOL *stop) {
        // Just in case dealocating triggers a verify
        [[mock retain] autorelease];
        
        Class registeredClass = [key pointerValue];
        [self unregisterClassMockForClass:registeredClass];
    }];
}

+ (void)registerClassMock:(id)classMock forClass:(Class)class {
    id key = [self keyForClassAtAddress:class];
    NSAssert([[self classMocks] objectForKey:key] == nil, @"Mock already registered!");
    [[self classMocks] setObject:classMock forKey:key];
    
    const char *name = [[NSString stringWithFormat:@"%@ (%@ Copy)", NSStringFromClass(class), NSStringFromClass(self)] UTF8String];
    if ([[self copiedClasses] objectForKey:key] == nil) {
        Class copied = objc_allocateClassPair(class, name, 0);
        objc_registerClassPair(copied);
        
        NSValue *copiedClassValue = [NSValue valueWithPointer:copied];
        [[self copiedClasses] setObject:copiedClassValue forKey:key];
    }
    
    class->isa = [ClassMockForwarder class];
}

+ (void)unregisterClassMockForClass:(Class)class {
    id existingMock = [[[self classMockForClass:class] retain] autorelease];
    NSAssert(existingMock != nil, @"Class mock not found in forwarder. Something has gone horribly wrong.");
    
    id key = [self keyForClassAtAddress:class];
    [[self classMocks] removeObjectForKey:key];
    
    class->isa = [existingMock mockedClass];
}

+ (NSMutableDictionary*)classMocks {
    if (classMocks == nil) {
        classMocks = [[NSMutableDictionary alloc] init];
    }
    
    return classMocks;
}

+ (NSMutableDictionary*)copiedClasses {
    if (copiedClasses == nil) {
        copiedClasses = [[NSMutableDictionary alloc] init];
    }
    
    return copiedClasses;
}

+ (id)keyForClassAtAddress:(void*)classAddress {
    return [NSValue valueWithPointer:classAddress];
}

+ (id)classMockForClass:(Class)class {
    id key = [self keyForClassAtAddress:class];
    id mock = [[self classMocks] objectForKey:key];
    return mock;
}

+ (Class)copiedClassForClass:(Class)class {
    id key = [self keyForClassAtAddress:class];
    NSValue *copiedClassValue = [[self copiedClasses] objectForKey:key];
    return (Class)[copiedClassValue pointerValue];
}

@end
