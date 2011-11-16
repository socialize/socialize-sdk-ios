//
//  SocializeBaseViewControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewControllerTests.h"
#import "SocializeBaseViewController.h"
#import "UINavigationBarBackground.h"

@implementation SocializeBaseViewControllerTests
@synthesize viewController = viewController_;
@synthesize origViewController = origViewController_;
@synthesize mockSocialize = mockSocialize_;
@synthesize mockGenericAlertView = mockGenericAlertView_;
@synthesize mockNavigationController = mockNavigationController_;
@synthesize mockNavigationItem = mockNavigationItem_;
@synthesize mockNavigationBar = mockNavigationBar_;
@synthesize mockDoneButton = mockDoneButton_;
@synthesize mockEditButton = mockEditButton_;
@synthesize mockSendButton = mockSendButton_;

- (BOOL)shouldRunOnMainThread {
    return YES;
}

+ (SocializeBaseViewController*)createController {
    return [[[SocializeBaseViewController alloc] init] autorelease];
}

-(void) setUp
{
    [super setUp];
    
    self.origViewController = [[self class] createController];
    self.viewController = [OCMockObject partialMockForObject:self.origViewController];
    
    self.mockNavigationController = [OCMockObject mockForClass:[UINavigationController class]];
    [[[(id)self.viewController stub] andReturn:self.mockNavigationController] navigationController];
    
    self.mockNavigationBar = [OCMockObject mockForClass:[UINavigationBar class]];
    [[[self.mockNavigationController stub] andReturn:self.mockNavigationBar] navigationBar];
    
    self.mockNavigationItem = [OCMockObject mockForClass:[UINavigationItem class]];
    [[[(id)self.viewController stub] andReturn:self.mockNavigationItem] navigationItem];
    
    self.mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    [[[self.mockSocialize stub] andReturn:self.viewController] delegate];
    self.viewController.socialize = self.mockSocialize;
    
    self.mockGenericAlertView = [OCMockObject mockForClass:[UIAlertView class]];
    self.viewController.genericAlertView = self.mockGenericAlertView;
    
    self.mockDoneButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.viewController.doneButton = self.mockDoneButton;
    
    self.mockEditButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.viewController.editButton = self.mockEditButton;
    
    self.mockSendButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.viewController.sendButton = self.mockSendButton;
}

-(void) tearDown
{
    [super tearDown];
    
    [(id)self.viewController verify];
    [self.mockNavigationController verify];
    [self.mockNavigationBar verify];
    [self.mockNavigationItem verify];
    [self.mockSocialize verify];
    [self.mockGenericAlertView verify];
    [self.mockDoneButton verify];
    [self.mockEditButton verify];

    [[self.mockGenericAlertView expect] setDelegate:nil];
    self.origViewController = nil;
    self.viewController = nil;
    self.mockNavigationController = nil;
    self.mockNavigationBar = nil;
    self.mockNavigationItem = nil;
    self.mockSocialize = nil;
    self.mockGenericAlertView = nil;
    self.mockDoneButton = nil;
    self.mockEditButton = nil;
}

- (void)testViewDidUnload {
    [[(id)self.viewController expect] setDoneButton:nil];
    [[(id)self.viewController expect] setEditButton:nil];
    [[(id)self.viewController expect] setSaveButton:nil];
    [[(id)self.viewController expect] setCancelButton:nil];
    [[(id)self.viewController expect] setSendButton:nil];
    [[(id)self.viewController expect] setGenericAlertView:nil];
    [[(id)self.viewController expect] setFacebookAuthQuestionDialog:nil];
    [[(id)self.viewController expect] setPostFacebookAuthenticationProfileViewController:nil];
    [[(id)self.viewController expect] setSendActivityToFacebookFeedAlertView:nil];
    [[(id)self.viewController expect] setAuthViewController:nil];
    
    [self.viewController viewDidUnload];
}

- (void)testDefaultTableViewProperty {
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
    BOOL yes = YES;
    [[[mockTableView expect] andReturnValue:OCMOCK_VALUE(yes)] isKindOfClass:[UITableView class]];
    [[[(id)self.viewController stub] andReturn:mockTableView] view];

    UITableView *defaultTableView = self.viewController.tableView;
    GHAssertEquals(mockTableView, defaultTableView, @"tableView incorrect");
}

