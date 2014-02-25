//
//  SZSubscriptionUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"

typedef enum {
    SZSubscriptionTypeNewComments,
    SZSubscriptionTypeEntityNotification,
} SZSubscriptionType;

NSString *NSStringFromSZSubscriptionType(SZSubscriptionType type);

@interface SZSubscriptionUtils : NSObject

+ (void)subscribeToEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type success:(void(^)(id<SZSubscription> subscription))success failure:(void(^)(NSError *error))failure;
+ (void)unsubscribeFromEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type success:(void(^)(id<SZSubscription> subscription))success failure:(void(^)(NSError *error))failure;
+ (void)getSubscriptionsForEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *subscriptions))success failure:(void(^)(NSError *error))failure;
+ (void)isSubscribedToEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type success:(void(^)(BOOL isSubscribed))success failure:(void(^)(NSError *error))failure;


@end
