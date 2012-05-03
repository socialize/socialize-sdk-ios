#import "link_to_facebook.h"

// begin-snippet

@implementation LinkToFacebookExample
@synthesize socialize = socialize_;


- (void)dealloc {
    self.socialize = nil;
    
    [super dealloc];
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    return socialize_;
}

- (void)linkToFacebook {
    [Socialize storeFacebookAppId:@"fbMYFACEBOOKAPPID"];
    
    // The following is only needed if you have multiple apps sharing the same facebook app id
    // [Socialize storeFacebookURLSchemeSuffix:@"myfreeapp"];
    
    [self.socialize linkToFacebookWithAccessToken:@"EXISTING_TOKEN" expirationDate:[NSDate distantFuture]];
}

- (void)didAuthenticate:(id<SocializeUser>)user {
    if ([self.socialize isAuthenticatedWithFacebook]) {
        NSLog(@"Facebook link successful");
    }
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    NSLog(@"Error: %@", [error localizedDescription]);
}

// end-snippet

@end
