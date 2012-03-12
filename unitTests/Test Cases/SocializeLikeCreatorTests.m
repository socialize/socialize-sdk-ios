//
//  SocializeLikeCreatorTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/11/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeLikeCreatorTests.h"
#import "_Socialize.h"

@implementation SocializeLikeCreatorTests

@synthesize likeCreator = likeCreator_;
@synthesize mockOptions = mockOptions_;
@synthesize mockLike = mockLike_;

- (id)createAction {
    __block id weakSelf = self;
    
    self.mockOptions = [OCMockObject niceMockForClass:[SocializeLikeOptions class]];
    self.mockLike = [OCMockObject niceMockForProtocol:@protocol(SocializeLike)];
    self.likeCreator = [[[SocializeLikeCreator alloc]
                          initWithActivity:self.mockLike
                          options:self.mockOptions
                          displayProxy:nil
                          display:self.mockDisplay] autorelease];
    
    self.likeCreator.activitySuccessBlock = ^(id<SocializeLike> serverLike) {
        [weakSelf notify:kGHUnitWaitStatusSuccess];
    };
    self.likeCreator.failureBlock = ^(NSError *error) {
        [weakSelf notify:kGHUnitWaitStatusFailure];
        self.lastError = error;
    };
    
    return self.likeCreator;
}

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [self.mockLike verify];
    [self.mockOptions verify];
    
    self.mockLike = nil;
    self.mockOptions = nil;
    self.likeCreator = nil;
    
    [super tearDown];
}

- (void)succeedLikeCreate {
    [[[self.mockSocialize expect] andDo1:^(id<SocializeLike> like) {
        [self.likeCreator service:nil didCreate:self.mockLike];
    }] createLike:OCMOCK_ANY];
}

- (void)failLikeCreate {
    [[[self.mockSocialize expect] andDo1:^(id<SocializeLike> like) {
        id mockError = [OCMockObject niceMockForClass:[NSError class]];
        [self.likeCreator service:nil didFail:mockError];
    }] createLike:OCMOCK_ANY];
}

- (void)testSuccessfulLikeOnTwitter {
    [self selectJustTwitterInOptions];
    
    [self succeedLikeCreate];
    [self expectSetTwitterInActivity:self.mockLike];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

- (void)testFailedLikeOnTwitter {
    [self selectJustTwitterInOptions];
    
    [self failLikeCreate];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testSuccessfulLikeOnFacebook {
    [self selectJustFacebookInOptions];
    
    [self succeedLikeCreate];
    [self succeedFacebookWallPost];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
    
}

- (void)testClassHelper {
    [SocializeLikeCreator startMockingClass];
    [self.mockLike makeNice];
    [[[SocializeLikeCreator expect] andReturn:nil] alloc];
    [[SocializeLikeCreator stub] initialize];
    [[SocializeLikeCreator origClass] createLike:self.mockLike options:nil displayProxy:nil success:nil failure:nil];
    
    [SocializeLikeCreator stopMockingClassAndVerify];
}


@end
