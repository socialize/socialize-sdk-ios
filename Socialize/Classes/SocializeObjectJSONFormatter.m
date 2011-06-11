//
//  SocializeObjectParser.m
//  SocializeSDK
//
//  Created by William M. Johnson on 5/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeObjectJSONFormatter.h"
#import "SocializeObject.h"
#import "JSONKit.h"


@implementation SocializeObjectJSONFormatter

-(void)toObject:(id<SocializeObject>)toObject fromJSONString:(NSString *)JSONString
{

    NSDictionary *  socializeObjectDictionary = (NSDictionary *) [JSONString objectFromJSONString];
    [self toObject:toObject fromDictionary:socializeObjectDictionary];
    
}

//-(NSString *)toJSONStringFromObject:(id<SocializeObject>)fromObject
//{
//    
//    NSMutableDictionary *  socializeObjectDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
//    [self toDictionary:socializeObjectDictionary fromObject:fromObject];
//    
//    return  [socializeObjectDictionary JSONString];
//    
//}


#pragma mark template method implementations
-(void)toObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    [self doToObject:toObject fromDictionary:JSONDictionary];
}

-(void)toDictionary:(NSMutableDictionary *)dictionary fromObject:(id<SocializeObject>) fromObject
{
    [self doToDictionary:dictionary fromObject:fromObject];
}


#pragma mark primitive method implementations
-(void)doToObject:(id<SocializeObject>)toObject fromDictionary:(NSDictionary *)JSONDictionary
{}

-(void)doToDictionary:(NSMutableDictionary *)dictionary fromObject:(id<SocializeObject>) fromObject
{}

@end
