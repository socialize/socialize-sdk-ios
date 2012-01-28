//
//  SocializeRichPushNotificationViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/27/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeRichPushNotificationViewController.h"
#import "UIWebView+BlocksKit.h"

@implementation SocializeRichPushNotificationViewController
@synthesize webView = webView_;
@synthesize url = url_;

- (void)dealloc {
    self.webView = nil;
    self.url = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.title length] == 0) {
        self.title = @"Hey You!";
    }
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.webView.didFinishLoadBlock = ^{
        [self stopLoading];
    };
    
    self.webView.didFinishWithErrorBlock = ^(NSError* error) {
        [self stopLoading];        
    };
    
    [self startLoading];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

@end
