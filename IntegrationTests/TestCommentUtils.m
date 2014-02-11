//
//  TestSZCommentUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestCommentUtils.h"
#import <Socialize/Socialize.h>
#import "integrationtests_globals.h"

@implementation TestCommentUtils

- (void)testCreateAndGetComments {
    NSString *commentURL = [self testURL:[NSString stringWithFormat:@"%s/comment", sel_getName(_cmd)]];
    SZEntity *entity = [SZEntity entityWithKey:commentURL name:@"Comment"];
    NSString *commentText = @"Comment Text";
    
    
    id<SZComment> serverComment = [self addCommentWithEntity:entity text:commentText options:nil networks:SZSocialNetworkNone];
    GHAssertEqualStrings([serverComment text], commentText, @"Comment text incorrect");

    // Fetch by comment id
    id<SZComment> fetchedComment = [self getCommentWithId:[NSNumber numberWithInteger:[serverComment objectID]]];
    GHAssertEqualStrings([fetchedComment text], commentText, @"Comment text incorrect");
    
    // Fetch by entity key
    NSArray *fetchedComments = [self utilGetCommentsForEntityWithKey:entity.key];
    GHAssertTrue([fetchedComments count] == 1, @"Should be one comment on entity, but found %d", [fetchedComments count]);
    fetchedComment = [fetchedComments objectAtIndex:0];
    GHAssertEqualStrings([fetchedComment text], commentText, @"Comment text incorrect");
    
    // Fetch by user
    fetchedComments = [self getCommentsByUser:(id<SZUser>)[SZUserUtils currentUser]];
    fetchedComment = [fetchedComments bk_match:^BOOL (id<SZComment> comment) {
        return [comment objectID] == [serverComment objectID];
    }];
    GHAssertNotNil(fetchedComment, @"Comment not on user");
    
    // Fetch by user and entity
    fetchedComments = [self getCommentsByUser:(id<SZUser>)[SZUserUtils currentUser] entity:entity];
    fetchedComment = [fetchedComments bk_match:^BOOL (id<SZComment> comment) {
        return [comment objectID] == [serverComment objectID];
    }];
    GHAssertNotNil(fetchedComment, @"Comment not on user");
    
    // Fetch by app (globally)
    fetchedComments = [self getCommentsByApplication];
    fetchedComment = [fetchedComments bk_match:^BOOL (id<SZComment> comment) {
        return [comment objectID] == [serverComment objectID];
    }];
    GHAssertNotNil(fetchedComment, @"Comment not in application");

}

- (void)testCreateAndGetCommentsInvalidChars {
    NSString *commentURL = [self testURL:[NSString stringWithFormat:@"%s/comment", sel_getName(_cmd)]];
    SZEntity *entity = [SZEntity entityWithKey:commentURL name:@"Comment"];
    NSString *commentTextNoUnicode = @"Comment Text Unicode:";
    NSString *commentText = [NSString stringWithFormat:@"Comment Text Unicode:%C", (unichar)0x0000];
    
    id<SZComment> serverComment = [self addCommentWithEntity:entity text:commentText options:nil networks:SZSocialNetworkNone];
    NSString *serverCommentText = [serverComment text];
    
    int commentTextLength = [commentText length];
    int commentTextLengthNoUnicode = [commentTextNoUnicode length];
    int serverCommentTextLength = [serverCommentText length];
    
    //ensure unicode got stripped out (length should be equal to String without Unicode in it)
    GHAssertNotEquals(commentTextLength, serverCommentTextLength, @"");
    GHAssertEquals(commentTextLengthNoUnicode, serverCommentTextLength, @"");
}

@end
