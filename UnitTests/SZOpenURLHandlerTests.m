//
//  SZOpenURLHandlerTests.m
//  Socialize
//
//  Created by Nathaniel Griswold on 9/17/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZOpenURLHandlerTests.h"
#import "SZEntityUtils.h"

@implementation SZOpenURLHandlerTests

- (void)setUp {
    [super setUp];
    
    [SZEntityUtils startMockingClass];
    
    self.openURLHandler = [[SZOpenURLHandler alloc] init];
    self.mockDisplay = [OCMockObject mockForProtocol:@protocol(SZDisplay)];
    self.openURLHandler.display = self.mockDisplay;
    
    [[[SZEntityUtils stub] andForwardToObject:[SZEntityUtils origClass]] fetchEntityAndShowEntityLoaderForEntityWithKey:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)tearDown {
    self.openURLHandler = nil;
    
    [SZEntityUtils stopMockingClassAndVerify];

    [self.mockDisplay verify];
    self.mockDisplay = nil;
    
    [super tearDown];
}

- (void)testOpenSmartDownloadsURL {
    
    [[self.mockDisplay expect] socializeDidStartLoadingForContext:SZLoadingContextFetchingEntityForSmartDownloadsURLOpen];
    [[self.mockDisplay expect] socializeDidStopLoadingForContext:SZLoadingContextFetchingEntityForSmartDownloadsURLOpen];

    [[[SZEntityUtils stub] andReturnBool:YES] canLoadEntity:OCMOCK_ANY];
    
    [[SZEntityUtils origClass] setEntityLoaderBlock:^(UINavigationController *navigationController, id<SocializeEntity> entity) {
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    
    id mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    [self succeedGetEntityWithResultBlock:^id<SocializeEntity>(NSString *key) {
        GHAssertEqualStrings(key, @"http://abc", @"Bad key");
        return mockEntity;
    }];
    
    [self prepare];
    [self.openURLHandler handleOpenURL:[NSURL URLWithString:@"sz123456://smart_url?entity_key=http://abc"]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
}

- (void)testOpenSmartDownloadsURLLoadFailure {
    
    [[self.mockDisplay expect] socializeDidStartLoadingForContext:SZLoadingContextFetchingEntityForSmartDownloadsURLOpen];
    [[self.mockDisplay expect] socializeDidStopLoadingForContext:SZLoadingContextFetchingEntityForSmartDownloadsURLOpen];
    
    [[[SZEntityUtils stub] andReturnBool:YES] canLoadEntity:OCMOCK_ANY];

    [[SZEntityUtils origClass] setEntityLoaderBlock:^(UINavigationController *navigationController, id<SocializeEntity> entity) {
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    
    id mockError = [OCMockObject mockForClass:[NSError class]];
    [self failGetEntityWithError:mockError];
    
    [[[self.mockDisplay expect] andDo1:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }] socializeRequiresIndicationOfFailureForError:OCMOCK_ANY];
    
    [self prepare];
    [self.openURLHandler handleOpenURL:[NSURL URLWithString:@"sz123456://smart_url?entity_key=http://abc"]];
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:10];
}

@end
