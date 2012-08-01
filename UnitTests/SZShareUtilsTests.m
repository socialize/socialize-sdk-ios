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

- (void)testCombinedShareSuccess {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
//    SZShareOptions *options = [SZShareUtils userShareOptions];
////    options.dontShareLocation = YES;
//    options.text = @"mytext";
    
    [self stubIsAuthenticated];
    [self stubFacebookUsable];
    [self stubTwitterUsable];
    [self succeedFacebookPostWithVerify:nil];
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
