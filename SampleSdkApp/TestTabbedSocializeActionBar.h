//
//  TestTabbedSocializeActionBar.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/18/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TestSocializeActionBar.h"

@interface TestTabbedSocializeActionBar : UIViewController

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet TestSocializeActionBar *testSocializeActionBar;
@property (nonatomic, copy) NSString *entityUrl;

@end
