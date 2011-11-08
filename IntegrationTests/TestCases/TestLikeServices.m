//
//  TestLikeServices.m
//  SampleSdkApp
//
//  Created by Nathaniel Griswold on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TestLikeServices.h"

@implementation TestLikeServices

- (void)testCreateDeleteLike {
    NSString *likeURL = [self testURL:[NSString stringWithFormat:@"%s/like", _cmd]];
    [self createLikeWithURL:likeURL latitude:nil longitude:nil];
    
    [self getLikesForURL:likeURL];
    id<SocializeLike> like = [self.fetchedElements objectAtIndex:0];
    GHAssertEqualObjects(like.entity.key, likeURL, @"Bad key");
    
    [self deleteLike:like];
    [self getLikesForURL:likeURL];
    GHAssertTrue([self.fetchedElements count] == 0, @"Bad count");
}

@end
