//
//  SocializeWhatsAppTests.m
//  Socialize
//
//  Created by David Jedeikin on 4/16/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import "SocializeWhatsAppTests.h"
#import "SZWhatsAppUtils.h"

@implementation SocializeWhatsAppTests

- (void)setUp {
    [super setUp];
    [self startMockingSharedSocialize];
    [SZUserUtils startMockingClass];
    
    //mock out Pinterest classes
    [SZWhatsAppUtils startMockingClass];
}

- (void)tearDown {
    [super tearDown];
    [self stopMockingSharedSocialize];
    [SZUserUtils stopMockingClassAndVerify];
    [SZWhatsAppUtils stopMockingClassAndVerify];
}

- (void)testShareViaWhatsAppWithViewController {
    [[[SZWhatsAppUtils stub] andReturn:@YES] isAvailable];
    [[[SZWhatsAppUtils expect] andDo5:^(id _1, id _2, id _3, id success, id failure) {
        void (^successBlock)(id<SZShare> result) = success;
        successBlock(nil);
    }] shareViaWhatsAppWithViewController:OCMOCK_ANY options:OCMOCK_ANY entity:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];

    
    //test call per expect
    [self prepare];
    [SZWhatsAppUtils shareViaWhatsAppWithViewController:nil
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
