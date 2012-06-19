//
//  TestCommentServices.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/15/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "TestCommentServices.h"

@implementation TestCommentServices

- (void)testCreateComment {
    SocializeEntity *entity = [[[SocializeEntity alloc] init] autorelease];
    entity.name = @"my comment name";
    entity.key = [self testURL:[NSString stringWithFormat:@"%s/comment", _cmd]];
    NSNumber *latitude = [NSNumber numberWithFloat:12.f];
    NSNumber *longitude = [NSNumber numberWithFloat:34.f];
    
    [self createCommentWithEntity:entity text:@"test comment" latitude:latitude longitude:longitude subscribe:YES];
    
    [self getCommentsForEntityWithKey:entity.key];
    
    id<SocializeComment> fetchedComment = [self.fetchedElements objectAtIndex:0];
    GHAssertEqualObjects(fetchedComment.entity.key, entity.key, @"bad key");
    GHAssertEqualObjects(fetchedComment.entity.name, entity.name, @"bad name");
    GHAssertEqualObjects(fetchedComment.lat, latitude, @"bad latitude");
    GHAssertEqualObjects(fetchedComment.lng, longitude, @"bad longitude");
}

- (void)testCreateCommentJustKey {
    NSString *commentText = @"test comment";
    NSString *entityKey = [self testURL:[NSString stringWithFormat:@"%s/comment", _cmd]];
    NSNumber *latitude = [NSNumber numberWithFloat:12.f];
    NSNumber *longitude = [NSNumber numberWithFloat:34.f];
    
    [self createCommentWithURL:entityKey text:commentText latitude:latitude longitude:longitude subscribe:YES];
    
    [self getCommentsForEntityWithKey:entityKey];
    
    id<SocializeComment> fetchedComment = [self.fetchedElements objectAtIndex:0];
    GHAssertEqualObjects(fetchedComment.entity.key, entityKey, @"bad key");
    GHAssertEqualObjects(fetchedComment.lat, latitude, @"bad latitude");
    GHAssertEqualObjects(fetchedComment.lng, longitude, @"bad longitude");
}

- (void)testCreateMultipleComments {
    NSString *key1 = [self testURL:[NSString stringWithFormat:@"%s/comment1", _cmd]];
    NSString *key2 = [self testURL:[NSString stringWithFormat:@"%s/comment2", _cmd]];
    SocializeEntity *entity1 = [SocializeEntity entityWithKey:key1 name:@"name1"];
    SocializeEntity *entity2 = [SocializeEntity entityWithKey:key2 name:@"name2"];

    SocializeComment *comment1 = [SocializeComment commentWithEntity:entity1 text:@"first comment"];
    SocializeComment *comment2 = [SocializeComment commentWithEntity:entity2 text:@"second comment"];
    [self createComments:[NSArray arrayWithObjects:comment1, comment2, nil]];
    
    GHAssertTrue([self.createdObject count] == 2, @"bad count");
}

@end
