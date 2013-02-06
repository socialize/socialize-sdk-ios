//
//  TestLikeUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/11/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestLikeUtils.h"
#import "integrationtests_globals.h"

@implementation TestLikeUtils

- (void)testLikeHelpers {
    NSString *entityKey = [self testURL:[NSString stringWithFormat:@"%s/like_target", sel_getName(_cmd)]];
    SZEntity *entity = [SZEntity entityWithKey:entityKey name:@"Like target"];

    // Make sure there is no like
    id<SZLike> serverLike = [self getLike:entity];
    GHAssertNil(serverLike, @"Should not have like");

    // Like the entity
    [self likeWithEntity:entity options:nil networks:SZSocialNetworkNone];
    
    // Make sure there is a like
    serverLike = [self getLike:entity];
    GHAssertNotNil(serverLike, @"Should have like");
    
    serverLike = [self getLikeForUser:(id<SZUser>)[SZUserUtils currentUser] entity:entity];
    GHAssertNotNil(serverLike, @"Should have like");
    
    // Check most recent likes for current user
    NSArray *fetchedLikes = [self getLikesForUser:(id<SZUser>)[SZUserUtils currentUser]];
    id<SZLike> foundLike = [fetchedLikes match:^BOOL (id<SZLike> like) {
        return [like objectID] == [serverLike objectID];
    }];
    GHAssertNotNil(foundLike, @"Should have like in user likes");

    // Check most recent likes for current user
    fetchedLikes = [self getLikesByApplication];
    foundLike = [fetchedLikes match:^BOOL (id<SZLike> like) {
        return [like objectID] == [serverLike objectID];
    }];
    GHAssertNotNil(foundLike, @"Should have like in application likes");

    // Check isLiked
    BOOL isLiked = [self isLiked:entity];
    GHAssertTrue(isLiked, @"Should be liked");
    
    // Unlike the entity
    [self unlike:entity];
    
    // Make sure it's gone again
    serverLike = [self getLike:entity];
    GHAssertNil(serverLike, @"Should not have like");

}

@end
