//
//  SZActionBarTests.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/27/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZActionBarTests.h"
#import "SZEntityUtils.h"

@implementation SZActionBarTests
@synthesize actionBar = _actionBar;

- (id)createUUT {
//    self.actionBar = [[[SZActionBar alloc] initWithFrame:CGRectNull] autorelease];
    return self.actionBar;
}

- (void)testInitWithNoEntityDoesNotCreateEntity {
    [SZEntityUtils startMockingClass];
    self.actionBar = [[[SZActionBar alloc] initWithFrame:CGRectMake(0, 0, 1, 1) entity:nil viewController:nil] autorelease];
    [[SZEntityUtils reject] addEntity:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
    [self.actionBar willMoveToSuperview:nil];
    [SZEntityUtils stopMockingClassAndVerify];
}

- (id<SZEntity>)mockEntityWithKey:(NSString*)key fromServer:(BOOL)fromServer {
    id mockEntity = [OCMockObject mockForProtocol:@protocol(SZEntity)];
    [[[mockEntity stub] andReturn:key] key];
    [[[mockEntity stub] andReturn:@"name"] name];
    [[[mockEntity stub] andReturnBool:fromServer] isFromServer];    
    return mockEntity;
}

- (void)testInitWithClientEntityCreatesEntity {
    [SZEntityUtils startMockingClass];
    
    id mockEntity = [self mockEntityWithKey:@"key" fromServer:NO];
    self.actionBar = [[[SZActionBar alloc] initWithFrame:CGRectMake(0, 0, 1, 1) entity:mockEntity viewController:nil] autorelease];
    [[SZEntityUtils expect] addEntity:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
    [self.actionBar willMoveToSuperview:nil];
    [SZEntityUtils stopMockingClassAndVerify];
}

- (void)testInitWithServerEntityDoesNotCreateEntity {
    [SZEntityUtils startMockingClass];
    id mockEntity = [self mockEntityWithKey:@"key" fromServer:YES];
    
    self.actionBar = [[[SZActionBar alloc] initWithFrame:CGRectMake(0, 0, 1, 1) entity:mockEntity viewController:nil] autorelease];
    [[SZEntityUtils reject] addEntity:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
    [self.actionBar willMoveToSuperview:nil];
    [SZEntityUtils stopMockingClassAndVerify];
}

- (void)testChangingEntityCreatesSecondEntity {
    [SZEntityUtils startMockingClass];
    id mockEntity = [self mockEntityWithKey:@"key" fromServer:NO];
    
    self.actionBar = [[[SZActionBar alloc] initWithFrame:CGRectMake(0, 0, 1, 1) entity:mockEntity viewController:nil] autorelease];
    [[SZEntityUtils expect] addEntity:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
    [self.actionBar willMoveToSuperview:nil];
    
    id mockEntity2 = [self mockEntityWithKey:@"second_key" fromServer:NO];
    [[SZEntityUtils expect] addEntity:mockEntity2 success:OCMOCK_ANY failure:OCMOCK_ANY];
    self.actionBar.entity = mockEntity2;
    
    [SZEntityUtils stopMockingClassAndVerify];
}

@end
