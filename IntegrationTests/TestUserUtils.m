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
    
    NSString *testFirstName = @"testFirstName";
    NSString *testLastName = @"testLastName";
    NSString *testBio = @"testBio";
    
    SZUserSettings *settings = [SZUserUtils currentUserSettings];
    
    settings.firstName = testFirstName;
    settings.lastName = testLastName;
    settings.bio = testBio;
    settings.profileImage = [UIImage imageNamed:@"Smiley.png"];
    
    [self prepare];
    [SZUserUtils saveUserSettings:settings success:^(SZUserSettings *settings, id<SZFullUser> serverUser) {
        GHAssertEqualStrings([serverUser firstName], testFirstName, @"bad first name");
        GHAssertEqualStrings([serverUser lastName], testLastName, @"bad last name");
        GHAssertEqualStrings([serverUser description], testBio, @"bad bio");
        GHAssertNotNil([serverUser smallImageUrl], @"Should have image url");
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
}

- (void)testDefaultsAreCopiedToSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:kSocializeShouldShareLocationKey];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:kSocializeDontPostToTwitterKey];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:kSocializeDontPostToFacebookKey];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:kSocializeAutoPostToSocialNetworksKey];
    [defaults synchronize];
    
    SZUserSettings *settings = [SZUserUtils currentUserSettings];
    
    // Share location should default to on (sense of option is wrong for historical reasons)
    BOOL dontShareLocation = [settings.dontShareLocation boolValue];
    GHAssertFalse(dontShareLocation, @"Should default to sharing location");
    
    GHAssertTrue([settings.dontPostToTwitter boolValue], @"Should not be posting to twitter");
    GHAssertTrue([settings.dontPostToFacebook boolValue], @"Should not be posting to facebook");
    GHAssertTrue([settings.autopostEnabled boolValue], @"autopost should be on");
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
