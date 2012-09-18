//
//  ui_advanced.m
//  Socialize
//
//  Created by Nathaniel Griswold on 8/23/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "ui_advanced.h"
#import <Socialize/Socialize.h>

@interface ui_advanced ()
@property (nonatomic, strong) UIWindow *window;
@end

@implementation ui_advanced

// begin-disable-location-snippet

- (void)disableLocationSharing {
    [Socialize storeLocationSharingDisabled:YES];
}

// end-disable-location-snippet

// begin-define-global-display-snippet

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // ...
    
    // This example assumes a custom view controller is set as the window's rootViewController property as part of application startup

    [SZDisplayUtils setGlobalDisplayBlock:^id<SZDisplay>{
        UIViewController *controller = self.window.rootViewController;
        while (controller.presentedViewController != nil) {
            controller = controller.presentedViewController;
        }
        return controller;
    }];
    
    // ...
    
    return YES;
}


// end-define-global-display-snippet

@end
