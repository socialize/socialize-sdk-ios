//
//  SocializeTwitterAuthViewControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeTwitterAuthViewControllerTests.h"
#import "OAMutableURLRequest.h"
#import "OAuthConsumer.h"
#import "NSArray+AssociativeArray.h"
#import "NSString+QueryString.h"

@interface SocializeTwitterAuthViewController ()
- (void)fetchDataWithRequest:(OAMutableURLRequest*)request didFinishSelector:(SEL)finish didFailSelector:(SEL)fail;
- (OAMutableURLRequest*)requestWithURL:(NSString*)urlString token:(OAToken*)token;
- (void)requestRequestToken:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;
- (void)requestRequestToken:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;

- (void)requestAccessToken:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;
- (void)requestAccessToken:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;

@end

@implementation SocializeTwitterAuthViewControllerTests
@synthesize twitterAuthViewController = twitterAuthViewController_;
@synthesize mockWebView = mockWebView_;
@synthesize mockDelegate = mockDelegate_;

+ (SocializeBaseViewController*)createController {
    SocializeTwitterAuthViewController *controller = [[[SocializeTwitterAuthViewController alloc] init] autorelease];
    
    return controller;
}

- (void)setUp {
    [super setUp];
    
    self.twitterAuthViewController = (SocializeTwitterAuthViewController*)self.viewController;
    
    // Set up mock web view
    self.mockWebView = [OCMockObject mockForClass:[UIWebView class]];
    [[self.mockWebView stub] setDelegate:nil];
    self.twitterAuthViewController.webView = self.mockWebView;
    
    self.mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeTwitterAuthViewControllerDelegate)];
    self.twitterAuthViewController.delegate = self.mockDelegate;
}

- (void)tearDown {
    [self.mockWebView verify];
    [self.mockDelegate verify];
    
    self.mockWebView = nil;
    self.mockDelegate = nil;
    self.twitterAuthViewController = nil;
    
    [super tearDown];
}

- (void)expectFetchDataWithRequestRequest:request
                         didFinishSelector:(SEL)didFinishSelector
                           didFailSelector:(SEL)didFailSelector {
    
}

- (id)expectAndGenerateMockForRequestWithURL:(NSString*)urlString token:(OAToken*)token {
    id mockRequest = [OCMockObject mockForClass:[OAMutableURLRequest class]];
    [[[(id)self.twitterAuthViewController expect] andReturn:mockRequest] requestWithURL:urlString token:token];
    
    return mockRequest;
}

- (void)expectRequestRequestToken {
    id mockRequest = [self expectAndGenerateMockForRequestWithURL:SocializeTwitterRequestTokenURL token:nil];
    
    // Should have oauth_callback set as a post parameter
    [[mockRequest expect] setOAuthParameterName:@"oauth_callback" withValue:OCMOCK_ANY];
    [[mockRequest expect] setHTTPMethod:@"POST"];
    
    [[(id)self.twitterAuthViewController expect]
     fetchDataWithRequest:mockRequest
     didFinishSelector:@selector(requestRequestToken:didFinishWithData:)
     didFailSelector:@selector(requestRequestToken:didFailWithError:)];

}

- (void)testViewDidLoadEvents {
    
    // Should get a title
    [[(id)self.twitterAuthViewController expect] setTitle:OCMOCK_ANY];
    
    // Cancel button should be left button
    [[self.mockNavigationItem expect] setLeftBarButtonItem:self.twitterAuthViewController.cancelButton];
    
    // Loading dialog should appear
    [[(id)self.twitterAuthViewController expect] startLoading];
    
    // Should try to get request token from server
    [self expectRequestRequestToken];
    
    [self.twitterAuthViewController viewDidLoad];
}

- (id)succeedingTicket {
    id mockTicket = [OCMockObject mockForClass:[OAServiceTicket class]];
    [[[mockTicket stub] andReturnBool:YES] didSucceed];
    return mockTicket;
}

- (NSData*)networkDataForString:(NSString*)string {
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)testReceivingRequestTokenOpensWebViewWithToken {
    NSString *testToken = @"abc";
    NSString *testTokenSecret = @"def";
    
    NSData *data = [self networkDataForString:[NSString stringWithFormat:@"oauth_token=%@&oauth_token_secret=%@&oauth_callback_confirmed=true", testToken, testTokenSecret]];
    id ticket = [self succeedingTicket];

    // Should open webview with query param
    [[self.mockWebView expect] loadRequest:[OCMArg checkWithBlock:^(NSURLRequest* request) {
        NSString *url = [[request URL] absoluteString];
        NSString *expectedURL = [NSString stringWithFormat:@"%@?oauth_token=%@", SocializeTwitterAuthenticateURL, testToken];
        return [url isEqualToString:expectedURL];
    }]];

    // Request token finished event
    [self.twitterAuthViewController requestRequestToken:ticket didFinishWithData:data];
     
    // Token and secret should be set up
    GHAssertEqualStrings(self.twitterAuthViewController.requestToken.key, testToken, nil);
    GHAssertEqualStrings(self.twitterAuthViewController.requestToken.secret, testTokenSecret, nil);
}

