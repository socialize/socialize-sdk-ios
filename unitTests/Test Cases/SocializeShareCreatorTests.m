//
//  SocializeShareCreatorTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/11/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeShareCreatorTests.h"
#import "_Socialize.h"

@implementation SocializeShareCreatorTests

@synthesize shareCreator = shareCreator_;
@synthesize mockOptions = mockOptions_;
@synthesize mockShare = mockShare_;

- (id)createAction {
    __block id weakSelf = self;
    
    self.mockOptions = [OCMockObject niceMockForClass:[SocializeShareOptions class]];
    self.mockShare = [OCMockObject niceMockForProtocol:@protocol(SocializeShare)];
    self.shareCreator = [[[SocializeShareCreator alloc]
                            initWithActivity:self.mockShare
                            options:self.mockOptions
                            displayProxy:nil
                            display:self.mockDisplay] autorelease];
    
    self.shareCreator.activitySuccessBlock = ^(id<SocializeShare> serverShare) {
        [weakSelf notify:kGHUnitWaitStatusSuccess];
    };
    self.shareCreator.failureBlock = ^(NSError *error) {
        [weakSelf notify:kGHUnitWaitStatusFailure];
        self.lastError = error;
    };
    
    return self.shareCreator;
}

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [self.mockShare verify];
    [self.mockOptions verify];
    
    self.mockShare = nil;
    self.mockOptions = nil;
    self.shareCreator = nil;
    
    [super tearDown];
}

- (void)succeedShareCreate {
    [[[self.mockSocialize expect] andDo1:^(id<SocializeShare> share) {
        [self.shareCreator service:nil didCreate:self.mockShare];
    }] createShare:OCMOCK_ANY];
}

- (void)failShareCreate {
    [[[self.mockSocialize expect] andDo1:^(id<SocializeShare> share) {
        id mockError = [OCMockObject niceMockForClass:[NSError class]];
        [self.shareCreator service:nil didFail:mockError];
    }] createShare:OCMOCK_ANY];
}

- (void)testSuccessfulShareOnTwitter {
    [self selectJustTwitterInOptions];
    
    [self succeedShareCreate];
    [self expectSetTwitterInActivity:self.mockShare];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

- (void)testFailedShareOnTwitter {
    [self selectJustTwitterInOptions];
    
    [self failShareCreate];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testSuccessfulShareOnFacebook {
    [self selectJustFacebookInOptions];
    
    [self succeedShareCreate];
    [self succeedFacebookWallPost];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
    
}

- (void)testClassHelper {
    [SocializeShareCreator startMockingClass];
    [self.mockShare makeNice];
    [[[SocializeShareCreator expect] andReturn:nil] alloc];
    [[SocializeShareCreator stub] initialize];
    [[SocializeShareCreator origClass] createShare:self.mockShare options:nil display:nil success:nil failure:nil];
    
    [SocializeShareCreator stopMockingClassAndVerify];
}

@end
