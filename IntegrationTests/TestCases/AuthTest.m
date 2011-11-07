//
//  SomeTest.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 9/20/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Socialize/Socialize.h>
#import "AuthTest.h"
@implementation AuthTest


-(void)testAuthentication; {
    
    Socialize *_service = [[Socialize alloc] initWithDelegate:self];
    // The application uses garbage collection, so no autorelease pool is needed.
    // Wait for notify
    [self prepare];
    [_service authenticateWithApiKey:@"976421bd-0bc9-44c8-a170-bd12376123a3" apiSecret:@"2bf36ced-b9ab-4c5b-b054-8ca975d39c14"];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
    
}
 
// Wait for notify
- (void)service:(SocializeService *)request didFail:(NSError *)error {
    NSLog(@"Error happened during auth: %@", [error description]);
}

-(void)didAuthenticate:(id<SocializeUser>)user {
    NSAssert( [user thirdPartyAuth] != nil, @"Third party auth is nil");
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testAuthentication)];
}

@end
