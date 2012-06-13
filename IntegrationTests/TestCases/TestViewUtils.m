//
//  TestViewUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestViewUtils.h"

@implementation TestViewUtils

- (void)testViewWrappers {
    NSString *entityKey = [self testURL:[NSString stringWithFormat:@"%s/like_target", _cmd]];
    SZEntity *entity = [SZEntity entityWithKey:entityKey name:@"Like target"];

    id<SZView> createdView = [self viewEntity:entity];
    
    id<SZView> fetchedView = [self getView:entity];
    GHAssertEquals([fetchedView objectID], [createdView objectID], @"Object ids did not match");
    
    NSArray *views = [self getViewsByUser:(id<SZUser>)[SZUserUtils currentUser]];
    [self assertObject:createdView inCollection:views];

    views = [self getViewsByUser:(id<SZUser>)[SZUserUtils currentUser] entity:entity];
    [self assertObject:createdView inCollection:views];
}

@end
