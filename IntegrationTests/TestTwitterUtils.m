//
//  TestSZTwitterUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestTwitterUtils.h"
#import "SZTestHelper.h"
#import <OCMock/NSObject+ClassMock.h>

@implementation TestTwitterUtils

- (void)testTwitterPost {
    //FIXME this doesn't work on command-line due to SSL/cert restrictions
    //NSURLConnection/CFURLConnection HTTP load failed (kCFStreamErrorDomainSSL, -9807)
    //this functionality is now covered in new UIIntegrationAcceptanceTests
    
//    UIViewController *dummyController = [[UIViewController alloc] init];
//    [[SZTestHelper sharedTestHelper] startMockingSucceededTwitterAuth];
//    
//    NSString *runID = [self runID];
//    NSDictionary *params = [NSDictionary dictionaryWithObject:runID forKey:@"status"];
//    NSLog(@"PARAMS: %@", [params description]);
//    
//    [self prepare];
//    [[SZTwitterUtils origClass] postWithViewController:dummyController
//                                                  path:@"/1.1/statuses/update.json"
//                                                params:params
//                                               success:^(id result) {
//         [self notify:kGHUnitWaitStatusSuccess];
//    }
//                                     failure:^(NSError *error) {
//         [self notify:kGHUnitWaitStatusFailure];
//    }];
//    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
//    
//    [[SZTestHelper sharedTestHelper] stopMockingSucceededTwitterAuth];
}

- (void)testTwitterGet {
    //FIXME this doesn't work on command-line due to SSL/cert restrictions
    //NSURLConnection/CFURLConnection HTTP load failed (kCFStreamErrorDomainSSL, -9807)
    //this functionality is now covered in new UIIntegrationAcceptanceTests
    
//    UIViewController *dummyController = [[UIViewController alloc] init];
//    [[SZTestHelper sharedTestHelper] startMockingSucceededTwitterAuth];
//    
//    [self prepare];
//    [[SZTwitterUtils origClass] getWithViewController:dummyController
//                                                 path:@"/1.1/statuses/user_timeline.json"
//                                               params:nil
//                                              success:^(id result) {
//        [self notify:kGHUnitWaitStatusSuccess];
//    }
//                                              failure:^(NSError *error) {
//        [self notify:kGHUnitWaitStatusFailure];
//    }];
//
//    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
//
//    [[SZTestHelper sharedTestHelper] stopMockingSucceededTwitterAuth];
}

@end
