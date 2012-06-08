//
//  TestSZFacebookUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestFacebookUtils.h"
#import "SZFacebookUtils.h"
#import "SZTestHelper.h"

@implementation TestFacebookUtils

- (void)testLink {
    NSString *accessToken = [[SZTestHelper sharedTestHelper] facebookAccessToken];
    
    [self prepare];
    [SZFacebookUtils linkWithAccessToken:accessToken expirationDate:[NSDate distantFuture] success:^(id<SZFullUser> fullUser) {
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];        
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
}

@end
