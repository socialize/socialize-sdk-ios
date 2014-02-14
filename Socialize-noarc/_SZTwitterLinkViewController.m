//
//  _SZTwitterLinkViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <OAuthConsumer/OAuthConsumer.h>
#import "socialize_globals.h"
#import "_SZTwitterLinkViewController.h"
#import <OAuthConsumer/OAuthConsumer.h>
#import "NSArray+AssociativeArray.h"
#import "NSString+QueryString.h"
#import "NSHTTPCookieStorage+Utilities.h"
#import "SZTwitterUtils.h"
#import <SZBlocksKit/BlocksKit+UIKit.h>

@interface _SZTwitterLinkViewController ()
@property (nonatomic, assign) BOOL sentTokenToSocialize;
@end

NSString *const SocializeTwitterAuthCallbackScheme = @"socializeoauth";

NSString *const SocializeTwitterRequestTokenURL = @"https://api.twitter.com/oauth/request_token";
NSString *const SocializeTwitterAccessTokenURL = @"https://api.twitter.com/oauth/access_token";
NSString *const SocializeTwitterAuthenticateURL = @"https://api.twitter.com/oauth/authenticate";

static NSString *const kTwitterRequestVerifier = @"oauth_verifier";
static NSString *const kTwitterRequestOAuthToken = @"oauth_token";
static NSString *const kTwitterAuthorizationDenied = @"denied";
static NSString *const kTwitterAccessResponseScreenName = @"screen_name";
static NSString *const kTwitterAccessResponseUserID = @"user_id";

@implementation _SZTwitterLinkViewController
@synthesize consumerKey = consumerKey_;
@synthesize consumerSecret = consumerSecret_;
@synthesize webView = webView_;
@synthesize requestToken = requestToken_;
@synthesize verifier = verifier_;
@synthesize accessToken = accessToken_;
@synthesize dataFetcher = dataFetcher_;
@synthesize delegate = delegate_;
@synthesize screenName = screenName_;
@synthesize userID = userID_;
@synthesize sentTokenToSocialize = sentTokenToSocialize_;

- (BOOL)shouldAutoAuthOnAppear {
    return NO;
}

- (id)initWithConsumerKey:(NSString*)consumerKey consumerSecret:(NSString*)consumerSecret {
    if (self = [super init]) {
        self.consumerKey = consumerKey;
        self.consumerSecret = consumerSecret;
    }
    
    return self;
}

- (void)cancelAllCallbacks {
    [self.dataFetcher cancel];
    [self.socialize setDelegate:nil];
    [self.webView setDelegate:nil];
}

- (void)fetchDataWithRequest:(OAMutableURLRequest*)request didFinishSelector:(SEL)finish didFailSelector:(SEL)fail {
    self.dataFetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:request
                                                                        delegate:self
                                                               didFinishSelector:finish
                                                                 didFailSelector:fail];
    [self.dataFetcher start];
}

- (void)tryToCompleteOAuthProcess {
    // If at first you don't succeed...
    
    // Ask for the request token (step 1 of https://dev.twitter.com/docs/auth/implementing-sign-twitter)
    if (self.requestToken == nil) {
        [self startLoading];
        [self requestRequestToken];
        return;
    }
    
    // Request token has arrived. Direct user to authenticate url in the web view to obtain the verifier.
    // (step 2 of https://dev.twitter.com/docs/auth/implementing-sign-twitter)
    if (self.verifier == nil) {
        [self startLoading];
        [self openAuthenticateURL];
        return;
    }
    
    // Verifier has been received. Use the request token and verifier to request the access token.
    // (step 3 of https://dev.twitter.com/docs/auth/implementing-sign-twitter)
    if (self.accessToken == nil) {
        [self requestAccessToken];
        return;
    }
    
    if (!self.sentTokenToSocialize) {
        [self startLoading];
        [SZTwitterUtils linkWithAccessToken:self.accessToken.key accessTokenSecret:self.accessToken.secret success:^(id<SZFullUser> user) {
            self.sentTokenToSocialize = YES;
            [self tryToCompleteOAuthProcess];
        } failure:^(NSError *error) {
            [self stopLoadingAndShowRetryDialogWithMessage:@"Sending to Socialize"];
        }];
        return;
    }
    
    [self stopLoading];

    BLOCK_CALL(self.completionBlock);
}

- (void)openAuthenticateURL {
    // Open "oauth/authenticate" in our UIWebView
    NSString *urlString = [SocializeTwitterAuthenticateURL stringByAppendingFormat:@"?oauth_token=%@", self.requestToken.key];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10.0];
    [self.webView loadRequest:request];
}

- (OAMutableURLRequest*)requestWithURL:(NSString*)urlString token:(OAToken*)token {
    // Build an OARequest with our twitter app info
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:self.consumerKey secret:self.consumerSecret];
    NSURL *requestURL = [NSURL URLWithString:urlString];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:requestURL consumer:consumer token:token realm:nil signatureProvider:nil];
    return request;
}

