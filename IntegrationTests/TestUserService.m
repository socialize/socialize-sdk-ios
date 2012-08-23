//
//  TestUserService.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/17/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestUserService.h"

@implementation TestUserService

- (void)testGettingLikeForCurrentUser {
    NSString *likeURL = [self testURL:[NSString stringWithFormat:@"%s/like", (char*)_cmd]];
    id<SocializeEntity> entity = [SocializeEntity entityWithKey:likeURL name:@"My Like"];
    [self createLikeWithURL:likeURL latitude:nil longitude:nil];
    
    [self getLikesForCurrentUserWithEntity:entity];
    
    id<SocializeLike> like = [self.fetchedElements objectAtIndex:0];
    GHAssertEqualStrings(like.entity.key, likeURL, @"Unexpected like");
    GHAssertEquals(like.entity.likes, 1, @"Should be liked exactly once");
}

@end
