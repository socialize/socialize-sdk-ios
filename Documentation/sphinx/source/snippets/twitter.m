//
//  twitter.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/29/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "twitter.h"

@implementation twitter

// begin-configure-snippet

//import the socialize header
#import <Socialize/Socialize.h>

#pragma mark
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    // set the socialize api key and secret, register your app here: http://www.getsocialize.com/apps/
    [Socialize storeConsumerKey:@"SOCIALIZE_CONSUMER_KEY"];
    [Socialize storeConsumerSecret:@"SOCIALIZE_CONSUMER_SECRET"];
    [SZTwitterUtils setConsumerKey:@"YOUR_TWITTER_CONSUMER_KEY" consumerSecret:@"YOUR_TWITTER_CONSUMER_SECRET"];
    //your application specific code
    
    return YES;
}

// end-configure-snippet

// begin-link-snippet

- (void)linkToTwitter {
    [SZTwitterUtils setConsumerKey:@"MYAPPCONSUMERKEY" consumerSecret:@"MYAPPCONSUMERSECRET"];
    
    NSString *existingAccessToken = @"PREAUTHEDACCESSTOKEN";
    NSString *existingSecret = @"PREAUTHEDACCESSTOKENSECRET";
    
    [SZTwitterUtils linkWithAccessToken:existingAccessToken accessTokenSecret:existingSecret success:^(id<SocializeFullUser> user) {
        NSLog(@"Link Complete");
    } failure:^(NSError *error) {
        NSLog(@"Link failure: %@", [error localizedDescription]);
    }];
}

// end-link-snippet

// begin-post-snippet

- (void)postToTwitter {
    NSString *text = @"The Status";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:text forKey:@"status"];

    [SZTwitterUtils postWithViewController:self path:@"/1/statuses/update.json" params:params success:^(id result) {
        NSLog(@"Posted to Twitter feed: %@", result);

    } failure:^(NSError *error) {
        NSLog(@"Failed to post to Twitter feed: %@ / %@", [error localizedDescription], [error userInfo]);
    }];

}

// end-post-snippet
@end
