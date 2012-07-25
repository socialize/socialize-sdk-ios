//
//  SZShareUtilsTests.m
//  Socialize
//
//  Created by Nathaniel Griswold on 7/16/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZShareUtilsTests.h"
#import "SZShareUtils.h"
#import "SZTwitterUtils.h"
#import "SZFacebookUtils.h"
#import "SZUserUtils.h"
#import "Socialize.h"
#import "SZLocationUtils.h"

@implementation SZShareUtilsTests
@synthesize mockSharedSocialize = _mockSharedSocialize;

- (void)setUp {
    [super setUp];
    
    [self startMockingSharedSocialize];
    [SZTwitterUtils startMockingClass];
    [SZFacebookUtils startMockingClass];
    [SZUserUtils startMockingClass];
    [SZLocationUtils startMockingClass];
    
    [[[SZTwitterUtils stub] andReturn:@"test"] defaultTwitterTextForActivity:OCMOCK_ANY];
}

- (void)tearDown {
    [super tearDown];
    
    [Socialize stopMockingClassAndVerify];
    [SZFacebookUtils stopMockingClassAndVerify];
    [SZTwitterUtils stopMockingClassAndVerify];
    [SZUserUtils stopMockingClassAndVerify];
    [SZLocationUtils stopMockingClassAndVerify];
}

- (void)succeedFacebookPost {
    [[[SZFacebookUtils expect] andDo4:^(id _1, id _2, id success, id failure) {
        void (^successBlock)(id result) = success;
        successBlock(nil);
    }] postWithGraphPath:OCMOCK_ANY params:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)succeedTwitterPost {
    [[[SZTwitterUtils expect] andDo4:^(id _1, id _2, id success, id failure) {
        void (^successBlock)(id result) = success;
        successBlock(nil);
    }] postWithPath:OCMOCK_ANY params:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)stubFacebookUsable {
    [[[SZFacebookUtils stub] andReturnBool:YES] isAvailable];
    [[[SZFacebookUtils stub] andReturnBool:YES] isLinked];
}

- (void)stubTwitterUsable {
    [[[SZTwitterUtils stub] andReturnBool:YES] isAvailable];
    [[[SZTwitterUtils stub] andReturnBool:YES] isLinked];
}

- (void)stubIsAuthenticated {
    [[[SZUserUtils stub] andReturnBool:YES] userIsAuthenticated];
}

- (void)succeedShareCreate {
    [[[self.mockSharedSocialize stub] andDo3:^(id _1, id success, id _3) {
        void (^successBlock)(id result) = success;
        successBlock(nil);
    }] createShare:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)failShareCreate {
    [[[self.mockSharedSocialize stub] andDo3:^(id _1, id _2, id failure) {
        void (^failureBlock)(id result) = failure;
        failureBlock(nil);
    }] createShare:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)stubShouldShareLocation {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kSocializeShouldShareLocationKey];
}

- (id)succeedGetLocation {
    id mockLocation = [OCMockObject niceMockForClass:[CLLocation class]];
    [[[SZLocationUtils expect] andDo2:^(id success, id _2) {
        void (^successBlock)(id result) = success;
        successBlock(mockLocation);
    }] getCurrentLocationWithSuccess:OCMOCK_ANY failure:OCMOCK_ANY];
    
    return mockLocation;
}

- (void)testCombinedShareSuccess {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
//    SZShareOptions *options = [SZShareUtils userShareOptions];
////    options.dontShareLocation = YES;
//    options.text = @"mytext";
    
    [self stubIsAuthenticated];
    [self stubFacebookUsable];
    [self stubTwitterUsable];
    [self succeedFacebookPost];
    [self succeedTwitterPost];
    [self succeedShareCreate];
    [self stubShouldShareLocation];
    [self succeedGetLocation];
    
    [self prepare];
    [SZShareUtils shareViaSocialNetworksWithEntity:entity networks:SZSocialNetworkFacebook | SZSocialNetworkTwitter options:nil success:^(id<SZShare> share) {
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
        
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.1];
}

- (void)testCombinedShareFailure {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
    
    [self stubIsAuthenticated];
    [self stubFacebookUsable];
    [self stubTwitterUsable];
    [self stubShouldShareLocation];
    [self succeedGetLocation];
    [self failShareCreate];

    [self prepare];
    [SZShareUtils shareViaSocialNetworksWithEntity:entity networks:SZSocialNetworkFacebook | SZSocialNetworkTwitter options:nil success:^(id<SZShare> share) {
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
        
    }];
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:0.1];
}

@end
