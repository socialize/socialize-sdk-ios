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

-(void)toObject:(id<SocializeObject>)toObject fromString:(NSString *)JSONString
{

    NSDictionary *  socializeObjectDictionary = (NSDictionary *) [JSONString objectFromJSONString];
    [self toObject:toObject fromDictionary:socializeObjectDictionary];
    
}

-(NSString*) toStringfromObject:(id<SocializeObject>) fromObject
{
    NSMutableDictionary* objectDictionaty = [[NSMutableDictionary alloc] init];
    [self toDictionary:objectDictionaty fromObject:fromObject];
    NSString* stringRepresentation = [objectDictionaty JSONString];
    [objectDictionaty release]; objectDictionaty = nil;
    
    return stringRepresentation;
}

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
