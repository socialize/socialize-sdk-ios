//
//  SocializePinterestTests.m
//  Socialize
//
//  Created by David Jedeikin on 4/16/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import "SocializePinterestTests.h"
#import "SZShareUtils.h"
#import "SZPinterestUtils.h"
#import "SZPinterestEngine.h"

@implementation SocializePinterestTests

- (void)setUp {
    [super setUp];
    [self startMockingSharedSocialize];
    [SZUserUtils startMockingClass];

    //mock out Pinterest classes
    [SZPinterestUtils startMockingClass];
    id mockSharedPinterestEngine = [OCMockObject mockForClass:[SZPinterestEngine class]];
    [SZPinterestEngine startMockingClass];
    [[[SZPinterestEngine stub] andReturn:mockSharedPinterestEngine] sharedInstance];
}

- (void)tearDown {
    [super tearDown];
    [self stopMockingSharedSocialize];
    [SZUserUtils stopMockingClassAndVerify];
    [SZPinterestUtils stopMockingClassAndVerify];
    [SZPinterestEngine stopMockingClassAndVerify];
}

- (void)testShareViaPinterestWithViewController {
    [self succeedShareCreate];

    [[[SZPinterestUtils expect] andDo5:^(id _1, id _2, id _3, id success, id failure) {
        void (^successBlock)(id<SZShare> result) = success;
        successBlock(nil);
    }] shareViaPinterestWithViewController:OCMOCK_ANY options:OCMOCK_ANY entity:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];

    //test call per expect
    [self prepare];
    [SZPinterestUtils shareViaPinterestWithViewController:nil
                                                  options:nil
                                                   entity:entity
                                                  success:^(id<SocializeShare> share) {
                                                      [self notify:kGHUnitWaitStatusSuccess];
                                                  }
                                                  failure:^(NSError *error) {
                                                      [self notify:kGHUnitWaitStatusFailure];
                                                  }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.5];
}

@end
