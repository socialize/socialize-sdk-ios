//
//  SocializeErrorFormatter.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/5/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeErrorFormatter.h"
#import "SocializeError.h"

@implementation SocializeErrorFormatter

-(void)doToObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    id<SocializeError> share = (id<SocializeError>)toObject;
        
    [share setError:[JSONDictionary valueForKey:@"error"]];
    [share setPayload:[JSONDictionary valueForKey:@"payload"]];
}

@end
