//
//  TestSZUserUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestUserUtils.h"
#import <Socialize/Socialize.h>

@implementation TestUserUtils

- (void)testIsLinkedFalseWhenAnonymous {
    [self fakeCurrentUserAnonymous];
    BOOL isLinked = [SZUserUtils userIsLinked];
    GHAssertFalse(isLinked, @"Should not be linked");
}

- (void)testIsLinkedTrueWhenLinked {
    [self fakeCurrentUserWithThirdParties:[NSArray arrayWithObject:kSocializeFacebookStringForAPI]];
    BOOL isLinked = [SZUserUtils userIsLinked];
    GHAssertTrue(isLinked, @"Should be linked");
}

- (void)testSaveUserSettings {
    [[Socialize sharedSocialize] removeAuthenticationInfo];
    [self authenticateAnonymously];
    
    id<SZFullUser> user = [SZUserUtils currentUser];
    [user setFirstName:@"testFirstName"];
    [user setLastName:@"testLastName"];
    UIImage *image = [UIImage imageNamed:@"Smiley.png"];
    
    [self prepare];
    [SZUserUtils saveUserSettings:user profileImage:image success:^(id<SZFullUser> serverUser) {
        GHAssertEqualStrings([serverUser firstName], [user firstName], @"bad first name");
        GHAssertEqualStrings([serverUser lastName], [user lastName], @"bad last name");
        GHAssertNotNil([serverUser smallImageUrl], @"Should have image url");
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
}

- (void)testFetchCurrentUser {
    id<SZFullUser> currentUser = [SZUserUtils currentUser];
    NSNumber *userId = [NSNumber numberWithInteger:[currentUser objectID]];
    
    [self prepare];
    [SZUserUtils getUsersWithIds:[NSArray arrayWithObject:userId] success:^(NSArray *users) {
        id<SZFullUser> user = [users objectAtIndex:0];
        int serverId = [user objectID];
        GHAssertEquals(serverId, [currentUser objectID], @"Id did not match");
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
}

@end
