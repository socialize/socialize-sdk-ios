//
//  SocializeRichPushNotificationDisplayController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/27/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeRichPushNotificationDisplayController.h"
#import "UINavigationController+Socialize.h"

@implementation SocializeRichPushNotificationDisplayController
@synthesize navigationController = navigationController_;

- (UINavigationController*)navigationController {
    if (navigationController_ == nil) {
        SocializeRichPushNotificationViewController *viewController = [[[SocializeRichPushNotificationViewController alloc] initWithNibName:@"SocializeRichPushNotificationViewController" bundle:nil] autorelease];
        NSDictionary *socializeInfo = [self.userInfo objectForKey:@"socialize"];
        viewController.title = [socializeInfo objectForKey:@"title"];
        viewController.delegate = self;
        viewController.url = [socializeInfo objectForKey:@"url"];
        navigationController_ = [[UINavigationController socializeNavigationControllerWithRootViewController:viewController] retain];
        
    }
    return navigationController_;
}

- (UIViewController*)mainViewController {
    return self.navigationController;
}

- (void)baseViewControllerDidFinish:(SocializeBaseViewController *)baseViewController {
    [self.delegate notificationDisplayControllerDidFinish:self];
}

@end
