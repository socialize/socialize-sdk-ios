//
//  TestSubscriptionUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestSubscriptionUtils.h"

@implementation TestSubscriptionUtils

- (void)testSubscriptionWrappers {
    NSString *entityKey = [self testURL:[NSString stringWithFormat:@"%s/subscription_target", _cmd]];
    SZEntity *entity = [SZEntity entityWithKey:entityKey name:@"Subscription target"];

    id<SZSubscription> createdSubscription = [self subscribeToEntity:entity subscriptionType:SZSubscriptionTypeNewComments];
    
    BOOL isSubscribed = [self isSubscribedToEntity:entity subscriptionType:SZSubscriptionTypeNewComments];
    GHAssertTrue(isSubscribed, @"Not subscribed");
    
    NSArray *subscriptions = [self getSubscriptionsForEntity:entity];
    [self assertObject:createdSubscription inCollection:subscriptions];
    
    id<SZSubscription> deletedSubscription = [self unsubscribeFromEntity:entity subscriptionType:SZSubscriptionTypeNewComments];
    GHAssertEquals([createdSubscription objectID], [deletedSubscription objectID], @"ids did not match");
    
    isSubscribed = [self isSubscribedToEntity:entity subscriptionType:SZSubscriptionTypeNewComments];
    GHAssertFalse(isSubscribed, @"Should not be subscribed");
}

@end
