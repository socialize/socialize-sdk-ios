//
//  TestSmartAlertUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestSmartAlertUtils.h"
#import <Socialize/Socialize.h>
#import <OCMock/NSObject+ClassMock.h>
#import <OCMock/OCMock.h>


@implementation TestSmartAlertUtils

- (void)testValidNotificationIsSocializeNotification {
    NSDictionary *socializeInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"304899", @"activity_id",
                                   @"comment", @"activity_type",
                                   @"new_comments", @"notification_type",
                                   nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:socializeInfo forKey:@"socialize"];
    
    BOOL isValid = [SZSmartAlertUtils isSocializeNotification:userInfo];
    GHAssertTrue(isValid, @"should be valid");
}

- (void)testInvalidNotificationIsNotSocializeNotification {
    NSDictionary *aps = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"message", @"alert",
                         nil];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:aps forKey:@"aps"];
    
    BOOL isValid = [SZSmartAlertUtils isSocializeNotification:userInfo];
    GHAssertFalse(isValid, @"should be valid");
}

//- (void)testRegisterNotificationCallsSender {
//    [SocializeDeviceTokenSender startMockingClass];
//    
//    // Stub mock sender singleton
//    id mockSender = [OCMockObject mockForClass:[SocializeDeviceTokenSender class]];
//    [[[SocializeDeviceTokenSender stub] andReturn:mockSender] sharedDeviceTokenSender];
//    
//    char testTokenData[32] = "\xaa\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff";
//    NSData *testToken = [NSData dataWithBytes:&testTokenData length:sizeof(testTokenData)];
//    
//    // Should register
//    [[mockSender expect] registerDeviceToken:testToken];
//    
//    [SZSmartAlertUtils registerDeviceToken:testToken];
//    [SocializeDeviceTokenSender stopMockingClassAndVerify];
//}

@end