- (void)testDefaultSocialize {
    self.viewController.socialize = nil;
    
    Socialize *socialize = self.viewController.socialize;
    GHAssertEquals(socialize.delegate, self.origViewController, nil);
}

- (void)assertBarButtonCallsSelector:(UIBarButtonItem *)item selector:(SEL)selector {
    UIButton *button = (UIButton*)item.customView;
    
    NSArray *actions = [button actionsForTarget:self.origViewController forControlEvent:UIControlEventTouchUpInside];
    SEL s = NSSelectorFromString([actions objectAtIndex:0]);
    GHAssertEquals(selector, s, @"Selector incorrect");
    
    [self.viewController performSelector:s withObject:nil];
}

- (void)testDoneCallsSelector {
    self.viewController.doneButton = nil;
    [self assertBarButtonCallsSelector:self.viewController.doneButton selector:@selector(doneButtonPressed:)];
}

- (void)testEditCallsSelector {
    self.viewController.editButton = nil;
    [self assertBarButtonCallsSelector:self.viewController.editButton selector:@selector(editButtonPressed:)];
}

- (void)testSendCallsSelector {
    self.viewController.sendButton = nil;
    [self assertBarButtonCallsSelector:self.viewController.sendButton selector:@selector(sendButtonPressed:)];
}

- (void)testCancelCallsSelector {
    self.viewController.cancelButton = nil;
    [self assertBarButtonCallsSelector:self.viewController.cancelButton selector:@selector(cancelButtonPressed:)];
}

- (void)testSaveCallsSelector {
    self.viewController.saveButton = nil;
    [self assertBarButtonCallsSelector:self.viewController.saveButton selector:@selector(saveButtonPressed:)];
}

- (void)testDefaultGenericAlertView {
    self.viewController.genericAlertView = nil;
    GHAssertEquals(self.viewController.genericAlertView.delegate, self.origViewController, nil);
}

- (void)testShowAlert {
    NSString *testTitle = @"testTitle";
    NSString *testMessage = @"testMessage";
    
    [[self.mockGenericAlertView expect] setTitle:testTitle];
    [[self.mockGenericAlertView expect] setMessage:testMessage];
    [[self.mockGenericAlertView expect] show];
    
    [self.viewController showAlertWithText:testMessage andTitle:testTitle];
}

- (void)testDefaultShowLoadingInView {
    id mockView = [OCMockObject mockForClass:[UIView class]];
    [[[(id)self.viewController stub] andReturn:mockView] view];
    UIView *showLoadingInView = [self.viewController showLoadingInView];
    GHAssertEquals(mockView, showLoadingInView, nil);
}

- (void)testDefaultAutoAuth {
    GHAssertTrue([self.viewController shouldAutoAuthOnAppear], nil);
}

- (void)testAutoAuthWhenNotAuthed {
    BOOL no = NO;
    [[[self.mockSocialize expect] andReturnValue:OCMOCK_VALUE(no)] isAuthenticated];
    [[(id)self.viewController expect] startLoading];
    [[self.mockSocialize expect] authenticateAnonymously];
    [self.viewController performAutoAuth];
}

- (void)testAutoAuthWhenAuthed {
    BOOL yes = YES;
    [[[self.mockSocialize expect] andReturnValue:OCMOCK_VALUE(yes)] isAuthenticated];
    [[(id)self.viewController expect] afterAnonymouslyLoginAction];
    [self.viewController performAutoAuth];
}

- (void)testViewWillAppear {
    [[(id)self.viewController expect] performAutoAuth];
    [[self.mockNavigationBar expect] resetBackground];
    [self.viewController viewWillAppear:YES];
}

- (void)testServiceFailureShowsAnAlert {
    NSString *testDescription = @"testDescription";
    id mockError = [OCMockObject mockForClass:[NSError class]];
    [[[mockError expect] andReturn:testDescription] localizedDescription];
    [[(id)self.viewController expect] stopLoadAnimation];
    [[(id)self.viewController expect] showAlertWithText:testDescription andTitle:OCMOCK_ANY];
    [self.viewController service:nil didFail:mockError];
}

- (void)testBackgroundResetsOnShow {
    id mockNav = [OCMockObject mockForClass:[UINavigationController class]];
    id mockBar = [OCMockObject mockForClass:[UINavigationBar class]];
    [[[mockNav stub] andReturn:mockBar] navigationBar];
    [[mockBar expect] resetBackground];
    [self.viewController navigationController:mockNav didShowViewController:nil animated:YES];
}

@end
