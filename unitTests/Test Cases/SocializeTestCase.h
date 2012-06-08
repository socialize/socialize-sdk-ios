//
//  SocializeTestCase.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeObjects.h"

@class SocializeTestCase;

extern id testSelf;

@interface SocializeTestCase : GHAsyncTestCase
@property (nonatomic, retain) id uut;

@property (nonatomic, retain) NSMutableDictionary *swizzledMethods;
@property (nonatomic, retain) UIAlertView *lastShownAlert;
@property (nonatomic, retain) NSMutableDictionary *expectedDeallocations;
@property (nonatomic, retain) NSException *lastException;

- (void)expectDeallocationOfObject:(NSObject*)object fromTest:(SEL)test;
- (void)swizzleClass:(Class)target_class selector:(SEL)classSelector toObject:(id)object selector:(SEL)objectSelector;
- (void)deswizzle;
- (id)createMockServiceForClass:(Class)serviceClass;

- (void)fakeCurrentUserWithSocialize:(id)socialize user:(id<SZFullUser>)user;
- (void)fakeCurrentUserAnonymousInSocialize:(id)socialize;
- (void)fakeCurrentUserNotAuthedInSocialize:(id)socialize;

@end
