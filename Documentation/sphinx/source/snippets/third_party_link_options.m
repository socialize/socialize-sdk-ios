
//import the Socialize header
#import <Socialize/Socialize.h>

@interface ThirdPartyLinkOptions
@end

@implementation ThirdPartyLinkOptions

// begin-snippet

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // User can opt out of third party linking (default NO)
    [Socialize storeAnonymousAllowed:YES];
    
    // User is not shown third party link dialog on Social Actions (default NO)
    [Socialize storeAuthenticationNotRequired:YES];
    
    return YES;
}

// end-snippet

@end
