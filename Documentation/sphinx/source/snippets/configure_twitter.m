@interface ConfigureTwitter
@end

@implementation ConfigureTwitter

// begin-snippet

//import the socialize header
#import <Socialize/Socialize.h>

#pragma mark
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    // set the socialize api key and secret, register your app here: http://www.getsocialize.com/apps/
    [Socialize storeConsumerKey:@"SOCIALIZE_CONSUMER_KEY"];
    [Socialize storeConsumerSecret:@"SOCIALIZE_CONSUMER_SECRET"];
    [Socialize storeTwitterConsumerKey:@"YOUR_TWITTER_CONSUMER_KEY"];
    [Socialize storeTwitterConsumerSecret:@"YOUR_TWITTER_CONSUMER_SECRET"];    
    //your application specific code
    
    return YES;
}

// end-snippet

@end
