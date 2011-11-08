//
//  TestEntityServices.m
//  SampleSdkApp
//
//  Created by Nathaniel Griswold on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TestEntityServices.h"

@implementation TestEntityServices

- (void)testCreateEntity {
    NSString *entityURL = [self testURL:[NSString stringWithFormat:@"%s/entity", _cmd]];
    NSString *entityName = @"entityName";
    [self createEntityWithURL:entityURL name:entityName];
    
    [self getEntityWithURL:entityURL];
    id<SocializeEntity> entity = [self.fetchedElements objectAtIndex:0];
    GHAssertEqualObjects(entity.name, entityName, @"bad name");
}

@end
