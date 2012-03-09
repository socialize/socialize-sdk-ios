//
//  SocializeTestCase.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeTestCase.h"
#import "UIAlertView+Observer.h"
#import "NSObject+Observer.h"
#import <objc/runtime.h>

id testSelf;

@implementation SocializeTestCase
@synthesize lastShownAlert = lastReceivedAlert_;
@synthesize expectedDeallocations = expectedDeallocations_;
@synthesize swizzledMethods = swizzledMethods_;
@synthesize lastException = lastException_;

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertShown:) name:UIAlertViewDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectDeallocated:) name:NSObjectClassDidDeallocateNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    self.expectedDeallocations = nil;
    self.swizzledMethods = nil;
    self.lastException = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (NSMutableDictionary*)swizzledMethods {
    if (swizzledMethods_ == nil) {
        swizzledMethods_ = [[NSMutableDictionary alloc] init];
    }
    
    return swizzledMethods_;
}

- (void)alertShown:(NSNotification*)notification {
    self.lastShownAlert = [notification object];
}

- (NSMutableDictionary*)expectedDeallocations {
    if (expectedDeallocations_ == nil) {
        expectedDeallocations_ = [[NSMutableDictionary alloc] init];
    }
    
    return expectedDeallocations_;
}

- (void)handleException:(NSException *)exception {
    self.lastException = exception;
    [ClassMockForwarder stopMockingAllClasses];
}

- (void)setUp {
    [super setUp];
    
    self.expectedDeallocations = nil;
    self.lastShownAlert = nil;
}

- (void)setUpClass {
    testSelf = self;
}

- (void)tearDownClass {
    [super tearDownClass];
    
    testSelf = nil;
    
    [self deswizzle];

    if ([self.expectedDeallocations count] > 0) {
        [NSThread sleepForTimeInterval:0.1];
    }
    if ([self.expectedDeallocations count] > 0 && self.lastException == nil) {
        NSMutableString *reason = [NSMutableString stringWithString:@"Expected deallocations were not observed. Failing entire suite\n"];        
        [reason appendString:@"------ Failed deallocations ------"];
        
        [self.expectedDeallocations enumerateKeysAndObjectsUsingBlock:^(NSValue *address, NSString *failedTest, BOOL *stop) {
            [reason appendFormat:@"%@ / %@\n", failedTest, address];
        }];
        [reason appendString:@"------ End Failed deallocations ------"];
        
        GHAssertTrue(NO, reason);
    }
}

- (void)objectDeallocated:(NSNotification*)notification {
    NSValue *address = [[notification userInfo] objectForKey:NSObjectDeallocatedAddressKey];
    if ([self.expectedDeallocations objectForKey:address]) {
        [self.expectedDeallocations removeObjectForKey:address];
    }
}

- (void)expectDeallocationOfObject:(NSObject*)object fromTest:(SEL)test {
    Class class = [object class];
    if ([[NSStringFromClass(class) componentsSeparatedByString:@"-"] count] == 3) {
        // Hackaround for OCPartialMocks -- OCMock dynamically makes real object a subclass of itself
        class = [class superclass];
    }
    [NSObject startObservingDeallocationsForClass:[object superclass]];
    NSValue *address = [[[NSValue valueWithPointer:object] copy] autorelease];
    NSString *commentString = [NSString stringWithCString:(const char*)test encoding:NSASCIIStringEncoding];
    [self.expectedDeallocations setObject:commentString forKey:address];
}

- (void)swizzleClass:(Class)target_class selector:(SEL)classSelector toObject:(id)object selector:(SEL)objectSelector {
    Method originalMethod = class_getClassMethod(target_class, classSelector);
    Method swizzledMethod = class_getInstanceMethod([object class], objectSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    NSValue *orig = [NSValue valueWithBytes:&originalMethod objCType:@encode(Method)];
    NSValue *swizzled = [NSValue valueWithBytes:&swizzledMethod objCType:@encode(Method)];
    [self.swizzledMethods setObject:swizzled forKey:orig];
}

- (void)deswizzle {
    [self.swizzledMethods enumerateKeysAndObjectsUsingBlock:^(NSValue *orig, NSValue *swizzled, BOOL *stop) {
        Method origMethod, swizzledMethod;
        [orig getValue:&origMethod];
        [swizzled getValue:&swizzledMethod];
        method_exchangeImplementations(swizzledMethod, origMethod);
    }];
}


@end
