//
//  SocializeTwitterAuthViewControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeTwitterAuthViewControllerTests.h"
#import "OAMutableURLRequest.h"

@interface SocializeTwitterAuthViewController ()
- (void)fetchDataWithRequest:(OAMutableURLRequest*)request didFinishSelector:(SEL)finish didFailSelector:(SEL)fail;
- (OAMutableURLRequest*)requestWithURL:(NSString*)urlString token:(OAToken*)token;
@end

@implementation SocializeTwitterAuthViewControllerTests
@synthesize twitterAuthViewController = twitterAuthViewController_;

+ (SocializeBaseViewController*)createController {
    SocializeTwitterAuthViewController *controller = [[[SocializeTwitterAuthViewController alloc] init] autorelease];
    
    return controller;
}

- (void)setUp {
    [super setUp];
    
    self.twitterAuthViewController = (SocializeTwitterAuthViewController*)self.viewController;
}

- (void)tearDown {
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

@end
