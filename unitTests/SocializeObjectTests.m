//
//  SocializeObjectTests.m
//  SocializeSDK
//
//  Created by William Johnson on 5/16/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeObjectTests.h"
#import "SocializeObject.h"


@implementation SocializeObjectTests

-(void)testSocializeObject
{
    id<SocializeObject> so = [[[SocializeObject alloc]init]autorelease];
    
    so.objectID = 2;
    
    GHAssertTrue(so.objectID ==2, @"YES IT Works");
    
    
}
@end
