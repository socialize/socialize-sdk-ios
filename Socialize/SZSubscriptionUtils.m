//
//  SZSubscriptionUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZSubscriptionUtils.h"
#import "_Socialize.h"
#import "SDKHelpers.h"

NSString *NSStringFromSZSubscriptionType(SZSubscriptionType type) {
    switch (type) {
        case SZSubscriptionTypeNewComments:
            return @"new_comments";
        case SZSubscriptionTypeEntityNotification:
            return @"entity_notification";
    }
}

@implementation SZSubscriptionUtils

+ (void)subscribeToEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type success:(void(^)(id<SZSubscription> subscription))success failure:(void(^)(NSError *error))failure {
    SZSubscription *subscription = [SZSubscription subscriptionWithEntity:entity type:NSStringFromSZSubscriptionType(type) subscribed:YES];
    
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] createSubscription:subscription success:success failure:failure];
    }, failure);
}

+ (void)unsubscribeFromEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type success:(void(^)(id<SZSubscription> subscription))success failure:(void(^)(NSError *error))failure {
    SZSubscription *subscription = [SZSubscription subscriptionWithEntity:entity type:NSStringFromSZSubscriptionType(type) subscribed:NO];
    
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] createSubscription:subscription success:success failure:failure];
    }, failure);
}

+ (void)getSubscriptionsForEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *subscriptions))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] getSubscriptionsForEntity:entity first:start last:end success:success failure:failure];
    }, failure);
}

+ (void)isSubscribedToEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type success:(void(^)(BOOL isSubscribed))success failure:(void(^)(NSError *error))failure {
    [self getSubscriptionsForEntity:entity subscriptionType:(SZSubscriptionType)type start:nil end:nil success:^(NSArray *subscriptions) {
        id<SZSubscription> subscription = [subscriptions lastObject];
        BLOCK_CALL_1(success, [subscription subscribed]);
    } failure:failure];
}

@end
