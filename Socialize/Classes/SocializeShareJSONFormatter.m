//
//  SocializeShareJSONFormatter.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeShareJSONFormatter.h"
#import "SocializeShare.h"
#import "JSONKit.h"
#import "SocializeObjectFactory.h"

@implementation SocializeShareJSONFormatter

-(void)doToObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    id<SocializeShare> share = (id<SocializeShare>)toObject;
    
    [share setObjectID: [[JSONDictionary valueForKey:@"id"]intValue]];
    [share setText:[JSONDictionary valueForKey:@"text"]];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
    [share setDate:[df dateFromString:[JSONDictionary valueForKey:@"date"]]];
    [df release]; df = nil;

    NSNumber* mediumNumber = [JSONDictionary valueForKey:@"medium"];
    
    if (mediumNumber && (![mediumNumber isEqual:[NSNull null]]))
        [share setMedium:[mediumNumber intValue]];
    else
        [share setMedium:0];
 
        
    [share setLat:[JSONDictionary valueForKey:@"lat"]];
    [share setLng:[JSONDictionary valueForKey:@"lng"]];
    
    [share setEntity:[_factory createObjectFromDictionary:[JSONDictionary valueForKey:@"entity"] forProtocol:@protocol(SocializeEntity)]];
    
    [share setApplication:[_factory createObjectFromDictionary: [JSONDictionary valueForKey:@"application"] forProtocol:@protocol(SocializeApplication)]];
    
    [share setUser:[_factory createObjectFromDictionary:[JSONDictionary valueForKey:@"user"] forProtocol:@protocol(SocializeUser)]];
}

@end
