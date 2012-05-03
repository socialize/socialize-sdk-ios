#import "link_to_twitter.h"

// begin-snippet

@implementation LinkToTwitterExample
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

- (void)linkToTwitter {
    [Socialize storeTwitterConsumerKey:@"MYAPPCONSUMERKEY"];
    [Socialize storeTwitterConsumerSecret:@"MYAPPCONSUMERSECRET"];
    
    [self.socialize linkToTwitterWithAccessToken:@"PREAUTHEDACCESSTOKEN" accessTokenSecret:@"PREAUTHEDACCESSTOKENSECRET"];
}

- (void)didAuthenticate:(id<SocializeUser>)user {
    if ([self.socialize isAuthenticatedWithTwitter]) {
        NSLog(@"Twit Tah! %@", [user thirdPartyAuth]);
    } else {
        NSLog(@"Not authenticated with Twitter");
    }
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    NSLog(@"All is not well: %@", [error localizedDescription]);
}

// end-snippet

@end
