//
//  SocializeEntityJSONFormatter.m
//  SocializeSDK
//
//  Created by William M. Johnson on 5/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeEntityJSONFormatter.h"
#import "SocializeObject.h"
#import "SocializeEntity.h"


@implementation SocializeEntityJSONFormatter

-(void)doToObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    id<SocializeEntity> toEntity = (id<SocializeEntity>)toObject;
 
    [toEntity setKey:[JSONDictionary objectForKey:@"key"]];
    [toEntity setName:[JSONDictionary objectForKey:@"name"]];
    [toEntity setType:[JSONDictionary objectForKey:@"type"]];
    [toEntity setViews:[[JSONDictionary objectForKey:@"views"]intValue]];
    [toEntity setLikes:[[JSONDictionary objectForKey:@"likes"]intValue]];
    [toEntity setComments:[[JSONDictionary objectForKey:@"comments"]intValue]];  
    [toEntity setShares:[[JSONDictionary objectForKey:@"shares"]intValue]]; 
    [toEntity setMeta:[JSONDictionary objectForKey:@"meta"]];
    [toEntity setUserActionSummary:[JSONDictionary objectForKey:@"user_action_summary"]];
    
    [super doToObject:toObject fromDictionary:JSONDictionary];
}

-(void)doToDictionary:(NSMutableDictionary *)JSONFormatDictionary fromObject:(id<SocializeObject>) fromObject
{
    id<SocializeEntity> fromEntity = (id<SocializeEntity>)fromObject;
    [JSONFormatDictionary setObject:[fromEntity key] forKey:@"key"];
    [JSONFormatDictionary setValue:[fromEntity name] forKey:@"name"];
    
    [JSONFormatDictionary setValue:[fromEntity type] forKey:@"type"];
    
    if ([fromEntity meta] != nil) {
        [JSONFormatDictionary setObject:[fromEntity meta] forKey:@"meta"];
    }
}

@end
