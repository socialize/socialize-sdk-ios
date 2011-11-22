//
//  TestFacebookInterface.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/8/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "TestFacebookInterface.h"

@implementation TestFacebookInterface
@synthesize facebookInterface = facebookInterface_;

- (void)setUp {
    [super setUp];
    
    self.facebookInterface = [[[SocializeFacebookInterface alloc] init] autorelease];
}

- (void)tearDown {
    [super tearDown];
    self.facebookInterface = nil;
}

#if 0
- (void)testPostToWall {
    [Socialize storeFacebookAppId:@"115622641859087"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"BAABpKH5ZBZBg8BANSQGGvcd7DGCxJvOU0S1QZCsF3ZBrmlMT9dZCrLGA5oQJ06njmIE1COAgjsmWDJsRwIig30jbhPZCArmdBe4WgY9CZAL9OZBfs1JIQtAf8F0btxVc2baUJZCZBhpgk3LQZDZD" forKey:@"FBAccessTokenKey"];
    [defaults setObject:[NSDate distantFuture] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];

    NSString *testURL = [NSString stringWithFormat:@"http://getsocialize.com/itest/%@/%s/", [self runID], _cmd];
    NSLog(@"POsting with link %@", testURL);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"hi there folks", @"message",
                            testURL, @"link",
                            nil];
    
    [self prepare];
    [self.facebookInterface requestWithGraphPath:@"me/feed" params:params httpMethod:@"POST" completion:^(id response, NSError *error) {
        if (error == nil) {
            NSLog(@"Posted comment with id %@!", [response objectForKey:@"id"]);
            [self notify:kGHUnitWaitStatusSuccess];
        } else {
            NSLog(@"Failed to post comment! %@", [error userInfo]);
            [self notify:kGHUnitWaitStatusFailure];
        }
    }]; 
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}
#endif

@end
