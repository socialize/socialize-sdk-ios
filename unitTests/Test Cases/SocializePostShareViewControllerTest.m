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

@interface SocializePostShareViewController ()
- (void)createShare;
- (void)createShareOnSocializeServer;
- (void)createShareOnFacebookServer;
- (void)shareFailed:(NSError *)error;
- (void)shareComplete;
@end

@implementation SocializePostShareViewControllerTest
@synthesize postShareViewController = postShareViewController_;
@synthesize origPostShareViewController = origPostShareViewController_;
@synthesize mockShareObject = mockShareObject_;
@synthesize mockSocialize = mockSocialize_;
@synthesize mockTextView = mockTextView_;
@synthesize mockShareBuilder = mockShareBuilder_;

static NSString *const TestURL = @"http://getsocialize.com";

- (void)setUp {
    self.origPostShareViewController = [SocializePostShareViewController postShareViewControllerWithEntityURL:TestURL];
    self.postShareViewController = [OCMockObject partialMockForObject:self.origPostShareViewController];
    
    self.mockShareObject = [OCMockObject mockForProtocol:@protocol(SocializeShare)];
    self.postShareViewController.shareObject = self.mockShareObject;
    
    self.mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    self.postShareViewController.socialize = self.mockSocialize;
    
    self.mockTextView = [OCMockObject mockForClass:[UITextView class]];
    self.postShareViewController.commentTextView = self.mockTextView;
    
    self.mockShareBuilder = [OCMockObject mockForClass:[SocializeShareBuilder class]];
    self.postShareViewController.shareBuilder = self.mockShareBuilder;
}

- (void)tearDown {
    [(id)self.postShareViewController verify];
    [self.mockShareObject verify];
    [self.mockSocialize verify];
    [self.mockTextView verify];
    
    self.mockShareObject = nil;
    self.postShareViewController = nil;
    self.origPostShareViewController = nil;
    self.mockSocialize = nil;
    self.mockTextView = nil;
}


- (void)testViewDidLoad {
    [[(id)self.postShareViewController expect] setTitle:@"New Share"];
    [[(id)self.postShareViewController expect] authenticateWithFacebook];
    
    [self.postShareViewController viewDidLoad];
}

- (void)testCreateShareWithoutExistingShareObjectCreatesOnSocialize {
    self.postShareViewController.shareObject = nil;
    [[(id)self.postShareViewController expect] createShareOnSocializeServer];
    [self.postShareViewController createShare];
}

- (void)testCreateShareWithExistingShareObjectCreatesOnFacebook {
    [[(id)self.postShareViewController expect] createShareOnFacebookServer];
    [self.postShareViewController createShare];
}

- (void)testShareFailedActions {
    [[(id)self.postShareViewController expect] stopLoading];
    [[(id)self.postShareViewController expect] showAllertWithText:OCMOCK_ANY andTitle:OCMOCK_ANY];
    [self.postShareViewController shareFailed:nil];
}

- (void)testShareCompleteActions {
    [[(id)self.postShareViewController expect] stopLoading];
    [[(id)self.postShareViewController expect] dismissModalViewControllerAnimated:YES];
    [self.postShareViewController shareComplete];
}


- (void)testCreateShareOnSocializeServerPerformsCreate {
    NSString *testText = @"testText";
    NSString *testURL = @"testURL";
    self.postShareViewController.entityURL = testURL;
    
    [[(id)self.postShareViewController expect] startLoading];
    [[[self.mockTextView stub] andReturn:testText] text];
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

    [[(id)self.postShareViewController expect] shareComplete];
    defaultShareBuilder.successAction();
}

- (void)testShareBuilderErrorAction {
    self.postShareViewController.shareBuilder = nil;
    SocializeShareBuilder *defaultShareBuilder = self.postShareViewController.shareBuilder;
    
    id mockError = [OCMockObject mockForClass:[NSError class]];
    [[(id)self.postShareViewController expect] shareFailed:mockError];
    defaultShareBuilder.errorAction(mockError);
}

- (void)testCreateShareOnFacebookServer {
    [[self.mockShareBuilder expect] setShareObject:self.mockShareObject];
    [[self.mockShareBuilder expect] performShareForPath:@"me/feed"];
    [self.postShareViewController createShareOnFacebookServer];
    
}

- (void)testFailingSocializeCausesShareFailed {
    id mockError = [OCMockObject mockForClass:[NSError class]];
    [[(id)self.postShareViewController expect] shareFailed:mockError];
    [self.postShareViewController service:nil didFail:mockError];
}


@end
