//
//  SampleSdkAppAppDelegate.h
//  SampleSdkApp
//
//  Created by Sergey Popenko on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityListViewController.h"
#import "SocializeCommonDefinitions.h"
#import "Socialize.h"
#import "Facebook.h"

@interface SampleSdkAppAppDelegate : NSObject <UIApplicationDelegate, SocializeAuthenticationDelegate, FBSessionDelegate> {
@private
    Socialize*           socialize;
    Facebook *           facebook;
    UINavigationController* rootController;
    EntityListViewController* entityListViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) EntityListViewController* entityListViewController;
@property (nonatomic, retain) Facebook* facebook;

@end
