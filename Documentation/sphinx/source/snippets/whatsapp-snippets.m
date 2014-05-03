//
//  whatsapp-snippets.m
//  Socialize
//
//  Created by David Jedeikin on 4/15/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import "whatsapp-snippets.h"

#import <Socialize/Socialize.h>

@implementation whatsapp_snippets

// begin-configure-snippet

#pragma mark
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    // set the socialize api key and secret, register your app here: http://www.getsocialize.com/apps/
    [Socialize storeConsumerKey:@"SOCIALIZE_CONSUMER_KEY"];
    [Socialize storeConsumerSecret:@"SOCIALIZE_CONSUMER_SECRET"];
    [SZWhatsAppUtils setShowInShare:YES];
    
    //your application specific code
    
    return YES;
}

// end-configure-snippet

// begin-share-snippet

- (void)shareOnWhatsApp {
    SZEntity* entity = [SZEntity entityWithKey:@"http://cs303404.vk.me/v303404440/1ae3/ZkKQLEFGeyY.jpg" name:@"Something"];
    
    if ([SZWhatsAppUtils isAvailable]) {
        [SZWhatsAppUtils shareViaWhatsAppWithViewController:self options:nil entity:entity success:^(id<SocializeShare> share) {
            //your application specific code on success action
        } failure:^(NSError *error) {
            //your application specific code on failure action
        }];
    }
}

// end-share-snippet

@end
