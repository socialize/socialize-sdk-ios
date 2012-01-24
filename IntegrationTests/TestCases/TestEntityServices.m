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
    SocializeEntity *entity = [[[SocializeEntity alloc] init] autorelease];
    NSString *entityURL = [self testURL:[NSString stringWithFormat:@"%s/entity", _cmd]];
    NSString *entityName = @"entityName";
    NSString *entityMeta = @"entityMeta";
    
    entity.key = entityURL;
    entity.name = entityName;
    entity.meta = entityMeta;
    
    // Create it
    [self createEntity:entity];
    
    // Fetch and verify
    [self getEntityWithURL:entityURL];
    id<SocializeEntity> fetchedEntity = [self.fetchedElements objectAtIndex:0];
    GHAssertEqualObjects(fetchedEntity.key, entityURL, @"bad key");
    GHAssertEqualObjects(fetchedEntity.name, entityName, @"bad name");
    GHAssertEqualObjects(fetchedEntity.meta, entityMeta, @"bad meta");
    
    // Set meta nil, recreate, and verify meta remains unchanged
    entity.meta = nil;
    [self createEntity:entity];
    [self getEntityWithURL:entityURL];
    fetchedEntity = [self.fetchedElements objectAtIndex:0];
    GHAssertEqualObjects(fetchedEntity.meta, entityMeta, @"bad meta");
}

@end
