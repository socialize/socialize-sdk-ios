//
//  pinterest-snippets.m
//  Socialize
//
//  Created by Sergey Popenko on 6/30/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "pinterest-snippets.h"

#import <Socialize/Socialize.h>

@implementation pinterest_snippets

// begin-configure-snippet

#pragma mark
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    // set the socialize api key and secret, register your app here: http://www.getsocialize.com/apps/
    [Socialize storeConsumerKey:@"SOCIALIZE_CONSUMER_KEY"];
    [Socialize storeConsumerSecret:@"SOCIALIZE_CONSUMER_SECRET"];
    [SZPinterestUtils setApplicationId:@"YOUR PINTEREST APP ID"];
    
    //your application specific code
    
    return YES;
}

// end-configure-snippet

// begin-share-snippet

- (void)shareOnPinterest
{
    SZEntity* entity = [SZEntity entityWithKey:@"http://cs303404.vk.me/v303404440/1ae3/ZkKQLEFGeyY.jpg" name:@"Something"];
    
    if ([SZPinterestUtils isAvailable])
    {
        [SZPinterestUtils shareViaPinterestWithViewController:self options:nil entity:entity success:^(id<SocializeShare> share) {
            //your application specific code on success action
        } failure:^(NSError *error) {
            //your application specific code on failure action
        }];
    }
}

// end-share-snippet

@end
