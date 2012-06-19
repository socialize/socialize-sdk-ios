//
//  TestSubscriptionService.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "TestSubscriptionService.h"

@implementation TestSubscriptionService

- (void)testCreateSubscriptionOnComment {
    NSString *entityKey = [self testURL:[NSString stringWithFormat:@"%s/entity", _cmd]];

    // Get current subscriptions for the entity (should be empty)
    [self prepare];
    [self.socialize getSubscriptionsForEntityKey:entityKey first:nil last:nil];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
    
    // Assert emptiness
    GHAssertTrue([self.fetchedElements count] == 0, @"Should be empty");
    
    // Subscribe to comments on this entity
    [self prepare];
    [self.socialize subscribeToCommentsForEntityKey:entityKey];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
    GHAssertEqualObjects([[self.createdObject entity] key], entityKey, @"Bad entity key");
    GHAssertEqualObjects([(id<SocializeSubscription>)self.createdObject type], @"new_comments", @"bad type");
    
    // Get updated subscriptions for the entity (should contain new subscription)
    [self getSubscriptionsForEntityKey:entityKey];
    
    // Test singular subscription object has correct key and type, and is subscribed
    GHAssertTrue([self.fetchedElements count] == 1, @"Should contain new subscription");
    id<SocializeSubscription> subscription = [self.fetchedElements objectAtIndex:0];
    GHAssertEqualObjects([[subscription entity] key], entityKey, @"Bad entity key");
    GHAssertEqualObjects([subscription type], @"new_comments", @"bad type");
    GHAssertTrue([subscription subscribed], @"subscribed should be true");
    
    // Unsubscribe to comments for this entity
    [self prepare];
    [self.socialize unsubscribeFromCommentsForEntityKey:entityKey];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
    GHAssertEqualObjects([[self.createdObject entity] key], entityKey, @"Bad entity key");
    GHAssertEqualObjects([(id<SocializeSubscription>)self.createdObject type], @"new_comments", @"bad type");
    GHAssertFalse([self.createdObject subscribed], @"subscribed should be false");
    
    // Get updated subscriptions for the entity (should be empty again)
    [self prepare];
    [self.socialize getSubscriptionsForEntityKey:entityKey first:nil last:nil];
    [self waitForStatus:kGHUnitWaitStatusSuccess];

    // Test singular subscription object has correct key and type, and is no longer subscribed
    GHAssertTrue([self.fetchedElements count] == 1, @"Should contain one subscription");
    subscription = [self.fetchedElements objectAtIndex:0];
    GHAssertEqualObjects([[subscription entity] key], entityKey, @"Bad entity key");
    GHAssertEqualObjects([subscription type], @"new_comments", @"bad type");
    GHAssertFalse([subscription subscribed], @"subscribed should be false");
}

- (void)testCreatingNewCommentWithSubscription {
    NSString *entityKey = [self testURL:[NSString stringWithFormat:@"%s/entity", _cmd]];

    [self createCommentWithURL:entityKey text:@"comment" latitude:nil longitude:nil subscribe:YES];
    
    [self getSubscriptionsForEntityKey:entityKey];
    
    GHAssertTrue([self.fetchedElements count] == 1, @"Should contain one subscription");
    id<SocializeSubscription> subscription = [self.fetchedElements objectAtIndex:0];
    GHAssertEqualObjects([[subscription entity] key], entityKey, @"Bad entity key");
}

@end
