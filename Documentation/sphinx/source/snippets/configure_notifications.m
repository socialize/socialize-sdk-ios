@interface ConfigureNotifications
@end

@implementation ConfigureNotifications

// begin-snippet

//import the socialize header
#import <Socialize/Socialize.h>

#pragma mark
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    
    // Register for Apple Push Notification Service
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
    //your application specific code
    
    return YES;
}

// end-snippet

// begin-register-snippet

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken
{
#if !DEBUG
    [SZSmartAlertUtils registerDeviceToken:deviceToken];
#endif
}

// end-register-snippet

// begin-register-fail-snippet

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Error Register Notifications: %@", [error localizedDescription]);
}

// end-register-fail-snippet

@end

@implementation ConfigureNotifications (HandleNotifications)

// begin-handle-snippet

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Handle Socialize notification at foreground
    if ([SZSmartAlertUtils handleNotification:userInfo]) {
        NSLog(@"Socialize handled the notification on foreground");
        return;
    }
    
    NSLog(@"Socialize did not handle the notification on foreground");
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {

    // ...

    // Register for Apple Push Notification Service
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];

    // Handle Socialize notification at launch
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        if ([SZSmartAlertUtils handleNotification:userInfo]) {
            NSLog(@"Socialize handled the notification on app launch.");
        } else {
            NSLog(@"Socialize did not handle the notification on app launch.");
        }
    }
    
    //your application specific code
    
    return YES;
}

// end-handle-snippet

@end


@implementation ConfigureNotifications (EntityLoader)

// begin-entity-loader-snippet

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    
    // ...
    
    // Register for Apple Push Notification Service
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];

    // Handle Socialize notification at launch
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        if ([SZSmartAlertUtils handleNotification:userInfo]) {
            NSLog(@"Socialize handled the notification on app launch.");
        } else {
            NSLog(@"Socialize did not handle the notification on app launch.");
        }
    }

    // Specify a Socialize entity loader block
    [Socialize setEntityLoaderBlock:^(UINavigationController *navigationController, id<SocializeEntity>entity) {
        SampleEntityLoader *entityLoader = [[[SampleEntityLoader alloc] initWithEntity:entity] autorelease];
        [navigationController pushViewController:entityLoader animated:YES];
    }];
    
    return YES;
}

// end-entity-loader-snippet

@end

@implementation ConfigureNotifications (CanLoadEntity)

// begin-can-load-entity-snippet

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    
    // ...

    [Socialize setCanLoadEntityBlock:^BOOL(id<SocializeEntity> entity) {
        return ![entity.name isEqualToString:@"DeletedEntity"];
    }];
    
    return YES;
}

// end-can-load-entity-snippet

@end