- (void)requestRequestToken {
    OAMutableURLRequest *request = [self requestWithURL:SocializeTwitterRequestTokenURL token:nil];
    [request setHTTPMethod:@"POST"];
    
    // Set the callback url to our private scheme, so we can handle it in the webView:shouldStartLoadWithRequest:
    NSString *callbackURL = [NSString stringWithFormat:@"%@://sign-in-with-twitter", SocializeTwitterAuthCallbackScheme];
    [request setOAuthParameterName:@"oauth_callback" withValue:callbackURL];
    
    [self fetchDataWithRequest:request
                didFinishSelector:@selector(requestRequestToken:didFinishWithData:)
                  didFailSelector:@selector(requestRequestToken:didFailWithError:)];
}

- (void)requestAccessToken {
    OAMutableURLRequest *request = [self requestWithURL:SocializeTwitterAccessTokenURL token:self.requestToken];
    [request setHTTPMethod:@"POST"];
    
    // The body should contain the verifier
    NSString *httpBodyString = [NSString stringWithFormat:@"%@=%@", kTwitterRequestVerifier, self.verifier];
    NSData *testData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    (void)testData;
    [request setHTTPBody:testData];
    
    [self fetchDataWithRequest:request
                         didFinishSelector:@selector(requestAccessToken:didFinishWithData:)
                           didFailSelector:@selector(requestAccessToken:didFailWithError:)];
}

- (OAToken*)tokenForResponseBody:(NSData*)data {
    // Build a new token from a response
    NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    
    return token;
}

- (void)requestRequestToken:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        
        OAToken *token = [self tokenForResponseBody:data];
        if (token != nil) {
            // The actual request for the request token has succeeded
            self.requestToken = token;
            [self tryToCompleteOAuthProcess];
        } else {
            [self stopLoadingAndShowRetryDialogWithMessage:@"Could not parse request token"];
        }
    } else {
        [self stopLoadingAndShowRetryDialogWithMessage:@"Could not get request token"];
    }
}

- (void)requestRequestToken:(OAServiceTicket *)ticket didFailWithError:(NSError*)error {
    // The actual request for the request token has failed
    [self stopLoadingAndShowRetryDialogWithMessage:@"Twitter error"];
}

- (void)requestAccessToken:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        OAToken *token = [self tokenForResponseBody:data];
        
        if (token != nil) {
            // The actual request for the access token has succeeded
            self.accessToken = token;
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *params = [[responseString parseQueryString] dictionaryFromPairs];
            self.screenName = [params objectForKey:kTwitterAccessResponseScreenName];
            self.userID = [params objectForKey:kTwitterAccessResponseUserID];

            [self tryToCompleteOAuthProcess];
        } else {
            [self stopLoadingAndShowRetryDialogWithMessage:@"Could not parse access token"];
        }
    } else {
        [self stopLoadingAndShowRetryDialogWithMessage:@"Could not get access token"];
    }
}

- (void)requestAccessToken:(OAServiceTicket *)ticket didFailWithError:(NSError*)error {
    // The request for the access token has failed
    [self stopLoadingAndShowRetryDialogWithMessage:@"Twitter error"];
}

- (void)removeTwitterCookies {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        if ([[cookie domain] isEqualToString:@".twitter.com"]) {
            [storage deleteCookie:cookie];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Twitter";
    self.navigationItem.leftBarButtonItem = self.cancelButton;

    [NSHTTPCookieStorage removeCookiesInDomain:@".twitter.com"];
    
    [self tryToCompleteOAuthProcess];
}

- (void)cancelButtonPressed:(UIBarButtonItem *)button {
    [self cancelAllCallbacks];
    [super cancelButtonPressed:button];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    NSString *scheme = [url scheme];
    if ([scheme isEqualToString:SocializeTwitterAuthCallbackScheme]) {
        NSString *query = [url query];
        NSDictionary *params = [[query parseQueryString] dictionaryFromPairs];
        
        NSString *verifier = [params objectForKey:kTwitterRequestVerifier];
        NSString *token = [params objectForKey:kTwitterRequestOAuthToken];

        if (verifier != nil) {
            if ([token isEqualToString:self.requestToken.key]) {
                // verifier has arrived
                self.verifier = verifier;
                [self tryToCompleteOAuthProcess];
            } else {
                [self stopLoadingAndShowRetryDialogWithMessage:@"Received bad token"];
            }
        } else if ([params objectForKey:kTwitterAuthorizationDenied]) {
            // user clicked cancel link in web page
            [self notifyDelegateOfCancellation];
        } else {
            // Something else happened
            [self stopLoadingAndShowRetryDialogWithMessage:nil];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self stopLoadingAndShowRetryDialogWithMessage:[error localizedDescription]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stopLoading];
}

- (void)cancelledAlert {
    // The user has aborted the authorization process
}

- (void)retry {
    // User would like to retry after a failure has occurred
    [self tryToCompleteOAuthProcess];
 }
     
- (void)stopLoadingAndShowRetryDialogWithMessage:(NSString*)message {
    [self stopLoading];

    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"Twitter Authentication Failed" message:message];
    [alertView bk_setCancelButtonWithTitle:@"Cancel" handler:^{ [self cancelledAlert]; }];
    [alertView bk_addButtonWithTitle:@"Retry" handler:^{ [self retry]; }];
    [alertView show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    }
}

@end
