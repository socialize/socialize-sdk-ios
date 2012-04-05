//
//  SocializeAppDelegate.h
//  IntegrationTests
//
//  Created by Nathaniel Griswold on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GHUnitIOS/GHUnit.h>
#import "IntegrationTestStatusViewControllerViewController.h"

@interface IntegrationTestsAppDelegate : GHUnitIOSAppDelegate <UIApplicationDelegate, GHTestRunnerDelegate>;

@property (nonatomic, retain) NSData *origToken;
@property (nonatomic, retain) IntegrationTestStatusViewControllerViewController *status;

+ (NSData*)origToken;

@end
