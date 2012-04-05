//
//  IntegrationTestStatusViewControllerViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GHUnitIOS/GHUnit.h>
#import <Socialize/Socialize.h>

@interface IntegrationTestStatusViewControllerViewController : UIViewController <GHTestRunnerDelegate, SocializeServiceDelegate>
@property (nonatomic, retain) GHTestRunner *testRunner;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSMutableArray *failedTests;
@end
