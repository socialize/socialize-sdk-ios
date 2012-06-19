//
//  SocializeSubscription.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeSubscription.h"

@implementation SocializeSubscription
@synthesize  entity = entity_;
@synthesize  user = user_;
@synthesize  date = date_;
@synthesize subscribed = subscribed_;
@synthesize type = type_;

-(void)dealloc
{
    [entity_ release];
    [user_ release];
    [date_ release];
    [type_ release];
    [super dealloc];
}

+ (SocializeSubscription*)subscriptionWithEntity:(id<SocializeEntity>)entity type:(NSString*)type subscribed:(BOOL)subscribed {
    SocializeSubscription *subscription = [[[SocializeSubscription alloc] init] autorelease];
    [subscription setEntity:entity];
    [subscription setType:type];
    [subscription setSubscribed:subscribed];
    
    return subscription;
}

@end
