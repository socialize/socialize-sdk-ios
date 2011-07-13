//
//  SampleSdkAppAppDelegate.m
//  SampleSdkApp
//
//  Created by Sergey Popenko on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SampleSdkAppAppDelegate.h"
#import "Socialize.h"
#import "SocializeLike.h"

//static NSString* kAppId = @"115622641859087";

@implementation SampleSdkAppAppDelegate


@synthesize window=_window;
@synthesize authenticationViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    authenticationViewController = [[AuthenticateViewController alloc] initWithNibName:@"AuthenticateViewController" bundle:nil];
    rootController = [[UINavigationController alloc] initWithRootViewController:authenticationViewController];

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

- (void)applicationWillTerminate:(UIApplication *)application
{

}

- (void)dealloc
{
    [rootController  release];
    [authenticationViewController release];
    [_window release];
    [super dealloc];
}


@end
