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
#import <OCMock/ClassMockRegistry.h>
#import "_Socialize.h"
#import <OCMock/OCMock.h>

id testSelf;

@implementation SocializeTestCase
@synthesize lastShownAlert = lastReceivedAlert_;
@synthesize expectedDeallocations = expectedDeallocations_;
@synthesize swizzledMethods = swizzledMethods_;
@synthesize lastException = lastException_;
@synthesize uut = uut_;
@synthesize mockSharedSocialize = _mockSharedSocialize;

- (id)createUUT {
    return nil;
}

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

- (void)startMockingSharedSocialize {
    self.mockSharedSocialize = [OCMockObject mockForClass:[Socialize class]];
    [Socialize startMockingClass];
    [[[Socialize stub] andReturn:self.mockSharedSocialize] sharedSocialize];
}

- (void)stopMockingSharedSocialize {
    [Socialize stopMockingClassAndVerify];
    [self.mockSharedSocialize verify];
    self.mockSharedSocialize = nil;
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
    [ClassMockRegistry stopMockingAllClasses];
}

- (void)setUp {
    [super setUp];
    
    self.uut = [self createUUT];
    self.expectedDeallocations = nil;
    self.lastShownAlert = nil;
}

- (void)tearDown {
    self.uut = nil;
    [self.mockSharedSocialize verify];
    self.mockSharedSocialize = nil;
    
    [super tearDown];
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

- (id)createMockServiceForClass:(Class)serviceClass {
    id mockService = [OCMockObject mockForClass:serviceClass];
    [mockService stubIsKindOfClass:serviceClass];
    return mockService;
}

- (void)fakeCurrentUserWithSocialize:(id)socialize user:(id<SZFullUser>)user {
    [[[socialize stub] andReturnBool:YES] isAuthenticated];
    [[[socialize stub] andReturn:user] authenticatedFullUser];
    [[[socialize stub] andReturn:(id<SZUser>)user] authenticatedUser];
}

- (void)fakeCurrentUserAnonymousInSocialize:(id)socialize {
    id mockUser = [OCMockObject mockForProtocol:@protocol(SocializeFullUser)];
    [[[mockUser stub] andReturn:nil] thirdPartyAuth];
    [self fakeCurrentUserWithSocialize:socialize user:mockUser];
}

- (void)fakeCurrentUserNotAuthedInSocialize:(id)socialize {
    [[[socialize stub] andReturnBool:NO] isAuthenticated];
    [[[socialize stub] andReturn:nil] authenticatedFullUser];
    [[[socialize stub] andReturn:nil] authenticatedUser];

}

- (void)succeedFacebookPostWithVerify:(void(^)(NSString *path, NSDictionary *params))verify {
    [[[SZFacebookUtils expect] andDo4:^(NSString *path, NSDictionary *params, id success, id failure) {
        
        BLOCK_CALL_2(verify, path, params);

        void (^successBlock)(id result) = success;
        successBlock(nil);
    }] postWithGraphPath:OCMOCK_ANY params:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)failFacebookPost {
    [[[SZFacebookUtils expect] andDo4:^(NSString *path, NSDictionary *params, id success, id failure) {
        void (^failureBlock)(NSError *error) = failure;
        failureBlock(nil);
    }] postWithGraphPath:OCMOCK_ANY params:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)succeedTwitterPost {
    [[[SZTwitterUtils expect] andDo5:^(id _1, id _2, id _3, id success, id failure) {
        void (^successBlock)(id result) = success;
        successBlock(nil);
    }] postWithViewController:OCMOCK_ANY path:OCMOCK_ANY params:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)stubFacebookUsable {
    [[[SZFacebookUtils stub] andReturnBool:YES] isAvailable];
    [[[SZFacebookUtils stub] andReturnBool:YES] isLinked];
}

- (void)stubTwitterUsable {
    [[[SZTwitterUtils stub] andReturnBool:YES] isAvailable];
    [[[SZTwitterUtils stub] andReturnBool:YES] isLinked];
}

- (void)stubIsAuthenticated {
    [[[SZUserUtils stub] andReturnBool:YES] userIsAuthenticated];
}

- (void)stubOGLikeEnabled {
    [[[Socialize stub] andReturnBool:YES] OGLikeEnabled];
}

- (void)stubOGLikeDisabled {
    [[[Socialize stub] andReturnBool:NO] OGLikeEnabled];
}

- (void)stubLocationSharingDisabled:(BOOL)disabled {
    [[[Socialize stub] andReturnBool:disabled] locationSharingDisabled];
}

- (void)succeedShareCreate {
    [[[self.mockSharedSocialize stub] andDo3:^(id _1, id success, id _3) {
        void (^successBlock)(id result) = success;
        successBlock(nil);
    }] createShare:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)failShareCreate {
    [[[self.mockSharedSocialize stub] andDo3:^(id _1, id _2, id failure) {
        void (^failureBlock)(id result) = failure;
        failureBlock(nil);
    }] createShare:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)succeedLikeCreateWithVerify:(void(^)(id<SZLike>))verify {
    [[[self.mockSharedSocialize expect] andDo3:^(id like, id success, id _3) {
        BLOCK_CALL_1(verify, like);
        void (^successBlock)(id result) = success;
        successBlock(nil);
    }] createLike:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)stubShouldShareLocation {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kSocializeShouldShareLocationKey];
}

- (id)succeedGetLocation {
    id mockLocation = [OCMockObject niceMockForClass:[CLLocation class]];
    [[[SZLocationUtils expect] andDo2:^(id success, id _2) {
        void (^successBlock)(id result) = success;
        successBlock(mockLocation);
    }] getCurrentLocationWithSuccess:OCMOCK_ANY failure:OCMOCK_ANY];
    
    return mockLocation;
}

@end
