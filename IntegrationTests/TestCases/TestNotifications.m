//
//  TestNotifications.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/2/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestNotifications.h"
#import "SocializePrivateDefinitions.h"
#import "IntegrationTestsAppDelegate.h"

@implementation TestNotifications

- (void)setUpClass {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:@"RemoteNotificationReceived" object:nil];
}

- (void)tearDownClass {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)notificationReceived:(NSNotification*)notification {
    NSLog(@"Got notification");
    [self notify:kGHUnitWaitStatusSuccess];
}

- (void)waitForNotification:(NSString*)notification timeout:(NSTimeInterval)timeout {
    [self prepare];
    [[NSNotificationCenter defaultCenter] addObserverForName:notification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self notify:kGHUnitWaitStatusSuccess];
                                                  }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:timeout];
}

#if !TARGET_IPHONE_SIMULATOR
- (void)testReceivePushNotification {

    [Socialize registerDeviceToken:[IntegrationTestsAppDelegate origToken]];
    [self waitForNotification:SocializeDidRegisterDeviceTokenNotification timeout:2];
    
    // Create entity and subscribe.
    NSString *key = [self testURL:[NSString stringWithFormat:@"%s/comment", _cmd]];
    id<SocializeEntity> entity = [SocializeEntity entityWithKey:key name:@""];
    entity.key = @"samekey";
    [self createEntity:entity];

     
    [self getSubscriptionsForEntityKey:entity.key];
    NSArray *subscriptions = self.fetchedElements;
    (void)subscriptions;

    SocializeComment *comment1 = [SocializeComment commentWithEntity:entity text:@"hi"];
    comment1.subscribe = YES;
    [self createComment:comment1];

    // Switch to new anon user
    [Socialize registerDeviceToken:nil];
    [self authenticateAnonymously];

    SocializeComment *comment2 = [SocializeComment commentWithEntity:entity text:@"hi"];
    [self createComment:comment2];
    
    [self getSubscriptionsForEntityKey:entity.key];
    subscriptions = self.fetchedElements;
    (void)subscriptions;
    
    NSLog(@"Waiting for notification");
    [self prepare];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:20.0];
}
#endif

@end
