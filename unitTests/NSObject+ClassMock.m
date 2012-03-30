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
#import "ClassMockRegistry.h"

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
    return [ClassMockRegistry copiedClassForClass:(Class)self];
}

/**
 * Return the shared class mock instance
 */
- (id)classMock {
    return [ClassMockRegistry classMockForClass:(Class)self];
}

#pragma mark Class method forwarding (metaclass instance methods)

/*
 Notes:
 These are implementations of the two general forwarding instance methods.
 This will handle forwarding class method calls (we are a metaclass, i.e., the original classes isa)
 self will be the original Class instance with isa modified to this class (ClassMockForwarder)
 */
- (void)forwardInvocation:(NSInvocation*)inv {
    id mock = [ClassMockRegistry classMockForClass:(Class)self];
    [inv invokeWithTarget:mock];
}


- (NSMethodSignature*)methodSignatureForSelector:(SEL)sel {
    // See comments in forwardInvocation for info on self
    id mock = [ClassMockRegistry classMockForClass:(Class)self];
    return [mock methodSignatureForSelector:sel];
}

/** Class method to Resolve instance methods. As one example, OCMock recorders created on the modified class will
 * call this when forwarding. We use our stashed copy with unmodified isa to do a real instance lookup
 */
- (NSMethodSignature*)instanceMethodSignatureForSelector:(SEL)sel {
    Class copiedClass = [ClassMockRegistry copiedClassForClass:(Class)self];
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
    [ClassMockRegistry unregisterClassMockForClass:(Class)self];
}

- (void)stopMockingClassAndVerify {
    id existingMock = [[[ClassMockRegistry classMockForClass:(Class)self] retain] autorelease];
    [self stopMockingClass];
    [existingMock verify];
}

@end

@implementation NSObject (ClassMock)

+ (void)startMockingClassWithClassMock:(id)classMock {
    // Register the class-mocking OCMock instance with the MockForwarder
    [ClassMockRegistry registerClassMock:classMock forClass:self];
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
