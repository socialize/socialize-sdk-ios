//
//  SocializeShareJSONFormatter.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeShareJSONFormatter.h"
#import "SocializeShare.h"
#import <SZJSONKit/JSONKit.h>
#import "SocializeObjectFactory.h"

@implementation SocializeShareJSONFormatter

-(void)doToObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    id<SocializeShare> share = (id<SocializeShare>)toObject;
    
    [share setMedium:[[[JSONDictionary valueForKey:@"medium"] valueForKey:@"id"] intValue]];
    [super doToObject:share fromDictionary:JSONDictionary];
}

- (void)doToDictionary:(NSMutableDictionary *)dictionaryRepresentation fromObject:(id<SocializeObject>)fromObject {
    id<SocializeShare> share = (id<SocializeShare>)fromObject;

    NSString *medium = [NSString stringWithFormat:@"%d", [share medium]];
    [dictionaryRepresentation setObject:medium forKey:@"medium"];
    
    [super doToDictionary:dictionaryRepresentation fromObject:fromObject];
}

@end
