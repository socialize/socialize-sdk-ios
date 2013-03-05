//
//  SocializeTestCase.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeObjects.h"
#import <OCMock/OCMock.h>
#import "TestUtils.h"
#import <OCMock/NSObject+ClassMock.h>
#import "SocializeService+Testing.h"
#import "StringHelper.h"
#import "_Socialize.h"
#import "SZFacebookUtils.h"
#import "SZTwitterUtils.h"
#import "SZUserUtils.h"
#import "SZLocationUtils.h"

@class SocializeTestCase;

extern id testSelf;

@interface SocializeTestCase : GHAsyncTestCase
@property (nonatomic, retain) id uut;

@property (nonatomic, retain) NSMutableDictionary *swizzledMethods;
@property (nonatomic, retain) UIAlertView *lastShownAlert;
@property (nonatomic, retain) NSMutableDictionary *expectedDeallocations;
@property (nonatomic, retain) NSMutableArray *cleanupBlocks;
@property (nonatomic, retain) NSException *lastException;
@property (nonatomic, retain) id mockSharedSocialize;

- (void)expectDeallocationOfObject:(NSObject*)object fromTest:(SEL)test;
- (void)swizzleClass:(Class)target_class selector:(SEL)classSelector toObject:(id)object selector:(SEL)objectSelector;
- (void)deswizzle;
- (id)createMockServiceForClass:(Class)serviceClass;

- (void)fakeCurrentUserWithSocialize:(id)socialize user:(id<SZFullUser>)user;
- (void)fakeCurrentUserAnonymousInSocialize:(id)socialize;
- (void)fakeCurrentUserNotAuthedInSocialize:(id)socialize;
- (void)startMockingSharedSocialize;
- (void)stopMockingSharedSocialize;
- (void)succeedFacebookPostWithVerify:(void(^)(NSString *path, NSDictionary *params))verify;
- (void)failFacebookPost;
- (void)succeedTwitterPost;
- (void)stubFacebookUsable;
- (void)stubTwitterUsable;
- (void)stubIsAuthenticated;
- (void)succeedShareCreate;
- (void)failShareCreate;
- (void)stubShouldShareLocation;
- (id)succeedGetLocation;
- (void)succeedLikeCreateWithVerify:(void(^)(id<SZLike>))verify;
- (void)stubOGLikeEnabled;
- (void)stubOGLikeDisabled;
- (void)stubLocationSharingDisabled:(BOOL)disabled;
- (void)succeedGetEntityWithResultBlock:(id<SZEntity>(^)(NSString *key))resultBlock;
- (void)failGetEntityWithError:(NSError*)error;
- (void)atTearDown:(void (^)())block;

@end
