//
//  SocializeRichPushNotificationViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/27/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeRichPushNotificationViewController.h"
#import <SZBlocksKit/BlocksKit.h>
#import "StringHelper.h"

@interface SocializeRichPushNotificationViewController ()
@property (nonatomic, assign) BOOL initialized;
@end

@implementation SocializeRichPushNotificationViewController
@synthesize webView = webView_;
@synthesize url = url_;
@synthesize initialized = initialized_;

- (void)dealloc {
    self.webView.delegate = nil;
    self.webView = nil;
    self.url = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.webView.delegate = self;
    
}

- (void)initialize {
    if (!self.initialized) {
        NSURL *url = [NSURL URLWithString:self.url];
        
        if ([[url scheme] length] == 0) {
            url = [NSURL URLWithString:[@"http://" stringByAppendingString:self.url]];
        }

        [self startLoading];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        
        self.initialized = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initialize];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stopLoading];
}

- (BOOL)isOwnURL:(NSURL*)url {
    NSURL *ownURL = [NSURL URLWithString:self.url];
    
    return [[ownURL host] isEqualToString:[url host]]
        && [[ownURL path] isEqualToString:[url path]]
        && [[ownURL query] isEqualToString:[url query]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self stopLoading];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *requestURL = [request URL];
    if (![[requestURL scheme] startsWith:@"http"] && [[UIApplication sharedApplication] canOpenURL:[request URL]]) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        
        if ([self isOwnURL:[request URL]]) {
            [self notifyDelegateOfCompletion];
        }
        
        return NO;
    }
    return YES;
}

@end
