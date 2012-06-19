//
//  SocializeDataFetcher.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/13/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeDataFetcher.h"


#define kTRUSTED_HOST @""
const BOOL shouldAllowSelfSignedCert = YES;


@implementation SocializeDataFetcher
@synthesize trustedHosts = _trustedHosts;

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
	
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        if ([self.trustedHosts containsObject:challenge.protectionSpace.host])
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
 
  
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

/*- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)space {
    if([[space authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if(shouldAllowSelf SignedCert) {
            return YES; // Self-signed cert will be accepted
        } else {
            return NO;  // Self-signed cert will be rejected
        }
        // Note: it doesn't seem to matter what you return for a proper SSL cert
        //       only self-signed certs
    }
    // If no other authentication is required, return NO for everything else
    // Otherwise maybe YES for NSURLAuthenticationMethodDefault and etc.
    return NO;
}
*/
-(void)dealloc{
    self.trustedHosts = nil;
    [super dealloc];
}
@end
