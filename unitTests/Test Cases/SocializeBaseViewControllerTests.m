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
@synthesize mockCancelButton = mockCancelButton_;
@synthesize mockBundle = mockBundle_;
@synthesize mockImagesCache = mockImagesCache_;
@synthesize mockSaveButton = mockSaveButton_;
@synthesize mockView = mockView_;
@synthesize mockWindow = mockWindow_;
@synthesize mockKeyboardListener = mockKeyboardListener_;

- (BOOL)shouldRunOnMainThread {
    return YES;
}

+ (SocializeBaseViewController*)createController {
    return [[[SocializeBaseViewController alloc] init] autorelease];
}

-(void) setUp
{
    [super setUp];
    
    @autoreleasepool {
        self.origViewController = [[self class] createController];
        self.viewController = [OCMockObject partialMockForObject:self.origViewController];
    }
    
    self.mockWindow = [OCMockObject mockForClass:[UIWindow class]];
    self.mockView = [OCMockObject niceMockForClass:[UIView class]];
    [[[self.mockView stub] andReturn:self.mockWindow] window];
    [[[(id)self.viewController stub] andDo:^(NSInvocation* inv) {
        UIView *currentMock = self.mockView;
        [inv setReturnValue:&currentMock];
    }] view];
    
    self.mockNavigationController = [OCMockObject mockForClass:[UINavigationController class]];
    [[[(id)self.viewController stub] andReturn:self.mockNavigationController] navigationController];
    
    self.mockNavigationBar = [OCMockObject mockForClass:[UINavigationBar class]];
    [[[self.mockNavigationController stub] andReturn:self.mockNavigationBar] navigationBar];
    
    self.mockNavigationItem = [OCMockObject mockForClass:[UINavigationItem class]];
    [[[(id)self.viewController stub] andReturn:self.mockNavigationItem] navigationItem];
    
    self.mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    [[[self.mockSocialize stub] andReturn:self.viewController] delegate];
    [[self.mockSocialize stub] setDelegate:nil];
    self.viewController.socialize = self.mockSocialize;
    
    self.mockGenericAlertView = [OCMockObject mockForClass:[UIAlertView class]];
    self.viewController.genericAlertView = self.mockGenericAlertView;
    
    self.mockDoneButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.viewController.doneButton = self.mockDoneButton;
    
    self.mockEditButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.viewController.editButton = self.mockEditButton;
    
    self.mockSendButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.viewController.sendButton = self.mockSendButton;

    self.mockCancelButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.viewController.cancelButton = self.mockCancelButton;
        
    self.mockSaveButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.viewController.saveButton = self.mockSaveButton;

    self.mockBundle = [OCMockObject mockForClass:[NSBundle class]];
    self.viewController.bundle = self.mockBundle;

    self.mockImagesCache = [OCMockObject mockForClass:[ImagesCache class]];
    self.viewController.imagesCache = self.mockImagesCache;
    
    self.mockKeyboardListener = [OCMockObject mockForClass:[SocializeKeyboardListener class]];
    self.viewController.keyboardListener = self.mockKeyboardListener;
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
    [self.mockSendButton verify];
    [self.mockCancelButton verify];
    [self.mockSaveButton verify];
    [self.mockBundle verify];
    [self.mockImagesCache verify];
    [self.mockKeyboardListener verify];

    [[self.mockKeyboardListener stub] setDelegate:nil];
    [[self.mockGenericAlertView expect] setDelegate:nil];
    self.origViewController = nil;
    
    // There is some kind of retain cycle with the OCMock recorders array here
    [(id)self.viewController stop];
    self.viewController = nil;
    
    self.mockNavigationController = nil;
    self.mockNavigationBar = nil;
    self.mockNavigationItem = nil;
    self.mockSocialize = nil;
    self.mockGenericAlertView = nil;
    self.mockDoneButton = nil;
    self.mockEditButton = nil;
    self.mockSendButton = nil;
    self.mockCancelButton = nil;
    self.mockSaveButton = nil;
    self.mockBundle = nil;
    self.mockImagesCache = nil;
    self.mockKeyboardListener = nil;
}

