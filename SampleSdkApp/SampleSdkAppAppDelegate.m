//
//  SampleSdkAppAppDelegate.m
//  SampleSdkApp
//
//  Created by Sergey Popenko on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SampleSdkAppAppDelegate.h"
#import "DemoEntity.h"
#import "Socialize.h"
#import "SocializeLike.h"

// Your Facebook APP Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
// Also, your application must bind to the fb[app_id]:// URL
// scheme (substitue [app_id] for your real Facebook app id).
static NSString* kAppId = @"115622641859087";

@implementation SampleSdkAppAppDelegate


@synthesize window=_window;
@synthesize entityListViewController;
@synthesize facebook;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    socialize = [[Socialize alloc] init];  
    facebook = [[Facebook alloc] initWithAppId:kAppId];

    entityListViewController = [[EntityListViewController alloc] initWithStyle: UITableViewStylePlain andService: socialize];
    rootController = [[UINavigationController alloc] initWithRootViewController:entityListViewController];

    [self.window addSubview:rootController.view];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
    if([socialize isAuthenticated])
        return;
     
    [socialize authenticateWithApiKey:@"98e76bb9-c707-45a4-acf2-029cca3bf216" apiSecret:@"b7364905-cdc6-46d3-85ad-06516b128819" udid:@"someid" delegate:self];
    rootController.view.userInteractionEnabled = NO;
}

-(void)didAuthenticate
{
    rootController.view.userInteractionEnabled = YES;
}

-(void)didNotAuthenticate:(NSError*)error
{
    NSLog(@"%@", error);
    //entryController.view.userInteractionEnabled = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [rootController  release];
    [entityListViewController release];
    [_window release];
    [socialize release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url];
}

@end
