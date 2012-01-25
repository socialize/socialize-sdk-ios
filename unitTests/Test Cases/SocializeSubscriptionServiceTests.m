//
//  SocializeSubscriptionServiceTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeSubscriptionServiceTests.h"
#import "SocializeSubscriptionService.h"

@implementation SocializeSubscriptionServiceTests
@synthesize subscriptionService = subscriptionService_;
@synthesize origSubscriptionService = origSubscriptionService_;

- (void)setUp {
    self.origSubscriptionService = [[[SocializeSubscriptionService alloc] initWithObjectFactory:nil delegate:nil] autorelease];
    self.subscriptionService = [OCMockObject partialMockForObject:self.origSubscriptionService];
}

- (BOOL)request:(SocializeRequest*)request isRequestWithPath:(NSString*)path method:(NSString*)method format:(ExpectedResponseFormat)format {
    if (![request.resourcePath isEqualToString:path])
        return NO;
    if (![request.httpMethod isEqualToString:method])
        return NO;
    if (request.expectedJSONFormat != format)
        return NO;

    return YES;
}

- (BOOL)request:(SocializeRequest*)request isSubscriptionPOSTForKey:(NSString*)entityKey subscribed:(BOOL)subscribed {
    if (![self request:request isRequestWithPath:@"user/subscription/" method:@"POST" format:SocializeDictionaryWithListAndErrors])
        return NO;
    
    NSDictionary *params = [request.params objectAtIndex:0];
    if (! ([[params objectForKey:@"subscribed"] boolValue] == subscribed) )
        return NO;
    
    if (![[params objectForKey:@"entity_key"] isEqualToString:entityKey])
        return NO;
    
    if (![[params objectForKey:@"type"] isEqualToString:@"new_comments"])
        return NO;
    
    return YES;
}

- (BOOL)request:(SocializeRequest*)request hasFirst:(NSNumber*)first last:(NSNumber*)last {
    return [[request.params objectForKey:@"first"] isEqual:first]
        && [[request.params objectForKey:@"last"] isEqual:last];
}

- (void)testSubscribeRequest {
    NSString *testEntity = @"testEntity";
    
    [[(id)self.subscriptionService expect] executeRequest:[OCMArg checkWithBlock:^(SocializeRequest *request) {
        return [self request:request isSubscriptionPOSTForKey:testEntity subscribed:YES];
    }]];
    [self.subscriptionService subscribeToCommentsForEntityKey:testEntity];
}

- (void)testUnsubscribeRequest {
    NSString *testEntity = @"testEntity";
    
    [[(id)self.subscriptionService expect] executeRequest:[OCMArg checkWithBlock:^(SocializeRequest *request) {
        return [self request:request isSubscriptionPOSTForKey:testEntity subscribed:NO];
    }]];
    [self.subscriptionService unsubscribeFromCommentsForEntityKey:testEntity];
}

- (void)testGetSubscriptions {
    NSString *testEntity = @"testEntity";
    NSNumber *first = [NSNumber numberWithInteger:60];
    NSNumber *last = [NSNumber numberWithInteger:70];

    [[(id)self.subscriptionService expect] executeRequest:[OCMArg checkWithBlock:^(SocializeRequest *request) {
        if (![self request:request isRequestWithPath:@"user/subscription/" method:@"GET" format:SocializeDictionaryWithListAndErrors])
            return NO;
        if (![self request:request hasFirst:first last:last])
            return NO;
        if (![[request.params objectForKey:@"entity_key"] isEqualToString:testEntity])
            return NO;
        
        return YES;
    }]];
    
    [self.subscriptionService getSubscriptionsForEntityKey:testEntity first:first last:last];

}


@end
