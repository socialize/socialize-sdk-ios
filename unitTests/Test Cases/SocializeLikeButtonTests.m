//
//  SocializeLikeButtonTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/18/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeLikeButtonTests.h"
#import "SocializeServiceDelegate.h"
#import "SocializeUserService.h"
#import "SocializeLikeService.h"
#import "SocializeEntityService.h"

static NSInteger authenticatedUserID = 12345;
static NSString *entityKey = @"entityKey";

@implementation SocializeLikeButtonTests
@synthesize likeButton = likeButton_;
@synthesize mockActualButton = mockActualButton_;
@synthesize mockEntity = mockEntity_;
@synthesize mockSocialize = mockSocialize_;
@synthesize mockAuthenticatedUser = mockAuthenticatedUser_;
@synthesize realButton = realButton_;

- (id)createUUT {
    CGRect testFrame = CGRectMake(0, 0, 60, 30);
    self.mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    self.likeButton = [[[SocializeLikeButton alloc] initWithFrame:testFrame entity:self.mockEntity] autorelease];
    
    return self.likeButton;
}

- (void)setUp {
    [super setUp];
    
    self.mockActualButton = [OCMockObject mockForClass:[UIButton class]];
    self.realButton = self.likeButton.actualButton;
    self.likeButton.actualButton = self.mockActualButton;
    
    self.mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    self.likeButton.socialize = self.mockSocialize;
    
    self.mockAuthenticatedUser = [OCMockObject mockForProtocol:@protocol(SocializeFullUser)];
    [[[self.mockAuthenticatedUser stub] andReturnInteger:authenticatedUserID] objectID];
    
    [[[self.mockSocialize stub] andReturn:self.mockAuthenticatedUser] authenticatedUser];

    [[[self.mockEntity stub] andReturn:entityKey] key];

    [NSTimer startMockingClass];
}

- (void)tearDown {
    [self.mockActualButton verify];
    [self.mockEntity verify];
    [self.mockSocialize verify];
    
    self.mockActualButton = nil;
    self.mockEntity = nil;
    self.mockSocialize = nil;
    
    [NSTimer stopMockingClassAndVerify];

    [super tearDown];
}

- (void)succeedGetLikeWithLike:(id<SocializeLike>)like {
    [[[self.mockSocialize expect] andDo0:^{
        NSArray *elements = like != nil ? [NSArray arrayWithObject:like] : [NSArray array];
        
        id mockService = [self createMockServiceForClass:[SocializeUserService class]];
        [self.likeButton service:mockService didFetchElements:elements];
    }] getLikesForUser:self.mockAuthenticatedUser entity:OCMOCK_ANY first:OCMOCK_ANY last:OCMOCK_ANY];
}

- (void)succeedCreateEntityWithEntity:(id<SocializeEntity>)entity {
    [[[self.mockSocialize expect] andDo0:^{
        id mockService = [self createMockServiceForClass:[SocializeEntityService class]];
        [self.likeButton service:mockService didCreate:entity];
    }] createEntity:OCMOCK_ANY];
}

- (void)succeedCreateLikeWithLike:(id<SocializeLike>)like {
    [[[self.mockSocialize expect] andDo0:^{
        id mockService = [self createMockServiceForClass:[SocializeLikeService class]];
        [self.likeButton service:mockService didCreate:like];
    }] likeEntityWithKey:OCMOCK_ANY longitude:OCMOCK_ANY latitude:OCMOCK_ANY];
}

- (void)succeedDeleteLikeWithLike:(id<SocializeLike>)like {
    [[[self.mockSocialize expect] andDo0:^{
        id mockService = [self createMockServiceForClass:[SocializeLikeService class]];
        [self.likeButton service:mockService didDelete:like];
    }] unlikeEntity:OCMOCK_ANY];
}

- (void)succeedInitializationWithExistingLike {
    [self.mockActualButton makeNice];

    id mockLike = [OCMockObject mockForProtocol:@protocol(SocializeLike)];
    [[[mockLike stub] andReturn:self.mockEntity] entity];
    [self succeedGetLikeWithLike:mockLike];
    
    
    [self.likeButton willMoveToSuperview:nil];
}

- (void)succeedInitializationWithoutExistingLike {
    [self.mockActualButton makeNice];

    [self succeedGetLikeWithLike:nil];
    [self succeedCreateEntityWithEntity:self.mockEntity];
    
    [self.likeButton willMoveToSuperview:nil];
}

- (void)succeedDeletingLike {
    id mockLike = [OCMockObject mockForProtocol:@protocol(SocializeLike)];
    [self succeedDeleteLikeWithLike:mockLike];
}

- (void)succeedCreatingLike {
    id mockLike = [OCMockObject mockForProtocol:@protocol(SocializeLike)];
    [[[mockLike stub] andReturn:self.mockEntity] entity];
    [self succeedCreateLikeWithLike:mockLike];
}


- (void)testSuccessfulInitializationWithExistingLike {
    // Should start disabled and enable after successful init
    [[self.mockActualButton expect] setEnabled:NO];
    [[self.mockActualButton expect] setEnabled:YES];
    
    [self succeedInitializationWithExistingLike];
}

- (void)testSuccessfulInitializationWithoutExistingLike {
    // Should start disabled and enable after successful init
    [[self.mockActualButton expect] setEnabled:NO];
    [[self.mockActualButton expect] setEnabled:YES];
    
    [self succeedInitializationWithoutExistingLike];
}

- (void)testLikeAndUnlikeFromInitialState {
    [self.mockSocialize setExpectationOrderMatters:YES];

    [self succeedInitializationWithoutExistingLike];
    [self succeedCreatingLike];
    [self succeedDeletingLike];
    
    
    [self.realButton simulateControlEvent:UIControlEventTouchUpInside];
    [self.realButton simulateControlEvent:UIControlEventTouchUpInside];
}

- (void)testUnlikeAndLikeFromInitialState {
    [self.mockSocialize setExpectationOrderMatters:YES];

    [self succeedInitializationWithExistingLike];
    [self succeedDeletingLike];
    [self succeedCreatingLike];
    
    [self.realButton simulateControlEvent:UIControlEventTouchUpInside];
    [self.realButton simulateControlEvent:UIControlEventTouchUpInside];
}

@end
