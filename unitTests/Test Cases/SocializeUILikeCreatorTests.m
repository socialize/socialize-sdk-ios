//
//  SocializeUILikeCreatorTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/16/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeUILikeCreatorTests.h"
#import "SocializeThirdParty.h"
#import "SocializeThirdPartyLinker.h"
#import "SocializeLikeCreator.h"

@implementation SocializeUILikeCreatorTests
@synthesize likeCreator = likeCreator_;
@synthesize mockLike = mockLike_;

- (id)createAction {
    __block id weakSelf = self;
    self.likeCreator = [[[SocializeUILikeCreator alloc] initWithOptions:nil display:self.mockDisplay] autorelease];
    
    self.mockLike = [OCMockObject mockForProtocol:@protocol(SocializeLike)];
    self.likeCreator.like = self.mockLike;
    
    self.likeCreator.likeSuccessBlock = ^(id<SocializeLike> like) {
        [weakSelf notify:kGHUnitWaitStatusSuccess];
    };
    self.likeCreator.failureBlock = ^(NSError *error) {
        [weakSelf notify:kGHUnitWaitStatusFailure];
    };
    
    return self.likeCreator;
}

- (BOOL)shouldRunOnMainThread {
    return YES;
}

- (NSInteger)authType {
    return SocializeThirdPartyAuthTypeFacebook;
}

- (void)setUp {
    [super setUp];
    
    [SocializeThirdParty startMockingClass];
    [SocializeThirdPartyLinker startMockingClass];
    [SocializeLikeCreator startMockingClass];
    
}

- (void)tearDown {
    self.likeCreator = nil;
    
    [SocializeThirdParty stopMockingClassAndVerify];
    [SocializeThirdPartyLinker stopMockingClassAndVerify];
    [SocializeLikeCreator stopMockingClassAndVerify];

    [super tearDown];
}

- (void)succeedLink {
    [[[SocializeThirdPartyLinker expect] andDo4:^(id _, id __, id success, id ___) {
        void (^successBlock)() = success;
        successBlock();
    }] linkToThirdPartyWithOptions:OCMOCK_ANY displayProxy:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)succeedLike {
    [[[SocializeLikeCreator expect] andDo5:^(id _, id __, id ___, id success, id ____) {
        void (^successBlock)(id<SocializeLike> like) = success;
        id mockLike = [OCMockObject mockForProtocol:@protocol(SocializeLike)];
        successBlock(mockLike);
    }] createLike:OCMOCK_ANY options:OCMOCK_ANY displayProxy:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)testSuccessfulLike {
    [[[SocializeThirdParty stub] andReturnBool:YES] thirdPartyAvailable];
    [[[SocializeThirdParty stub] andReturnBool:NO] thirdPartyLinked];
    
    [self succeedLink];
    [self succeedLike];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

@end
