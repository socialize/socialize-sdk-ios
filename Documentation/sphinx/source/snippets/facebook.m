//
//  facebook.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/29/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "facebook.h"

@implementation facebook

// begin-configure-snippet

//import the socialize header
#import <Socialize/Socialize.h>

#pragma mark
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    // set the socialize api key and secret, register your app here: http://www.getsocialize.com/apps/
    [Socialize storeConsumerKey:@"SOCIALIZE_CONSUMER_KEY"];
    [Socialize storeConsumerSecret:@"SOCIALIZE_CONSUMER_SECRET"];
    [SZFacebookUtils setAppId:@"YOUR FB APP ID"];
    
    //your application specific code
    
    return YES;
}

// end-configure-snippet

// begin-openurl-snippet
#import <Socialize/Socialize.h>

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [Socialize handleOpenURL:url];
}

// end-openurl-snippet


// begin-link-snippet

- (void)linkToFacebook {
    [SZFacebookUtils setAppId:@"fbMYFACEBOOKAPPID"];
    
    // The following is only needed if you have multiple apps sharing the same facebook app id
    [SZFacebookUtils setURLSchemeSuffix:@"myfreeversion"];
    
    // Don't forget to add the fbMYFACEBOOKAPPIDmyfreeversion:// URL Scheme to your app, as above
    
    // These should come from your own facebook auth process
    NSString *existingToken = @"EXISTING_TOKEN";
    NSDate *existingExpiration = [NSDate distantFuture];
    
    [SZFacebookUtils linkWithAccessToken:existingToken expirationDate:existingExpiration success:^(id<SocializeFullUser> user) {
        NSLog(@"Link successful");
    } failure:^(NSError *error) {
        NSLog(@"Link failed: %@", [error localizedDescription]);
    }];
}

// end-link-snippet

@end
