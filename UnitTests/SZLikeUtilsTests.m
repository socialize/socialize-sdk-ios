//
//  SZLikeUtilsTests.m
//  Socialize
//
//  Created by Nathaniel Griswold on 8/1/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZLikeUtilsTests.h"
#import "SZLikeUtils.h"

@implementation SZLikeUtilsTests

- (void)setUp {
    [super setUp];
    
    [self startMockingSharedSocialize];
    [SZTwitterUtils startMockingClass];
    [SZFacebookUtils startMockingClass];
    [SZUserUtils startMockingClass];
    [SZLocationUtils startMockingClass];
}

- (void)tearDown {
    [super tearDown];
    
    [self stopMockingSharedSocialize];
    [SZFacebookUtils stopMockingClassAndVerify];
    [SZTwitterUtils stopMockingClassAndVerify];
    [SZUserUtils stopMockingClassAndVerify];
    [SZLocationUtils stopMockingClassAndVerify];
}

- (void)testSucceedingFacebookOGLike {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
    
    [self stubOGLikeEnabled];
    [self stubIsAuthenticated];
    [self stubFacebookUsable];
    
    SZLikeOptions *options = [SZLikeOptions defaultOptions];

    __block BOOL willPostCalled = NO;
    options.willAttemptPostToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
        GHAssertEquals(network, SZSocialNetworkFacebook, @"Should be facebook");
        GHAssertEqualStrings(postData.path, @"me/og.likes", @"Should be og likes endpoint");
        willPostCalled = YES;
    };
    
    __block BOOL didPostCalled = NO;
    options.didPostToSocialNetworkBlock = ^(SZSocialNetwork network) {
        GHAssertEquals(network, SZSocialNetworkFacebook, @"Should be facebook");
        didPostCalled = YES;
    };

    __block BOOL didFailCalled = NO;
    options.didFailToPostToSocialNetworkBlock = ^(SZSocialNetwork network) {
        didFailCalled = YES;
    };
    
    [self succeedFacebookPostWithVerify:^void(NSString *path, NSDictionary *params) {
        GHAssertEqualStrings(path, @"me/og.likes", @"Should be og likes endpoint");
    }];
    
    [self succeedLikeCreateWithVerify:nil];
    [self stubShouldShareLocation];
    [self succeedGetLocation];
    
    [self prepare];
    [SZLikeUtils likeWithEntity:entity options:options networks:SZSocialNetworkFacebook success:^(id<SocializeLike> like) {
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.1];
    
    GHAssertTrue(willPostCalled, @"willPost event not called");
    GHAssertTrue(didPostCalled, @"didPost event not called");
    GHAssertFalse(didFailCalled, @"didFail should not have been called");
}

- (void)testFailingFacebookLike {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
    
    [self stubOGLikeDisabled];
    [self stubIsAuthenticated];
    [self stubFacebookUsable];
    
    SZLikeOptions *options = [SZLikeOptions defaultOptions];
    
    __block BOOL willPostCalled = NO;
    options.willAttemptPostToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
        willPostCalled = YES;
    };
    
    __block BOOL didPostCalled = NO;
    options.didPostToSocialNetworkBlock = ^(SZSocialNetwork network) {
        didPostCalled = YES;
    };
    
    __block BOOL didFailCalled = NO;
    options.didFailToPostToSocialNetworkBlock = ^(SZSocialNetwork network) {
        didFailCalled = YES;
    };
    
    [self failFacebookPost];
    
    [self succeedLikeCreateWithVerify:nil];
    [self stubShouldShareLocation];
    [self succeedGetLocation];
    
    [self prepare];
    [SZLikeUtils likeWithEntity:entity options:options networks:SZSocialNetworkFacebook success:^(id<SocializeLike> like) {
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.1];
    
    GHAssertTrue(willPostCalled, @"willPost");
    GHAssertFalse(didPostCalled, @"didPost");
    GHAssertTrue(didFailCalled, @"didFail");
}

- (void)testSucceedingFacebookLike {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
    
    [self stubOGLikeDisabled];
    [self stubIsAuthenticated];
    [self stubFacebookUsable];
    
    SZLikeOptions *options = [SZLikeOptions defaultOptions];
    
    __block BOOL willPostCalled = NO;
    options.willAttemptPostToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
        GHAssertEquals(network, SZSocialNetworkFacebook, @"Should be facebook");
        GHAssertEqualStrings(postData.path, @"me/links", @"Should be links endpoint");
        willPostCalled = YES;
    };
    
    __block BOOL didPostCalled = NO;
    options.didPostToSocialNetworkBlock = ^(SZSocialNetwork network) {
        GHAssertEquals(network, SZSocialNetworkFacebook, @"Should be facebook");
        didPostCalled = YES;
    };
    
    __block BOOL didFailCalled = NO;
    options.didFailToPostToSocialNetworkBlock = ^(SZSocialNetwork network) {
        didFailCalled = YES;
    };
    
    [self succeedFacebookPostWithVerify:^void(NSString *path, NSDictionary *params) {
        GHAssertEqualStrings(path, @"me/links", @"Should be links endpoint");
    }];
    
    [self succeedLikeCreateWithVerify:nil];
    [self stubShouldShareLocation];
    [self succeedGetLocation];
    
    [self prepare];
    [SZLikeUtils likeWithEntity:entity options:options networks:SZSocialNetworkFacebook success:^(id<SocializeLike> like) {
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.1];
    
    GHAssertTrue(willPostCalled, @"willPost event not called");
    GHAssertTrue(didPostCalled, @"didPost event not called");
    GHAssertFalse(didFailCalled, @"didFail should not have been called");
}

@end
