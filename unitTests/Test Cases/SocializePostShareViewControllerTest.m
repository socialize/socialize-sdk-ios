//
//  SocializePostShareViewControllerTest.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/11/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializePostShareViewControllerTest.h"
#import "OCMock/OCMock.h"
#import "SocializeShareBuilder.h"
#import "UINavigationBarBackground.h"

@interface SocializePostShareViewController ()
- (void)createShare;
- (void)createShareOnSocializeServer;
- (void)createShareOnFacebookServer;
- (void)shareFailed:(NSError *)error;
- (void)shareComplete;
@end

@implementation SocializePostShareViewControllerTest
@synthesize postShareViewController = postShareViewController_;
@synthesize mockShareObject = mockShareObject_;

static NSString *const TestURL = @"http://getsocialize.com";

- (BOOL)shouldRunOnMainThread {
    return YES;
}

+ (SocializeBaseViewController*)createController {
    return [SocializePostShareViewController postShareViewControllerWithEntityURL:TestURL];
}

- (void)setUp {
    [super setUp];
    
    // super setUp creates self.viewController
    self.postShareViewController = (SocializePostShareViewController*)self.viewController;
    
    self.mockShareObject = [OCMockObject mockForProtocol:@protocol(SocializeShare)];
    self.postShareViewController.shareObject = self.mockShareObject;
}

- (void)tearDown {
    [(id)self.postShareViewController verify];
    [self.mockShareObject verify];
    [self.mockCommentTextView verify];
    
    self.mockShareObject = nil;
    self.postShareViewController = nil;
    self.mockCommentTextView = nil;

    [super tearDown];
}

- (void)testViewDidLoad {
    [super prepareForViewDidLoad];

    [[(id)self.postShareViewController expect] setTitle:@"New Share"];

    [self.postShareViewController viewDidLoad];
}

- (void)testViewDidAppearCausesAuth {
    [[self.mockNavigationBar expect] resetBackground];
    [[(id)self.postShareViewController expect] authenticateWithFacebook];
    
    [self.postShareViewController viewDidAppear:YES];
}

- (void)testCreateShareWithoutExistingShareObjectCreatesOnSocialize {
    self.postShareViewController.shareObject = nil;
    [[(id)self.postShareViewController expect] createShareOnSocializeServer];
    [self.postShareViewController createShare];
}

- (void)testCreateShareWithExistingShareObjectCreatesOnFacebook {
    [[(id)self.postShareViewController expect] sendActivityToFacebookFeed:self.mockShareObject];
    [self.postShareViewController createShare];
}

- (void)testSendActivityToFacebookFeedSucceeded {
    [[(id)self.postShareViewController expect] dismissModalViewControllerAnimated:YES];
    [self.postShareViewController sendActivityToFacebookFeedSucceeded];
}


- (void)testCreateShareOnSocializeServerPerformsCreate {
    NSString *testText = @"testText";
    NSString *testURL = @"testURL";
    self.postShareViewController.entityURL = testURL;
    
    [[(id)self.postShareViewController expect] startLoading];
    [[[self.mockCommentTextView stub] andReturn:testText] text];
    [[self.mockSocialize expect] createShareForEntityWithKey:testURL medium:SocializeShareMediumFacebook text:testText];
    
    [self.postShareViewController createShareOnSocializeServer];
}

- (void)testFinishingSocializeCreateRetriesCreate {
    id mockShare = [OCMockObject mockForProtocol:@protocol(SocializeShare)];
    [[(id)self.postShareViewController expect] setShareObject:mockShare];
    [[(id)self.postShareViewController expect] createShare];
    [self.postShareViewController service:nil didCreate:mockShare];
}

- (void)testShareBuilderSuccessAction {
    self.postShareViewController.shareBuilder = nil;
    SocializeShareBuilder *defaultShareBuilder = self.postShareViewController.shareBuilder;

    [[(id)self.postShareViewController expect] sendActivityToFacebookFeedSucceeded];
    defaultShareBuilder.successAction();
}

- (void)testShareBuilderErrorAction {
    self.postShareViewController.shareBuilder = nil;
    SocializeShareBuilder *defaultShareBuilder = self.postShareViewController.shareBuilder;
    
    id mockError = [OCMockObject mockForClass:[NSError class]];
    [[(id)self.postShareViewController expect] sendActivityToFacebookFeedFailed:mockError];
    defaultShareBuilder.errorAction(mockError);
}

- (void)testSendButtonCreatesShare {
    [[(id)self.postShareViewController expect] createShare];
    [self.postShareViewController sendButtonPressed:nil];
}

- (void)testDoesNoAutoAuthOnAppear {
    GHAssertFalse([self.postShareViewController shouldAutoAuthOnAppear], nil);
}

- (void)testThatSendButtonDisabledAfterInitialAuth {
    [[self.mockSendButton expect] setEnabled:NO];
    [self.postShareViewController afterLoginAction:YES];
}

@end
