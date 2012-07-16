//
//  SZAppDelegate.m
//  TestApp
//
//  Created by Nathaniel Griswold on 6/16/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZTestAppDelegate.h"
#import "TestAppListViewController.h"
#import <Socialize/Socialize.h>

#if RUN_KIF_TESTS
#import "TestAppKIFTestController.h"
#import "SZTestHelper.h"
#endif

@implementation SZTestAppDelegate
@synthesize window = window_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [Socialize storeAnonymousAllowed:YES];
    [Socialize storeConsumerKey:@"0a3bc7cd-c269-4587-8687-cd02db56d57f"];
    [Socialize storeConsumerSecret:@"8ee55515-4f1f-42ea-b25e-c4eddebf6c02"];
    [SZTwitterUtils setConsumerKey:@"ZWxJ0zIK73n5HKwGLHolQ" consumerSecret:@"3K1LTY39QM9DPAqJzSZAD3L2EBEXXvuCdtTRr8NDd8"];
    [SZFacebookUtils setAppId:@"115622641859087"];
    
//     char testTokenData[32] = "\xaa\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff";
//     NSData *testToken = [NSData dataWithBytes:&testTokenData length:sizeof(testTokenData)];
//     [Socialize registerDeviceToken:testToken];
    
    [Socialize setEntityLoaderBlock:^(UINavigationController *nav, id<SZEntity> entity) {
        SampleEntityLoader *sample = [[SampleEntityLoader alloc] initWithEntity:entity];
        [nav pushViewController:sample animated:YES];
    }];
     
    TestAppListViewController *sample = [TestAppListViewController sharedSampleListViewController];
    self.window.rootViewController = sample;
    [self.window makeKeyAndVisible];

#if RUN_KIF_TESTS
    [[SZTestHelper sharedTestHelper] startMockingSucceedingLocation];
    [[TestAppKIFTestController sharedInstance] startTestingWithCompletionBlock:^{
        // Exit after the tests complete so that CI knows we're done
        [[SZTestHelper sharedTestHelper] stopMockingSucceedingLocation];
        int failureCount = [[TestAppKIFTestController sharedInstance] failureCount];
        if (getenv("RUN_CLI")) {
            NSLog(@"Exiting with %i failures", failureCount);
            exit(failureCount);
        }
    }];
#endif
    BOOL dev  = SZIsProduction();
    (void)dev;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [Socialize handleOpenURL:url];
}

@end
