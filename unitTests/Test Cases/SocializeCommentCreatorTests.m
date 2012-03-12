//
//  SocializeCommentCreatorTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeCommentCreatorTests.h"
#import "_Socialize.h"

@implementation SocializeCommentCreatorTests
@synthesize commentCreator = commentCreator_;
@synthesize mockOptions = mockOptions_;
@synthesize mockComment = mockComment_;

- (id)createAction {
    __block id weakSelf = self;
    
    self.mockOptions = [OCMockObject niceMockForClass:[SocializeCommentOptions class]];
    self.mockComment = [OCMockObject niceMockForProtocol:@protocol(SocializeComment)];
    self.commentCreator = [[[SocializeCommentCreator alloc]
                            initWithActivity:self.mockComment
                             options:self.mockOptions
                             displayProxy:nil
                             display:self.mockDisplay] autorelease];
    
    self.commentCreator.activitySuccessBlock = ^(id<SocializeComment> serverComment) {
        [weakSelf notify:kGHUnitWaitStatusSuccess];
    };
    self.commentCreator.failureBlock = ^(NSError *error) {
        [weakSelf notify:kGHUnitWaitStatusFailure];
        self.lastError = error;
    };
    
    return self.commentCreator;
}

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [self.mockComment verify];
    [self.mockOptions verify];
    
    self.mockComment = nil;
    self.mockOptions = nil;
    self.commentCreator = nil;
    
    [super tearDown];
}

- (void)succeedCommentCreate {
    [[[self.mockSocialize expect] andDo1:^(id<SocializeComment> comment) {
        [self.commentCreator service:nil didCreate:self.mockComment];
    }] createComment:OCMOCK_ANY];
}

- (void)failCommentCreate {
    [[[self.mockSocialize expect] andDo1:^(id<SocializeComment> comment) {
        id mockError = [OCMockObject niceMockForClass:[NSError class]];
        [self.commentCreator service:nil didFail:mockError];
    }] createComment:OCMOCK_ANY];
}

- (void)testSuccessfulCommentOnTwitter {
    [self selectJustTwitterInOptions];
    
    [self succeedCommentCreate];
    [self expectSetTwitterInActivity:self.mockComment];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

- (void)testFailedCommentOnTwitter {
    [self selectJustTwitterInOptions];
    
    [self failCommentCreate];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testSuccessfulCommentOnFacebook {
    [self selectJustFacebookInOptions];
    
    [self succeedCommentCreate];
    [self succeedFacebookWallPost];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
    
}

- (void)testClassHelper {
    [SocializeCommentCreator startMockingClass];
    [self.mockComment makeNice];
    [[[SocializeCommentCreator expect] andReturn:nil] alloc];
    [[SocializeCommentCreator stub] initialize];
    [[SocializeCommentCreator origClass] createComment:self.mockComment options:nil display:nil success:nil failure:nil];
    
    [SocializeCommentCreator stopMockingClassAndVerify];
}

@end
