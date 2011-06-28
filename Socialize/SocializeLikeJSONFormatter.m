//
//  SocializeLikeJSONFormatter.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/27/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeLikeJSONFormatter.h"
#import "JSONKit.h"
#import "SocializeObjectFactory.h"
#import "SocializeLike.h"

@implementation SocializeLikeJSONFormatter


-(void)doToObject:(id<SocializeObject>)toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    id<SocializeLike> like = (id<SocializeLike>)toObject;

    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
    [like setDate:[df dateFromString:[JSONDictionary valueForKey:@"date"]]];
    [df release]; df = nil;
    
    [like setEntity:[_factory createObjectFromDictionary:[JSONDictionary valueForKey:@"entity"] forProtocol:@protocol(SocializeEntity)]];
    
    [like setApplication:[_factory createObjectFromDictionary: [JSONDictionary valueForKey:@"application"] forProtocol:@protocol(SocializeApplication)]];
    
    [like setUser:[_factory createObjectFromDictionary:[JSONDictionary valueForKey:@"user"] forProtocol:@protocol(SocializeUser)]];
    
    [like setLat:[[JSONDictionary valueForKey:@"lat"]floatValue]];
    [like setLng:[[JSONDictionary valueForKey:@"lng"]floatValue]];

}
@end
