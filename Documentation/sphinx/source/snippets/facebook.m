//
//  facebook.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/29/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//


//import the socialize header
#import <Socialize/Socialize.h>

#import "facebook.h"

@implementation facebook

// begin-configure-snippet

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

// begin-post-to-feed-snippet

- (void)postToFacebookFeed {
    NSMutableDictionary *postData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"hi there", @"message",
                                     nil];
    
    [SZFacebookUtils postWithGraphPath:@"me/feed" params:postData success:^(id post) {
        NSLog(@"Posted %@!", post);
    } failure:^(NSError *error) {
        NSLog(@"Facebook post failed: %@, %@", [error localizedDescription], [error userInfo]);
    }];
}

// end-post-to-feed-snippet

// begin-post-image-snippet

- (void)postImageToFacebook {
    UIImage *logo = [UIImage imageNamed:@"socialize_logo.png"];
    NSData *logoData = UIImagePNGRepresentation(logo);

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:logoData forKey:@"source"];
    [params setObject:@"Socialize" forKey:@"caption"];
    [SZFacebookUtils postWithGraphPath:@"me/photos" params:params success:^(id info) {
        NSLog(@"Created post: %@", info);
    } failure:^(NSError *error) {
        NSLog(@"Failed to post: %@", [error localizedDescription]);
    }];
}

// end-post-image-snippet

// begin-set-entity-type-snippet

- (void)createEntityWithType {
    SZEntity *entity = [SZEntity entityWithKey:@"http://myentity.com" name:@"My Name"];
    
    // MUST be a valid OG type
    [entity setType:@"video.movie"];
}

// end-set-entity-type-snippet

@end

@implementation facebook (oglikes)

// begin-enable-og-likes-snippet

//import the socialize header
#import <Socialize/Socialize.h>

#pragma mark
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    [Socialize storeOGLikeEnabled:YES];
    
    //your application specific code
    
    return YES;
}

// end-enable-og-likes-snippet



@end