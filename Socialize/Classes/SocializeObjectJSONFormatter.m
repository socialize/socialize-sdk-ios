//
//  SocializeObjectParser.m
//  SocializeSDK
//
//  Created by William M. Johnson on 5/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeObjectJSONFormatter.h"


@implementation SocializeObjectJSONFormatter

-(void)dealloc
{
    
    [_factory release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) 
    {
    
    }
    return self;
}

-(id)initWithFactory:(SocializeObjectFactory *) theObjectFactory
{
    self = [super init];
    if (self) 
    {
        _factory = [theObjectFactory retain];
    }
    return self;
}

#pragma mark template method implementations
-(void)toObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    [self doToObject:toObject fromDictionary:JSONDictionary];
}

-(NSDictionary *)fromObject:(id<SocializeObject>) fromObject
{
    
    return [self doFromObject:fromObject];
}


#pragma mark primitive method implementations
-(void)doToObject:(id<SocializeObject>)toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    
    
}

-(NSDictionary *)doFromObject:(id<SocializeObject>) fromObject
{
    
    return  nil;
}

@end
