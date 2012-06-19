//
//  TestActivityServices.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/7/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "TestActivityServices.h"
#import <Socialize/Socialize.h>

@implementation TestActivityServices

- (void)testGetUserActivity {
    NSString *commentURL = [self testURL:[NSString stringWithFormat:@"%s/comment", _cmd]];
    [self createCommentWithURL:commentURL text:@"comment" latitude:nil longitude:nil subscribe:NO];

    NSString *shareURL = [self testURL:[NSString stringWithFormat:@"%s/share", _cmd]];
    [self createShareWithURL:shareURL medium:SocializeShareMediumFacebook text:@"share"];

    NSString *likeURL = [self testURL:[NSString stringWithFormat:@"%s/like", _cmd]];
    [self createLikeWithURL:likeURL latitude:nil longitude:nil];
    
    NSString *viewURL = [self testURL:[NSString stringWithFormat:@"%s/view", _cmd]];
    [self createViewWithURL:viewURL latitude:nil longitude:nil];
    
    // FIXME -- we can't even verify existence, sometimes these are missing
    // For now just verify 200 OK
    [self getActivityForCurrentUser];

    /*
    // Some ordering debugging
    NSMutableArray *info = [NSMutableArray array];
    for (id<SocializeActivity> obj in self.fetchedElements) {
        
        [info addObject:[NSArray arrayWithObjects:obj.entity.key, obj.date, nil]];
    }
    NSLog(@"Info = %@", info);
    */

    // FIXME we should be able to verify existence
    /*
    NSSet *verifyKeys = [NSSet setWithObjects:commentURL, shareURL, likeURL, viewURL, nil];
    NSMutableSet *fetchedKeys = [NSMutableSet set];
    for (id<SocializeActivity> activity in self.fetchedElements) {
        [fetchedKeys addObject:activity.entity.key];
    }
    GHAssertTrue([verifyKeys isSubsetOfSet:fetchedKeys], @"keys in %@ missing from response keys %@", verifyKeys, fetchedKeys);
    */
    
    // FIXME we should really be able to depend on ordering
     /*
    // First is share
    id<SocializeShare> share = [self.fetchedElements objectAtIndex:0];
    GHAssertEqualObjects(share.entity.key, shareURL, @"Bad share");

    // Then comment
    id<SocializeComment> comment = [self.fetchedElements objectAtIndex:1];
    GHAssertEqualObjects(comment.entity.key, commentURL, @"Bad comment");
     */
}

- (void)testGetApplicationActivity {
    // For now just verify 200 OK
    [self getActivityForApplication];
    NSLog(@"%@", self.fetchedElements);
}

@end
