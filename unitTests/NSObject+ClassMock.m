//
//  NSObject+ClassMock.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/6/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "NSObject+ClassMock.h"
#import <objc/runtime.h>
#import <OCMock/OCMock.h>

@interface OCMockObject ()
// Exposing a private OCClassMockObject method to make our implementation simpler
- (Class)mockedClass;
@end


static NSMutableDictionary *classMocks;
static NSMutableDictionary *copiedClasses;

@implementation ClassMockForwarder

#pragma mark Utilities

/*
 * The default -class implementation will return [ClassMockForwarder class], which is not what we want.
 * (We want to work like +class here)
 */
- (Class)class {
    return (Class)self;
}

/**
 * Return a copy of the original class with isa unmodified
 */
- (Class)origClass {
    return [ClassMockForwarder copiedClassForClass:(Class)self];
}

/**
 * Return the shared class mock instance
 */
- (id)classMock {
    return [ClassMockForwarder classMockForClass:(Class)self];
}

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
    Class copied = objc_duplicateClass(class, name, 0);

    NSValue *copiedClassValue = [NSValue valueWithPointer:copied];
    [[self copiedClasses] setObject:copiedClassValue forKey:key];
}

+ (void)unregisterClassMockForClass:(Class)class {
    id existingMock = [[[self classMockForClass:class] retain] autorelease];
    NSAssert(existingMock != nil, @"Class mock not found in forwarder. Something has gone horribly wrong.");

    id key = [self keyForClassAtAddress:class];
    [[self classMocks] removeObjectForKey:key];
    [[self copiedClasses] removeObjectForKey:key];
    
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

#pragma mark Class method forwarding (metaclass instance methods)

/*
 Notes:
 These are implementations of the two general forwarding instance methods.
 This will handle forwarding class method calls (we are a metaclass, i.e., the original classes isa)
 self will be the original Class instance with isa modified to this class (ClassMockForwarder)
 */
- (void)forwardInvocation:(NSInvocation*)inv {
    id mock = [ClassMockForwarder classMockForClass:(Class)self];
    [inv invokeWithTarget:mock];
}


- (NSMethodSignature*)methodSignatureForSelector:(SEL)sel {
    // See comments in forwardInvocation for info on self
    id mock = [ClassMockForwarder classMockForClass:(Class)self];
    return [mock methodSignatureForSelector:sel];
}

/** Class method to Resolve instance methods. As one example, OCMock recorders created on the modified class will
 * call this when forwarding. We use our stashed copy with unmodified isa to do a real instance lookup
 */
- (NSMethodSignature*)instanceMethodSignatureForSelector:(SEL)sel {
    Class copiedClass = [ClassMockForwarder copiedClassForClass:(Class)self];
    return [copiedClass instanceMethodSignatureForSelector:sel];
}

- (BOOL)resolveClassMethod:(SEL)sel {
    return NO;
}

#pragma mark Real class methods
/**
 End the mocking process
 */
- (void)stopMockingClass {
    [ClassMockForwarder unregisterClassMockForClass:(Class)self];
}

- (void)stopMockingClassAndVerify {
    id existingMock = [[[ClassMockForwarder classMockForClass:(Class)self] retain] autorelease];
    [self stopMockingClass];
    [existingMock verify];
}

@end

@implementation NSObject (ClassMock)

+ (void)startMockingClassWithClassMock:(id)classMock {
    // Register the class-mocking OCMock instance with the MockForwarder
    [ClassMockForwarder registerClassMock:classMock forClass:self];
    
    // Class Method calls will go to MockForwarder after this call
    self->isa = [ClassMockForwarder class];
}

+ (void)startMockingClass {
    [self startMockingClassWithClassMock:[OCMockObject classMockForClass:self]];
}

+ (void)startMockingErrorForSelector:(SEL)sel {
    NSAssert(NO, @"`startMockingClass` must be called on %@ before invoking `%s`", [self class], sel);
}

// These should be forwarded. If the real implementation is ever called, we want to crash.
+ (id)expect {
    [self startMockingErrorForSelector:_cmd];
    return nil;
}

+ (id)stub {
    [self startMockingErrorForSelector:_cmd];
    return nil;
}

+ (void)verify {
    [self startMockingErrorForSelector:_cmd];
}

+ (void)stopMockingClass {
    [self startMockingErrorForSelector:_cmd];
}

+ (void)stopMockingClassAndVerify {
    [self startMockingErrorForSelector:_cmd];
}

+ (Class)origClass {
    [self startMockingErrorForSelector:_cmd];
    return nil;
}

+ (id)classMock {
    [self startMockingErrorForSelector:_cmd];
    return nil;
}


@end
