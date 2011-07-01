//
//  SocializeViewJSONFormatter.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeViewJSONFormatter.h"
#import "JSONKit.h"
#import "SocializeObjectFactory.h"
#import "SocializeView.h"

@implementation SocializeViewJSONFormatter


-(void)doToObject:(id<SocializeObject>)toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    id<SocializeView> view = (id<SocializeView>)toObject;
    [view setObjectID: [[JSONDictionary valueForKey:@"id"]intValue]];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
    [view setDate:[df dateFromString:[JSONDictionary valueForKey:@"date"]]];
    [df release]; df = nil;
    
    [view setEntity:[_factory createObjectFromDictionary:[JSONDictionary valueForKey:@"entity"] forProtocol:@protocol(SocializeEntity)]];
    
    [view setApplication:[_factory createObjectFromDictionary: [JSONDictionary valueForKey:@"application"] forProtocol:@protocol(SocializeApplication)]];
    
    [view setUser:[_factory createObjectFromDictionary:[JSONDictionary valueForKey:@"user"] forProtocol:@protocol(SocializeUser)]];
    
    NSNumber* latNumber = [JSONDictionary valueForKey:@"lat"];
    NSNumber* lngNumber = [JSONDictionary valueForKey:@"lng"];
    
    if (latNumber && (![latNumber isEqual:[NSNull null]]))
        [view setLat:[latNumber floatValue]];
    else
        [view setLat:0];
    
    if (lngNumber && (![lngNumber isEqual:[NSNull null]]))
        [view setLng:[lngNumber floatValue]];
    else
        [view setLng:0];
    
}

@end
