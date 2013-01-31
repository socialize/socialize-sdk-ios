//import the socialize header
#import <Socialize/Socialize.h>

@interface DisableErrorAlerts : NSObject
@end

@implementation DisableErrorAlerts

// begin-snippet

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Socialize storeUIErrorAlertsDisabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorNotification:) name:SocializeUIControllerDidFailWithErrorNotification object:nil];
    
    return YES;
}

- (void)errorNotification:(NSNotification*)notification {
    NSError *error = [[notification userInfo] objectForKey:SocializeUIControllerErrorUserInfoKey];
    NSLog(@"Error: %@", [error localizedDescription]);
}

// end-snippet

@end
