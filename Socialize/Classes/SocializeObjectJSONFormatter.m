//
//  SocializeObjectParser.m
//  SocializeSDK
//
//  Created by William M. Johnson on 5/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeObjectParser.h"


@implementation SocializeObjectParser

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

-(void)toObject:(id<SocializeObject>) toObject From:(id)dataToParse
{
    
}
-(id)fromObject:(id<SocializeObject>) fromObject
{
    
    return nil;
}

@end
