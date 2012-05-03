//
//  TestTabbedSZActionBar.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/18/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GenericViewController.h"
#import <Socialize/Socialize.h>

@interface TestTabbedSZActionBar : UIViewController

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet GenericViewController *generic1;
@property (nonatomic, retain) IBOutlet GenericViewController *generic2;
@property (nonatomic, retain) IBOutlet SZActionBar *actionBar;

@property (nonatomic, copy) NSString *entityUrl;

@end
