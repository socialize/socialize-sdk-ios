//
//  SZSubscriptionUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZSubscriptionUtils.h"
#import "_Socialize.h"

NSString *NSStringFromSZSubscriptionType(SZSubscriptionType type) {
    switch (type) {
        case SZSubscriptionTypeNewComments:
            return @"new_comments";
    }
}

@implementation SZSubscriptionUtils

+ (void)subscribeToEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type success:(void(^)(id<SZSubscription> subscription))success failure:(void(^)(NSError *error))failure {
    SZSubscription *subscription = [SZSubscription subscriptionWithEntity:entity type:NSStringFromSZSubscriptionType(type) subscribed:YES];
    [[Socialize sharedSocialize] createSubscription:subscription success:success failure:failure];
}

+ (void)unsubscribeFromEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type success:(void(^)(id<SZSubscription> subscription))success failure:(void(^)(NSError *error))failure {
    SZSubscription *subscription = [SZSubscription subscriptionWithEntity:entity type:NSStringFromSZSubscriptionType(type) subscribed:NO];
    [[Socialize sharedSocialize] createSubscription:subscription success:success failure:failure];
}

+ (void)getSubscriptionsForEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *subscriptions))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getSubscriptionsForEntity:entity first:start last:end success:success failure:failure];
}

+ (void)isSubscribedToEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type success:(void(^)(BOOL isSubscribed))success failure:(void(^)(NSError *error))failure {
    [[Socialize sharedSocialize] getSubscriptionsForEntity:entity first:nil last:nil success:^(NSArray *subscriptions) {
        id<SZSubscription> subscription = [subscriptions lastObject];
        BLOCK_CALL_1(success, [subscription subscribed]);
    } failure:failure];
}

@end
