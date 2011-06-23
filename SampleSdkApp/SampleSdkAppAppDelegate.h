//
//  SampleSdkAppAppDelegate.h
//  SampleSdkApp
//
//  Created by Sergey Popenko on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityViewController.h"
#import "SocializeCommonDefinitions.h"
#import "Socialize.h"

@interface SampleSdkAppAppDelegate : NSObject <UIApplicationDelegate, SocializeAuthenticationDelegate> {
@private
    EntityViewController* entryController;
    Socialize*           socialize;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) EntityViewController* entryController;

@end
