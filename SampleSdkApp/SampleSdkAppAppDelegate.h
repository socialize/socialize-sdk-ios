//
//  SampleSdkAppAppDelegate.h
//  SampleSdkApp
//
//  Created by Sergey Popenko on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticateViewController.h"
#import "SocializeCommonDefinitions.h"
#import "Socialize.h"

@interface SampleSdkAppAppDelegate : NSObject <UIApplicationDelegate> {
@private
    UINavigationController*         rootController;
    AuthenticateViewController*     authenticationViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AuthenticateViewController *authenticationViewController;

@end
