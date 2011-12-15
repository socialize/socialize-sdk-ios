//
//  SocializeSubscriptionFormatterTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeSubscriptionFormatterTests.h"
#import "SocializeObjects.h"
#import "NSDate+Socialize.h"
#import "SocializeSubscriptionJSONFormatter.h"

@implementation SocializeSubscriptionFormatterTests

-(void)testToSubscription
{
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/subscription_single_response.json"];
    NSDictionary * JSONDictionaryToParse =(NSDictionary *)[JSONStringToParse objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    id mockSubscription = [OCMockObject mockForProtocol:@protocol(SocializeSubscription)];
    
    [[mockSubscription expect] setObjectID:[[JSONDictionaryToParse objectForKey:@"id"]intValue]];
    
    [[mockSubscription expect] setUser:OCMOCK_ANY];
    [[mockSubscription expect] setEntity:OCMOCK_ANY];
    [[mockSubscription expect] setSubscribed:YES];
    
    NSDate *expectedDate = [NSDate dateWithSocializeDateString:[JSONDictionaryToParse valueForKey:@"date"]];
    [[mockSubscription expect] setDate:expectedDate];
    
    [[mockSubscription expect] setType:@"new_comments"];

    SocializeSubscriptionJSONFormatter *entityFormatter = [[[SocializeSubscriptionJSONFormatter alloc] initWithFactory:_factory] autorelease];
    [entityFormatter toObject:mockSubscription fromString:JSONStringToParse];
    [mockSubscription verify];
}

@end
