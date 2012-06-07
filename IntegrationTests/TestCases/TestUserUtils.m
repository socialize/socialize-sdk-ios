//
//  TestSZUserUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestUserUtils.h"
#import "SZUserUtils.h"

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

@end