- (void)testViewDidUnload {
    [[(id)self.viewController expect] setDoneButton:nil];
    [[(id)self.viewController expect] setEditButton:nil];
    [[(id)self.viewController expect] setSaveButton:nil];
    [[(id)self.viewController expect] setCancelButton:nil];
    [[(id)self.viewController expect] setSendButton:nil];
    [[(id)self.viewController expect] setGenericAlertView:nil];
    [[(id)self.viewController expect] setSendActivityToFacebookFeedAlertView:nil];
    [[(id)self.viewController expect] setAuthViewController:nil];
    
    [self.viewController viewDidUnload];
}

- (void)expectAndSimulateLoadOfImage:(UIImage*)image fromURL:(NSString*)url {
    // First return nil for image from cache
    [[[self.mockImagesCache expect] andReturn:nil] imageFromCache:url];
    
    [[[self.mockImagesCache expect] andDo:^(NSInvocation *inv) {
        // Get the completion block and call it
        void(^completionBlock)(ImagesCache *image);
        [inv getArgument:&completionBlock atIndex:3];
        [[[self.mockImagesCache expect] andReturn:image] imageFromCache:url];
        completionBlock(self.mockImagesCache);
    }] loadImageFromUrl:url completeAction:OCMOCK_ANY];
}

- (void)expectChangeTitleOnCustomBarButton:(id)mockButton toText:(NSString*)text {
    id mockUIButton = [OCMockObject mockForClass:[UIButton class]];
    [[[mockButton expect] andReturn:mockUIButton] customView];
    [[mockUIButton expect] setTitle:text forState:UIControlStateNormal];
}

- (void)testDefaultTableViewProperty {
    self.mockView = [OCMockObject mockForClass:[UITableView class]];
    [[[self.mockView stub] andReturnBool:YES] isKindOfClass:[UITableView class]];
    
    // Handle tableview cleanup in dealloc
    [[self.mockView stub] setDelegate:nil];
    [[self.mockView stub] setDataSource:nil];

    [self.viewController viewDidLoad];
    UITableView *defaultTableView = self.viewController.tableView;
    GHAssertEquals(self.mockView, defaultTableView, @"tableView incorrect");
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
    UIView *showLoadingInView = [self.viewController showLoadingInView];
    GHAssertEquals(self.mockView, showLoadingInView, nil);
}

- (void)testshouldShowAuthViewController {
    [[[self.mockSocialize expect] andReturnBool:NO]isAuthenticatedWithFacebook];
    [[[self.mockSocialize expect] andReturnBool:YES]isFacebookConfigured];
    BOOL shouldShow = [self.viewController shouldShowAuthViewController];
    GHAssertTrue(shouldShow, @"should show auth view controller should've returned true");
}
- (void)testDefaultAutoAuth {
    GHAssertTrue([self.viewController shouldAutoAuthOnAppear], nil);
}

- (void)testAutoAuthWhenNotAuthedPerformsAuth {
    [[[self.mockSocialize stub] andReturnBool:NO] isAuthenticated];
    [[[self.mockSocialize stub] andReturnBool:NO] isAuthenticatedWithFacebook];
    [[[self.mockSocialize stub] andReturnBool:NO] facebookSessionValid];
    [[(id)self.viewController expect] startLoading];
    [[self.mockSocialize expect] authenticateAnonymously];
    [self.viewController performAutoAuth];
}

- (void)testAutoAuthWhenNotAuthedAndFacebookAlreadyValidPerformsFacebookAuth {
    [[[self.mockSocialize stub] andReturnBool:NO] isAuthenticated];
    [[[self.mockSocialize stub] andReturnBool:NO] isAuthenticatedWithFacebook];
    [[[self.mockSocialize stub] andReturnBool:YES] facebookSessionValid];
    [[(id)self.viewController expect] startLoading];
    [[self.mockSocialize expect] authenticateWithFacebook];
    [self.viewController performAutoAuth];
}

