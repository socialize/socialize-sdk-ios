//
//  UserUtilsTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "UserUtilsTests.h"
#import "_Socialize.h"
#import "SZUserUtils.h"

@interface UserUtilsTests ()
@property (nonatomic, retain) id mockSharedSocialize;
@end

@implementation UserUtilsTests
@synthesize mockSharedSocialize = mockSharedSocialize_;

- (BOOL)shouldRunOnMainThread { return YES; }

- (void)setUp {
    [super setUp];
    
    self.mockSharedSocialize = [OCMockObject mockForClass:[Socialize class]];
    [Socialize startMockingClass];
    
    [[[Socialize stub] andReturn:self.mockSharedSocialize] sharedSocialize];
}

- (void)tearDown {
    [Socialize stopMockingClassAndVerify];

    [super tearDown];
}

- (void)succeedUserAuthAndDo:(void(^)())doBlock {
    [[[self.mockSharedSocialize stub] andDo2:^(id success, id failure) {
        void (^successBlock)() = success;
        successBlock(nil);
        
        if (doBlock != nil) doBlock();
        
    }] authenticateAnonymouslyWithSuccess:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)succeedUpdateProfile {
    [[[self.mockSharedSocialize stub] andDo4:^(id profile, id image, id success, id failure) {
        void (^successBlock)(id<SZFullUser>) = success;
        successBlock(profile);
    }] updateUserProfile:OCMOCK_ANY profileImage:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)testSuccessfulSaveUserSettings {
    
    // Start not authed
    [self fakeCurrentUserAnonymousInSocialize:self.mockSharedSocialize];
    
    // Become anonymous
    [self succeedUserAuthAndDo:^{
        [self.mockSharedSocialize reset];
        [self fakeCurrentUserAnonymousInSocialize:self.mockSharedSocialize];
    }];
    
    // Profile update succeeds with shared socialize
    [self succeedUpdateProfile];
    
    // Call utils settings save
    [self prepare];
    
    id mockUser = [OCMockObject mockForProtocol:@protocol(SZFullUser)];
    
    [SZUserUtils saveUserSettings:mockUser profileImage:nil success:^(id<SZFullUser> user) {
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1];
}

- (void)testIsLinkedFalseWhenAnonymous {
    [self fakeCurrentUserAnonymousInSocialize:self.mockSharedSocialize];
    BOOL isLinked = [SZUserUtils userIsLinked];
    GHAssertFalse(isLinked, @"Should not be linked");
}

- (void)testIsLinkedTrueWhenLinked {
    SZFullUser *fullUser = [[[SZFullUser alloc] init] autorelease];
    fullUser.thirdPartyAuth = [NSArray arrayWithObject:kSocializeFacebookStringForAPI];
    [self fakeCurrentUserWithSocialize:self.mockSharedSocialize user:fullUser];
    BOOL isLinked = [SZUserUtils userIsLinked];
    GHAssertTrue(isLinked, @"Should be linked");
}

@end
