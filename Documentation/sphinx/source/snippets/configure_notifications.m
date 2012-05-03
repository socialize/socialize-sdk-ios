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
    [Socialize registerDeviceToken:deviceToken];
#endif
}

// end-register-snippet

// begin-register-fail-snippet

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Error Register Notifications: %@", [error localizedDescription]);
}

// end-register-fail-snippet

// begin-handle-snippet

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([Socialize handleNotification:userInfo]) {
        return;
    }
    // Nonsocialize notification handling goes here
}
@end

// end-handle-snippet


@implementation ConfigureNotifications (EntityLoader)

// begin-entity-loader-snippet

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    
    // ...
    
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