- (void)testAutoAuthWhenAuthedDoesNothing {
    [[[self.mockSocialize expect] andReturnBool:YES] isAuthenticated];
    [[[self.mockSocialize expect] andReturnBool:YES] isAuthenticatedWithFacebook];
    [self.viewController performAutoAuth];
}

- (void)testAuthenticateWithFacebookNotAvailable {
    BOOL isFacebookAvailable = NO;
    [[[self.mockSocialize expect] andReturnValue:OCMOCK_VALUE(isFacebookAvailable)] facebookAvailable];
    [[(id)self.viewController expect] showAlertWithText:OCMOCK_ANY andTitle:OCMOCK_ANY];
    [self.origViewController authenticateWithFacebook];
}
- (void)testAuthenticateWithFacebookAvailable {
    BOOL isFacebookAvailable = YES;
    BOOL isAuthenticatedWithFB = NO;
    [[[self.mockSocialize expect] andReturnValue:OCMOCK_VALUE(isFacebookAvailable)] facebookAvailable];
    [[[self.mockSocialize expect] andReturnValue:OCMOCK_VALUE(isAuthenticatedWithFB)] isAuthenticatedWithFacebook];
    [[self.mockSocialize expect] authenticateWithFacebook];
    [self.origViewController authenticateWithFacebook];
}

- (void) testDidDismissWithButtonForFBSend {
    int buttonIndex = 2;
    
    //setup mock alert view and expected methods
    id mockAlertView = [OCMockObject mockForClass:[UIAlertView class]];
    [[[mockAlertView expect] andReturnInteger:1] cancelButtonIndex];
    [[[mockAlertView expect] andReturnInteger:buttonIndex] firstOtherButtonIndex];
    [[[(id)self.viewController expect] andReturn:mockAlertView] sendActivityToFacebookFeedAlertView];
    
    //expect activity is cancelled
    [[(id)self.viewController expect]  sendActivityToFacebookFeed:OCMOCK_ANY];
    
    [self.origViewController alertView:mockAlertView didDismissWithButtonIndex:buttonIndex];
    [mockAlertView verify];
}
- (void) testDidDismissWithButtonForFBCancel {
    int buttonIndex = 1;
    
    //setup mock alert view and expected methods
    id mockAlertView = [OCMockObject mockForClass:[UIAlertView class]];
    [[[mockAlertView expect] andReturnValue:OCMOCK_VALUE(buttonIndex)] cancelButtonIndex];
    [[[(id)self.viewController expect] andReturn:mockAlertView] sendActivityToFacebookFeedAlertView];
     
    //expect activity is cancelled
    [[(id)self.viewController expect] sendActivityToFacebookFeedCancelled];
    
    [self.origViewController alertView:mockAlertView didDismissWithButtonIndex:buttonIndex];
    [mockAlertView verify];
}
- (void)testDidAuthenticateAfterAnonymousAuthCallsAfterAnonymouslyLoginAction {
    [[(id)self.viewController expect] stopLoadAnimation];
    BOOL no = NO;
    [[[self.mockSocialize stub] andReturnValue:OCMOCK_VALUE(no)] isAuthenticatedWithFacebook];
    [[(id)self.viewController expect] afterLoginAction];
    [self.viewController didAuthenticate:nil];
}

- (void)expectViewWillAppear {
    [[(id)self.viewController expect] performAutoAuth];
    [[self.mockNavigationBar expect] resetBackground];    
}

- (void)testViewWillAppear {
    [self expectViewWillAppear];
    [self.viewController viewWillAppear:YES];
}

- (void)expectServiceFailureWithError:(NSError*)error {
    [[(id)self.viewController expect] stopLoadAnimation];
    [[(id)self.viewController expect] showAlertWithText:[error localizedDescription] andTitle:OCMOCK_ANY];
}

- (void)testServiceFailureShowsAnAlert {
    NSString *testDescription = @"testDescription";
    id mockError = [OCMockObject mockForClass:[NSError class]];
    [[[mockError stub] andReturn:testDescription] localizedDescription];
    [self expectServiceFailureWithError:mockError];
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