- (void)expectRequestAccessTokenWithVerifier:(NSString*)verifier token:(OAToken*)token { 
    
    // Should generate a request with the access url, and the request token (stored from earlier in the flow)
    id mockRequest = [self expectAndGenerateMockForRequestWithURL:SocializeTwitterAccessTokenURL token:token];
    
    // Should have oauth_callback set as a post parameter
    [[mockRequest expect] setHTTPMethod:@"POST"];
    
    // Should set body of request to have verifier
    NSString *expectedBody = [NSString stringWithFormat:@"oauth_verifier=%@", verifier];
    [[mockRequest expect] setHTTPBody:[expectedBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[(id)self.twitterAuthViewController expect]
     fetchDataWithRequest:mockRequest
     didFinishSelector:@selector(requestAccessToken:didFinishWithData:)
     didFailSelector:@selector(requestAccessToken:didFailWithError:)];    
}

- (void)testFinishingWebAuthSetsVerifierAndRequestsAccessToken {
    // Parameters that will be sent in the url request to the webview
    NSString *testVerifier = @"testVerifier";
    NSString *testTokenKey = @"testTokenKey";
    
    OAToken *testToken = [[[OAToken alloc] initWithKey:testTokenKey secret:@"xx"] autorelease];
    // Set a token that matches the test data
    self.twitterAuthViewController.requestToken = testToken;
    
    // Construct a url and request matching the internal scheme used by this controller
    NSString *testURLString = [NSString stringWithFormat:@"%@://sign-in-with-twitter?oauth_token=%@&oauth_verifier=%@", SocializeTwitterAuthCallbackScheme, testTokenKey, testVerifier];
    NSURL *testURL = [NSURL URLWithString:testURLString];
    NSURLRequest *req = [NSURLRequest requestWithURL:testURL];

    // Should fetch the access token
    [self expectRequestAccessTokenWithVerifier:testVerifier token:testToken];
    
    // Trigger the load event, as if loaded by a redirect in the UIWebView
    BOOL shouldStartLoad = [self.twitterAuthViewController webView:self.mockWebView shouldStartLoadWithRequest:req navigationType:UIWebViewNavigationTypeOther];
    
    // Should not become an actual page load
    GHAssertFalse(shouldStartLoad, @"should not load");
    
    // Controller should take on the verifier from the request parameters
    GHAssertEqualStrings(self.twitterAuthViewController.verifier, testVerifier, @"verifier should be set");
}

- (void)testBuildingRealRequest {
    NSString *testURL = @"testURL";
    OAToken *testToken = [[[OAToken alloc] initWithKey:@"testKey" secret:@"testSecret"] autorelease];
    
    OAMutableURLRequest *request = [self.twitterAuthViewController requestWithURL:testURL token:testToken];

    GHAssertNotNil(request, @"Should have real request");
}

- (void)testReceivingAccessTokenSetsParametersAndNotifiesDelegate {
    NSString *testAccessToken = @"testAccessToken";
    NSString *testAccessTokenSecret = @"testAccessTokenSecret";
    NSString *testUserID = @"12345";
    NSString *testScreenName = @"tweeter";
    
    // Should have request token
    self.twitterAuthViewController.requestToken = [OCMockObject mockForClass:[OAToken class]];
    
    // Should have verifier
    self.twitterAuthViewController.verifier = @"someVerifier";
    
    // Data string with info about the access token
    NSData *data = [self networkDataForString:[NSString stringWithFormat:@"oauth_token=%@&testToken&oauth_token_secret=%@&testSecret&user_id=%@&screen_name=%@", testAccessToken, testAccessTokenSecret, testUserID, testScreenName]];
    id ticket = [self succeedingTicket];

    // Should notify of credentials
    [[self.mockDelegate expect] twitterAuthViewController:(id)self.origViewController didReceiveAccessToken:testAccessToken accessTokenSecret:testAccessTokenSecret screenName:testScreenName userID:testUserID];
    
    // Should finish
    [[self.mockDelegate expect] baseViewControllerDidFinish:(id)self.origViewController];
    
    [self.twitterAuthViewController requestAccessToken:ticket didFinishWithData:data];
}

@end
