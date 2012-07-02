//
//  BaseShareViewControllerTests.m
//  Socialize
//
//  Created by Nathaniel Griswold on 7/2/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "BaseShareViewControllerTests.h"
#import "SZFacebookUtils.h"
#import "SZTwitterUtils.h"
#import "SZLocationUtils.h"

@implementation BaseShareViewControllerTests
@synthesize mockEntity = _mockEntity;
@synthesize baseShare = _baseShare;
@synthesize mockSocialize = _mockSocialize;

- (id)createUUT {
    self.mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    self.baseShare = [[[SZBaseShareViewController alloc] initWithEntity:self.mockEntity] autorelease];
    return self.baseShare;
}

- (void)setUp {
    [super setUp];
    
    self.mockSocialize = [OCMockObject niceMockForClass:[Socialize class]];
    self.baseShare.socialize = self.mockSocialize;
}

- (void)tearDown {
    [self.mockEntity verify];
    [self.mockSocialize verify];
    
    self.mockSocialize = nil;
    self.mockEntity = nil;
    self.baseShare = nil;
    
    [super tearDown];
}

- (void)testLoadingWithOneNetwork {
    [SZLocationUtils startMockingClass];
    [[SZLocationUtils classMock] makeNice];
    
    [SZFacebookUtils startMockingClass];
    [[[SZFacebookUtils stub] andReturnBool:NO] isAvailable];
    [[[SZFacebookUtils stub] andReturnBool:NO] isLinked];
    [SZTwitterUtils startMockingClass];
    [[[SZTwitterUtils stub] andReturnBool:YES] isAvailable];
    [[[SZTwitterUtils stub] andReturnBool:YES] isLinked];
    [self.baseShare viewDidLoad];
    [self.baseShare viewWillAppear:YES];
    [self.baseShare viewDidAppear:YES];
    
    [SZFacebookUtils stopMockingClassAndVerify];
    [SZTwitterUtils stopMockingClassAndVerify];
    [SZLocationUtils stopMockingClassAndVerify];
}

@end
