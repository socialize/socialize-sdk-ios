//
//  SocializeRichPushNotificationViewControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/27/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeRichPushNotificationViewControllerTests.h"

@implementation SocializeRichPushNotificationViewControllerTests
@synthesize richPushNotificationViewController;
@synthesize mockWebView = mockWebView_;

+ (SocializeBaseViewController*)createController {
    return [[[SocializeRichPushNotificationViewController alloc] init] autorelease];
}

- (void)tearDown {
    [super tearDown];
    [self.mockWebView verify];
    
    self.mockWebView = nil;
    self.richPushNotificationViewController = nil;
}

- (void)setUp {
    [super setUp];
    self.richPushNotificationViewController = (SocializeRichPushNotificationViewController*)self.viewController;
    
    self.mockWebView = [OCMockObject mockForClass:[UIWebView class]];
    self.richPushNotificationViewController.webView = self.mockWebView;
}
             
- (void)testViewDidLoad {
    [self.mockWebView makeNice];
    
    [[self.mockNavigationItem expect] setRightBarButtonItem:self.mockDoneButton];
    [self.richPushNotificationViewController viewDidLoad];
}

- (void)testLoadingItunesURL {
    NSString *itunesURL = @"http://itunes.apple.com/us/app/some-app/id123853140?ls=1&mt=8";
    NSString *itunesSchemeURLString = @"itms-apps://itunes.apple.com/us/app/some-app/id123853140?ls=1&mt=8";
    NSURL *itunesSchemeURL = [NSURL URLWithString:itunesSchemeURLString];
    
    // The main url for this controller is an iTunes one
    self.richPushNotificationViewController.url = itunesURL;
    id mockRequest = [OCMockObject mockForClass:[NSURLRequest class]];
    [[[mockRequest stub] andReturn:itunesSchemeURL] URL];

    // Fake shared application that can open the iTunes URL
    id mockApplication = [OCMockObject mockForClass:[UIApplication class]];
    [[[mockApplication stub] andReturnBool:YES] canOpenURL:itunesSchemeURL];
    [UIApplication startMockingClass];
    [[[UIApplication stub] andReturn:mockApplication] sharedApplication];

    // URL Should open in fake shared application
    [[mockApplication expect] openURL:itunesSchemeURL];
    
    // Should dismiss itself after loading store URL
    [[self.mockDelegate expect] baseViewControllerDidFinish:OCMOCK_ANY];
    
    // Ask the web view delegate if it can load the itunes scheme (the scheme autoadjusts to itms-apps)
    BOOL shouldLoad = [self.richPushNotificationViewController webView:nil shouldStartLoadWithRequest:mockRequest navigationType:UIWebViewNavigationTypeOther];
    
    [UIApplication stopMockingClassAndVerify];
    
    GHAssertFalse(shouldLoad, @"Should not load");
}

- (void)testLoadingSchemalessURL {
    self.richPushNotificationViewController.url = @"www.google.com";

    [[[self.mockWebView expect] andDo1:^(NSURLRequest *request) {
        NSURL *url = [request URL];
        
        GHAssertEqualStrings([url scheme], @"http", @"bad scheme");
        GHAssertEqualStrings([url host], @"www.google.com", @"bad host");
        
    }] loadRequest:OCMOCK_ANY];
    
    [self.richPushNotificationViewController viewDidAppear:YES];
}

@end
