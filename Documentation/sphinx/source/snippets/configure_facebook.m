@interface ConfigureFacebook
@end

@implementation ConfigureFacebook

// begin-snippet

//import the socialize header
#import <Socialize/Socialize.h>

#pragma mark
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    // set the socialize api key and secret, register your app here: http://www.getsocialize.com/apps/
    [Socialize storeConsumerKey:@"SOCIALIZE_CONSUMER_KEY"];
    [Socialize storeConsumerSecret:@"SOCIALIZE_CONSUMER_SECRET"];
    [Socialize storeFacebookAppId:@"YOUR FB APP ID"];
    
    //your application specific code
    
    return YES;
}

// end-snippet

// begin-openurl-snippet
#import <Socialize/Socialize.h>

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [Socialize handleOpenURL:url];
}

// end-openurl-snippet

@end
