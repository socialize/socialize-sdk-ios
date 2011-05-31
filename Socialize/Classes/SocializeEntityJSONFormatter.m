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
 
    [self toEntity:(id<SocializeEntity>)toObject fromDictionary:JSONDictionary];
}

-(NSDictionary *)doFromObject:(id<SocializeObject>) fromObject
{
    
    return [self fromEntity:(id<SocializeEntity>)fromObject];
}

-(void)toEntity:(id<SocializeEntity>)toEntity fromDictionary:(NSDictionary *)JSONDictionary
{
    
    [toEntity setKey:[JSONDictionary objectForKey:@"Key"]];
    [toEntity setName:[JSONDictionary objectForKey:@"Name"]];
    [toEntity setViews:[[JSONDictionary objectForKey:@"Views"]intValue]];
    [toEntity setLikes:[[JSONDictionary objectForKey:@"Likes"]intValue]];
    [toEntity setComments:[[JSONDictionary objectForKey:@"Comments"]intValue]];  
    [toEntity setShares:[[JSONDictionary objectForKey:@"Shares"]intValue]]; 
}


-(NSDictionary *)fromEntity:(id<SocializeEntity>) fromObject
{
    
    NSMutableDictionary * JSONFormatDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [JSONFormatDictionary setObject:[fromObject key] forKey:@"Key"];
    [JSONFormatDictionary setObject:[fromObject name] forKey:@"Name"];
    [JSONFormatDictionary setObject:[NSNumber numberWithInt:[fromObject views]] forKey:@"Views"];
    [JSONFormatDictionary setObject:[NSNumber numberWithInt:[fromObject likes]] forKey:@"Likes"];
    [JSONFormatDictionary setObject:[NSNumber numberWithInt:[fromObject comments]] forKey:@"comments"];
    [JSONFormatDictionary setObject:[NSNumber numberWithInt:[fromObject shares]] forKey:@"Shares"];
    
    return JSONFormatDictionary;
}



@end
