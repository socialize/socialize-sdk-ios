//
//  TestSZEntityUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestEntityUtils.h"

@implementation TestEntityUtils

- (void)testEntityWrappers {
    NSString *entityKey = [self testURL:[NSString stringWithFormat:@"%s/like_target", _cmd]];
    SZEntity *entity = [SZEntity entityWithKey:entityKey name:@"Like target"];
    
    // Add entity
    id<SZEntity> createdEntity = [self addEntity:entity];
    
    // Get entities (app-wide)
    NSArray *entities = [self getEntities];
    [self assertObject:createdEntity inCollection:entities];

    // Get entities (by id)
    entities = [self getEntitiesWithIds:[NSArray arrayWithObject:[NSNumber numberWithInteger:[createdEntity objectID]]]];
    [self assertObject:createdEntity inCollection:entities];

    // Get entity (specifically, by key)
    id<SZEntity> fetchedEntity = [self getEntityWithKey:entityKey];
    GHAssertEquals([fetchedEntity objectID], [createdEntity objectID], @"Bad id");
}

@end
