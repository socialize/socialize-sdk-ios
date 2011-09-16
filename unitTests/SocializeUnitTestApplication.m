//
//  SocializeUnitTestApplication.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 9/13/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeUnitTestApplication.h"
#import <GHUnitIOS/GHUnitIPhoneViewController.h>
#import <GHUnitIOS/GHTestSuite.h>
#import <objc/runtime.h>

@implementation SocializeUnitTestApplication



- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [super applicationDidFinishLaunching:application];
    if (getenv("GHUNIT_UI_CLI")) {

        printf("starting tests\n");
        //have to close STDERR and redirect to STDOUT so it gets redirected to console
        close(2);
        dup(1);
        
        GHTestSuite *suite_ = [GHTestSuite suiteFromEnv];
        GHTestRunner *runner_ = [[GHTestRunner runnerForSuite:suite_] retain];
        runner_.delegate = self;
        runner_.options = 0;
        [runner_ setInParallel:NO];
        [runner_ runTests];
        printf("test failures: %d\n", runner_.stats.failureCount);
        exit(1);
                
    }
    
}


@end
