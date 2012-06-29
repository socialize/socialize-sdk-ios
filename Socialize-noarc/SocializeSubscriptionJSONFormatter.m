//
//  SocializeSubscriptionJSONFormatter.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeSubscriptionJSONFormatter.h"
#import "SocializeSubscription.h"
#import "SocializeEntity.h"
#import "SocializeObjectFactory.h"
#import "socialize_globals.h"

@implementation SocializeSubscriptionJSONFormatter

-(void)doToObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    id<SocializeSubscription> activity = (id<SocializeSubscription>)toObject;
    
    [activity setObjectID: [[JSONDictionary valueForKey:@"id"] intValue]];
    
    NSDate *date = [NSDate dateWithSocializeDateString:[JSONDictionary objectForKey:@"date"]];
    [activity setDate:date];
    
    [activity setEntity:[_factory createObjectFromDictionary:[JSONDictionary valueForKey:@"entity"] forProtocol:@protocol(SocializeEntity)]];
    
    [activity setUser:[_factory createObjectFromDictionary:[JSONDictionary valueForKey:@"user"] forProtocol:@protocol(SocializeUser)]];
    
    [activity setSubscribed:[[JSONDictionary objectForKey:@"subscribed"] boolValue]];
    
    [activity setType:[JSONDictionary objectForKey:@"type"]];
}

- (void)doToDictionary:(NSMutableDictionary *)dictionaryRepresentation fromObject:(id<SocializeObject>)fromObject {
    
    id<SocializeSubscription> subscription = (id<SocializeSubscription>)fromObject;
    
    [dictionaryRepresentation setValue:[NSNumber numberWithBool:[subscription subscribed]] forKey:@"subscribed"];
    [dictionaryRepresentation setValue:[subscription type] forKey:@"type"];
    
    [dictionaryRepresentation addEntriesFromDictionary:SZServerParamsForEntity([subscription entity])];

    [super doToDictionary:dictionaryRepresentation fromObject:fromObject];
}



@end

