//
//  TestActionUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestActionUtils.h"

@implementation TestActionUtils

- (void)testActionHelpers {
    NSString *entityKey = [self testURL:[NSString stringWithFormat:@"%s/action_target", (char*)_cmd]];
    SZEntity *entity = [SZEntity entityWithKey:entityKey name:@"Action target"];
    
    id<SZLike> serverLike = [self likeWithEntity:entity options:nil networks:SZSocialNetworkNone];

    NSArray *actions = [self getActionsForApplication];
    id<SZLike> foundLike = (id<SZLike>)[self findObjectWithId:[serverLike objectID] inArray:actions];
    GHAssertNotNil(foundLike, @"Should have like");

    actions = [self getActionsByEntity:entity];
    foundLike = (id<SZLike>)[self findObjectWithId:[serverLike objectID] inArray:actions];
    GHAssertNotNil(foundLike, @"Should have like");
    
    actions = [self getActionsForUser:(id<SZUser>)[SZUserUtils currentUser]];
    foundLike = (id<SZLike>)[self findObjectWithId:[serverLike objectID] inArray:actions];
    GHAssertNotNil(foundLike, @"Should have like");

    actions = [self getActionsForUser:(id<SZUser>)[SZUserUtils currentUser] entity:entity];
    foundLike = (id<SZLike>)[self findObjectWithId:[serverLike objectID] inArray:actions];
    GHAssertNotNil(foundLike, @"Should have like");
}

@end
