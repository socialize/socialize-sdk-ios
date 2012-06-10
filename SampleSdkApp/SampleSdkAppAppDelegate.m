
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
#import "SampleListViewController.h"

#if RUN_GHUNIT_TESTS
#import <GHUnitIOS/GHUnit.h>
#endif

#import <dlfcn.h>

#if RUN_KIF_TESTS
#import "SampleSdkAppKIFTestController.h"
#endif

//#import "SocializeLike.h"

@implementation SampleSdkAppAppDelegate


@synthesize window=_window, rootController;
@synthesize globalEntity = globalEntity_;
@synthesize sampleListViewController = sampleListViewController;

+ (id)sharedDelegate {
    return [[UIApplication sharedApplication] delegate];
}

#import "SocializeLocationManager.h"

-(NSDictionary*)authInfoFromConfig
{
    NSBundle * bundle =  [NSBundle bundleForClass:[self class]];
    NSString * configPath = [bundle pathForResource:@"SocializeApiInfo" ofType:@"plist"];
    NSDictionary * configurationDictionary = [[[NSDictionary alloc]initWithContentsOfFile:configPath] autorelease];
    return  [configurationDictionary objectForKey:@"Socialize API info"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{  
    NSString *consumerKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"socialize_api_key"];
    NSLog(@"Consumer key is %@", consumerKey);
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];  

    self.sampleListViewController = [[[SampleListViewController alloc] init] autorelease];
 
    rootController = [[UINavigationController alloc] initWithRootViewController:self.sampleListViewController];
    [self.window addSubview:rootController.view];
    [self.window makeKeyAndVisible];

    [Socialize storeAnonymousAllowed:YES];
    [Socialize storeAuthenticationNotRequired:NO];

    NSDictionary* apiInfo = [self authInfoFromConfig];
    [Socialize storeConsumerKey:[apiInfo objectForKey:@"key"]];
    [Socialize storeConsumerSecret:[apiInfo objectForKey:@"secret"]];
    
    [Socialize storeFacebookAppId:@"115622641859087"];
    
#if RUN_KIF_TESTS
    [Socialize storeFacebookLocalAppId:@"itest"];
#else
    [Socialize storeFacebookLocalAppId:nil];
#endif

    [Socialize setEntityLoaderBlock:^(UINavigationController *navigationController, id<SocializeEntity>entity) {
        SampleEntityLoader *entityLoader = [[[SampleEntityLoader alloc] initWithEntity:entity] autorelease];
        [navigationController pushViewController:entityLoader animated:YES];
    }];

    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"kSocializeDeviceTokenRegisteredKey"];
//    char testTokenData[32] = "\xaa\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff";
//    NSData *testToken = [NSData dataWithBytes:&testTokenData length:sizeof(testTokenData)];
//    [Socialize registerDeviceToken:testToken];
    
    [Socialize storeTwitterConsumerKey:@"ZWxJ0zIK73n5HKwGLHolQ"];
    [Socialize storeTwitterConsumerSecret:@"3K1LTY39QM9DPAqJzSZAD3L2EBEXXvuCdtTRr8NDd8"];

    [Socialize storeUIErrorAlertsDisabled:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorNotification:) name:SocializeUIControllerDidFailWithErrorNotification object:nil];
    
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

    return YES;
}

- (id<SZEntity>)globalEntity {
    if (globalEntity_ == nil) {
        globalEntity_ = [[SZEntity entityWithKey:@"samplesdkapp_test" name:@"SampleSdkApp Test Entity"] retain];
    }
    return globalEntity_;
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
