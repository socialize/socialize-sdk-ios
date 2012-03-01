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

@implementation SocializeTestCase
@synthesize lastShownAlert = lastReceivedAlert_;
@synthesize expectedDeallocations = expectedDeallocations_;

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertShown:) name:UIAlertViewDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectDeallocated:) name:NSObjectClassDidDeallocateNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    self.expectedDeallocations = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
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

- (void)setUp {
    [super setUp];
    
    self.lastShownAlert = nil;
}

- (void)tearDownClass {
    [super tearDownClass];

    if ([self.expectedDeallocations count] > 0) {
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
    [NSObject startObservingDeallocationsForClass:[object class]];
    NSValue *address = [NSValue valueWithPointer:object];
    NSString *commentString = [NSString stringWithCString:(const char*)test encoding:NSASCIIStringEncoding];
    [self.expectedDeallocations setObject:commentString forKey:address];
}

@end
