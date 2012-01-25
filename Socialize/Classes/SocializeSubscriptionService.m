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

- (NSDictionary*)subscriptionParamDictForEntityKey:(NSString*)entityKey subscribed:(BOOL)subscribed type:(NSString*)type {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            entityKey, @"entity_key",
                            [NSNumber numberWithBool:subscribed], @"subscribed",
                            type, @"type",
                            nil];
    
    return params;
}

- (void)createSubscriptions:(NSArray*)subscriptions {
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"POST"
                                resourcePath:@"user/subscription/"
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:subscriptions]
     ];
}

- (void)createSubscription:(NSDictionary*)subscription {
    [self createSubscriptions:[NSArray arrayWithObject:subscription]];
}

- (void)subscribeToCommentsForEntityKey:(NSString*)entityKey {
    NSDictionary *dict = [self subscriptionParamDictForEntityKey:entityKey subscribed:YES type:@"new_comments"];
    [self createSubscription:dict];
}

- (void)unsubscribeFromCommentsForEntityKey:(NSString*)entityKey {
    NSDictionary *dict = [self subscriptionParamDictForEntityKey:entityKey subscribed:NO type:@"new_comments"];
    [self createSubscription:dict];
}

- (void)getSubscriptionsForEntityKey:(NSString*)entityKey first:(NSNumber*)first last:(NSNumber*)last {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:entityKey forKey:@"entity_key"];
    if (first != nil && last != nil) {
        [params setObject:first forKey:@"first"];
        [params setObject:last forKey:@"last"];
    }
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:@"user/subscription/"
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]
     ];
}

@end
