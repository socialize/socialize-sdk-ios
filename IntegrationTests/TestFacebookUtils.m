//
//  TestSZFacebookUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestFacebookUtils.h"
#import "SZTestHelper.h"

@implementation TestFacebookUtils

- (void)linkToFacebookIfNeeded {
    if (![SZFacebookUtils isLinked]) {
        NSString *accessToken = [[SZTestHelper sharedTestHelper] facebookAccessToken];

        [self prepare];
        [SZFacebookUtils linkWithAccessToken:accessToken expirationDate:[NSDate distantFuture] success:^(id<SZFullUser> fullUser) {
            [self notify:kGHUnitWaitStatusSuccess];
        } failure:^(NSError *error) {
            [self notify:kGHUnitWaitStatusFailure];        
        }];
        [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    }
}

- (void)testLink {
    [SZFacebookUtils unlink];
    [self linkToFacebookIfNeeded];
}

- (void)testGraphPosting {
    [self linkToFacebookIfNeeded];
    
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"message", @"message",
                              @"caption", @"caption",
                              @"http://www.getsocialize.com", @"link",
                              @"A link", @"name",
                              @"description", @"description",
                              nil];
    
    __block NSDictionary *postInfo = nil;
    
    // POST the post and grab id
    [self prepare];
    [SZFacebookUtils postWithGraphPath:@"me/feed" params:postData success:^(id info) {
        postInfo = [info retain];
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
    NSString *postID = [postInfo objectForKey:@"id"];
    
    // GET the post and verify id
    [self prepare];
    [SZFacebookUtils getWithGraphPath:postID params:nil success:^(id info) {
        GHAssertEqualStrings([info objectForKey:@"id"], postID, @"Not the post");
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess];

    // DELETE the post
    [self prepare];
    [SZFacebookUtils deleteWithGraphPath:postID params:nil success:^(id info) {
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess];

    [postInfo release];
}

@end
