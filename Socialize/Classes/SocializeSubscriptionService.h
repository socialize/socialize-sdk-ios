//
//  SocializeSubscriptionService.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeService.h"
#import "SocializeObjects.h"

@interface SocializeSubscriptionService : SocializeService

- (void)createSubscriptions:(NSArray*)subscriptions success:(void(^)(NSArray *subscriptions))success failure:(void(^)(NSError *error))failure;
- (void)createSubscription:(id<SZSubscription>)subscription success:(void(^)(id<SZSubscription>))success failure:(void(^)(NSError *error))failure;
- (void)getSubscriptionsForEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *subscriptions))success failure:(void(^)(NSError *error))failure;
- (void)subscribeToCommentsForEntityKey:(NSString*)entityKey;
- (void)unsubscribeFromCommentsForEntityKey:(NSString*)entityKey;
- (void)getSubscriptionsForEntityKey:(NSString*)entityKey first:(NSNumber*)first last:(NSNumber*)last;

@end
