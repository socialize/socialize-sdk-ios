
//
//  SampleSdkAppAppDelegate.m
//  SampleSdkApp
//
//  Created by Sergey Popenko on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SampleSdkAppAppDelegate.h"
#import <Socialize/Socialize.h>
#import "TestListController.h"
#include <AvailabilityMacros.h>
#import "SampleEntityLoader.h"

#if RUN_GHUNIT_TESTS
#import <GHUnitIOS/GHUnit.h>
#endif

#if RUN_KIF_TESTS
#import "SampleSdkAppKIFTestController.h"
#endif

//#import "SocializeLike.h"

@implementation SampleSdkAppAppDelegate


@synthesize window=_window, rootController;

+ (id)sharedDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{  
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];  

    UIViewController* rootViewController = nil;
       
    // we check the authentication here.
    rootViewController = [[[AuthenticateViewController alloc] initWithNibName:@"AuthenticateViewController" bundle:nil] autorelease];
 
    rootController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self.window addSubview:rootController.view];
    [self.window makeKeyAndVisible];
    
#if RUN_KIF_TESTS
    [[SampleSdkAppKIFTestController sharedInstance] startTestingWithCompletionBlock:^{
        // Exit after the tests complete so that CI knows we're done
        int failureCount = [[SampleSdkAppKIFTestController sharedInstance] failureCount];
        if (getenv("RUN_CLI")) {
            NSLog(@"Exiting with %i failures", failureCount);
            exit(failureCount);
        }
    }];
#endif

    [Socialize setEntityLoaderBlock:^(UINavigationController *navigationController, id<SocializeEntity>entity) {
        SampleEntityLoader *entityLoader = [[[SampleEntityLoader alloc] initWithEntity:entity] autorelease];
        [navigationController pushViewController:entityLoader animated:YES];
    }];

    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"kSocializeDeviceTokenRegisteredKey"];
    char testTokenData[32] = "\xaa\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff";
    NSData *testToken = [NSData dataWithBytes:&testTokenData length:sizeof(testTokenData)];
    [Socialize registerDeviceToken:testToken];
    
//    [Socialize setEntityLoaderBlock:nil];
    
    [Socialize storeTwitterConsumerKey:@"ZWxJ0zIK73n5HKwGLHolQ"];
    [Socialize storeTwitterConsumerSecret:@"3K1LTY39QM9DPAqJzSZAD3L2EBEXXvuCdtTRr8NDd8"];
//    [Socialize storeTwitterAccessToken:@"blah"];
//    [Socialize storeTwitterAccessTokenSecret:@"blah"];

    [Socialize storeUIErrorAlertsDisabled:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorNotification:) name:SocializeUIControllerDidFailWithErrorNotification object:nil];
    
    return YES;
}

- (void)errorNotification:(NSNotification*)notification {
    NSError *error = [[notification userInfo] objectForKey:SocializeUIControllerErrorUserInfoKey];
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken
{  
    NSLog(@"registering device token");
    
    // Nil out the device token. Normally, this wouldn't be required, but sometimes we switch between servers
//    [Socialize storeDeviceToken:nil];
    
    [Socialize registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication*)application  
didFailToRegisterForRemoteNotificationsWithError:(NSError*)error  
{  
    NSLog(@"Error Register Notifications: %@", [error localizedDescription]);
}  

- (void)applicationWillTerminate:(UIApplication *)application
{

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {    
    return [Socialize handleOpenURL:url];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([Socialize handleNotification:userInfo]) {
        return;
    }
    
    // Nonsocialize notification handling goes here
}

- (void)dealloc
{
    [rootController  release];
    [_window release];
    [super dealloc];
}

@end
