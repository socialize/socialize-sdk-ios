//
//  SocializeSubscriptionService.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeSubscriptionService.h"
#import "SocializeObjects.h"

@implementation SocializeSubscriptionService

- (Protocol *)ProtocolType
{
    return  @protocol(SocializeSubscription);
}

- (void)callSubscriptionPostWithParams:(id)params success:(void(^)(NSArray *subscriptions))success failure:(void(^)(NSError *error))failure {
    [self callEndpointWithPath:@"user/subscription/" method:@"POST" params:params success:success failure:failure];
}

- (void)createSubscriptions:(NSArray*)subscriptions success:(void(^)(NSArray *subscriptions))success failure:(void(^)(NSError *error))failure {
    NSArray *params = [_objectCreator createDictionaryRepresentationArrayForObjects:subscriptions];
    [self callSubscriptionPostWithParams:params success:success failure:failure];
}

- (void)createSubscription:(id<SZSubscription>)subscription success:(void(^)(id<SZSubscription>))success failure:(void(^)(NSError *error))failure {
    [self createSubscriptions:[NSArray arrayWithObject:subscription] success:^(NSArray *subscriptions) {
        BLOCK_CALL_1(success, [subscriptions objectAtIndex:0]);
    } failure:failure];
}

- (void)createSubscription:(id<SZSubscription>)subscription {
    [self createSubscriptions:[NSArray arrayWithObject:subscription] success:nil failure:nil];
}

- (void)subscribeToCommentsForEntityKey:(NSString*)entityKey {
    SZEntity *entity = [SZEntity entityWithKey:entityKey name:nil];
    SZSubscription *subscription = [SZSubscription subscriptionWithEntity:entity type:@"new_comments" subscribed:YES];
    [self createSubscription:subscription];
}

- (void)unsubscribeFromCommentsForEntityKey:(NSString*)entityKey {
    SZEntity *entity = [SZEntity entityWithKey:entityKey name:nil];
    SZSubscription *subscription = [SZSubscription subscriptionWithEntity:entity type:@"new_comments" subscribed:NO];
    [self createSubscription:subscription];
}

- (void)getSubscriptionsForEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *subscriptions))success failure:(void(^)(NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[entity key] forKey:@"entity_key"];
    [self callListingGetEndpointWithPath:@"user/subscription/" params:params first:first last:last success:success failure:failure];
}

- (void)getSubscriptionsForEntityKey:(NSString*)entityKey first:(NSNumber*)first last:(NSNumber*)last {
    SZEntity *entity = [SZEntity entityWithKey:entityKey name:nil];
    [self getSubscriptionsForEntity:entity first:first last:last success:nil failure:nil];
}


@end
