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
#import "SocializeBaseViewControllerDelegate.h"
#import "SocializeProfileEditViewController.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeTwitterAuthenticator.h"
#import "SocializeFacebookAuthenticator.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeThirdPartyTwitter.h"
#import "SocializeFacebookAuthenticator.h"
#import "_Socialize.h"

@implementation SocializeBaseViewControllerTests
@synthesize viewController = viewController_;
@synthesize origViewController = origViewController_;
@synthesize mockSocialize = mockSocialize_;
@synthesize mockGenericAlertView = mockGenericAlertView_;
@synthesize mockNavigationController = mockNavigationController_;
@synthesize mockNavigationItem = mockNavigationItem_;
@synthesize mockNavigationBar = mockNavigationBar_;
@synthesize mockDoneButton = mockDoneButton_;
@synthesize mockCancelButton = mockCancelButton_;
@synthesize mockBundle = mockBundle_;
@synthesize mockImagesCache = mockImagesCache_;
@synthesize mockSettingsButton = mockSettingsButton_;
@synthesize mockView = mockView_;
@synthesize mockWindow = mockWindow_;
@synthesize mockKeyboardListener = mockKeyboardListener_;
@synthesize mockDelegate = mockDelegate_;
@synthesize mockProfileEditViewController = mockProfileEditViewController_;

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
    
    self.mockNavigationController = [OCMockObject niceMockForClass:[UINavigationController class]];
    [[[(id)self.viewController stub] andReturn:self.mockNavigationController] navigationController];
    
    self.mockNavigationBar = [OCMockObject niceMockForClass:[UINavigationBar class]];
    [[[self.mockNavigationController stub] andReturn:self.mockNavigationBar] navigationBar];
    
    self.mockNavigationItem = [OCMockObject mockForClass:[UINavigationItem class]];
    [[[(id)self.viewController stub] andReturn:self.mockNavigationItem] navigationItem];
    
    self.mockSocialize = [OCMockObject niceMockForClass:[Socialize class]];
    [[[self.mockSocialize stub] andReturn:self.viewController] delegate];
    [[self.mockSocialize stub] setDelegate:nil];

    self.viewController.socialize = self.mockSocialize;
    
    self.mockGenericAlertView = [OCMockObject mockForClass:[UIAlertView class]];
    self.viewController.genericAlertView = self.mockGenericAlertView;
    
    self.mockDoneButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.viewController.doneButton = self.mockDoneButton;
    
    self.mockCancelButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.viewController.cancelButton = self.mockCancelButton;
        
    self.mockSettingsButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.viewController.settingsButton = self.mockSettingsButton;

    self.mockBundle = [OCMockObject mockForClass:[NSBundle class]];
    self.viewController.bundle = self.mockBundle;

    self.mockImagesCache = [OCMockObject mockForClass:[ImagesCache class]];
    self.viewController.imagesCache = self.mockImagesCache;
    
    self.mockKeyboardListener = [OCMockObject mockForClass:[SocializeKeyboardListener class]];
    self.viewController.keyboardListener = self.mockKeyboardListener;
    
    self.mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeBaseViewControllerDelegate)];
    self.viewController.delegate = self.mockDelegate;
    
    self.mockProfileEditViewController = [OCMockObject mockForClass:[SocializeProfileEditViewController class]];
    [[self.mockProfileEditViewController stub] setDelegate:nil];
    self.viewController.profileEditViewController = self.mockProfileEditViewController;
    
    [Socialize storeUIErrorAlertsDisabled:NO];
}

-(void) tearDown
{
    [(id)self.viewController verify];
    [self.mockNavigationController verify];
    [self.mockNavigationBar verify];
    [self.mockNavigationItem verify];
    [self.mockSocialize verify];
    [self.mockGenericAlertView verify];
    [self.mockDoneButton verify];
    [self.mockCancelButton verify];
    [self.mockSettingsButton verify];
    [self.mockBundle verify];
    [self.mockImagesCache verify];
    [self.mockKeyboardListener verify];
    [self.mockDelegate verify];
    [self.mockProfileEditViewController verify];
    
    [[self.mockKeyboardListener stub] setDelegate:nil];
    [[self.mockGenericAlertView expect] setDelegate:nil];
    self.origViewController = nil;
    
    self.mockNavigationController = nil;
    self.mockNavigationBar = nil;
    self.mockNavigationItem = nil;
    self.mockSocialize = nil;
    self.mockGenericAlertView = nil;
    self.mockDoneButton = nil;
    self.mockCancelButton = nil;
    self.mockSettingsButton = nil;
    self.mockBundle = nil;
    self.mockImagesCache = nil;
    self.mockKeyboardListener = nil;
    self.mockDelegate = nil;
    self.mockProfileEditViewController = nil;
    
    // There is some kind of retain cycle with the OCMock recorders array here
    [(id)self.viewController stop];
    self.viewController = nil;
    
    [super tearDown];
}

- (void)testViewDidUnload {
    [[(id)self.viewController expect] setDoneButton:nil];
    [[(id)self.viewController expect] setCancelButton:nil];
    [[(id)self.viewController expect] setSettingsButton:nil];
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
}

SYNTH_BUTTON_TEST(viewController, doneButton)
SYNTH_BUTTON_TEST(viewController, cancelButton)
SYNTH_BUTTON_TEST(viewController, settingsButton)

- (void)testCancelInformsDelegate {
    [[self.mockDelegate expect] baseViewControllerDidCancel:self.origViewController];
    [self.viewController cancelButtonPressed:self.mockCancelButton];
}

- (void)expectDelegateNotifiedOfCompletion {
    [[self.mockDelegate expect] baseViewControllerDidFinish:self.origViewController];    
}

- (void)testDoneInformsDelegate {
    [self expectDelegateNotifiedOfCompletion];
    [self.viewController doneButtonPressed:self.mockDoneButton];
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
    [[[self.mockSocialize expect] andReturnBool:NO] isAuthenticatedWithThirdParty];
    [[[self.mockSocialize expect] andReturnBool:YES] thirdPartyAvailable];
    BOOL shouldShow = [self.viewController shouldShowAuthViewController];
    GHAssertTrue(shouldShow, @"should show auth view controller should've returned true");
}

- (void)testDefaultAutoAuth {
    GHAssertTrue([self.viewController shouldAutoAuthOnAppear], nil);
}

- (void)testAutoAuthWhenNotAuthedPerformsAuth {
    [[[self.mockSocialize stub] andReturnBool:NO] isAuthenticated];
    [[self.mockSocialize expect] authenticateAnonymously];
    [self.viewController performAutoAuth];
}

//- (void)testAutoAuthWhenNotAuthedAndFacebookAlreadyValidDoesNotFacebookAuthIfFacebookNotAvailable {
//    [[[self.mockSocialize stub] andReturnBool:NO] isAuthenticated];
//    [[[self.mockSocialize stub] andReturnBool:NO] isAuthenticatedWithFacebook];
//    [[[SocializeThirdPartyFacebook stub] andReturnBool:YES] hasLocalCredentials];
//    [[[SocializeThirdPartyFacebook stub] andReturnBool:NO] available];
//    [[(id)self.viewController expect] startLoading];
//    [[self.mockSocialize expect] authenticateAnonymously];
//    [self.viewController performAutoAuth];
//}

- (void)testAutoAuthWhenAuthedDoesNothing {
    [[[self.mockSocialize stub] andReturnBool:YES] isAuthenticated];
    [[[self.mockSocialize stub] andReturnBool:YES] isAuthenticatedWithThirdParty];
    [self.viewController performAutoAuth];
}

- (void)testAuthenticateWithFacebookWhenFacebookNotAvailable {
    [SocializeThirdPartyFacebook startMockingClass];
    
    [[[SocializeThirdPartyFacebook stub] andReturnBool:NO] available];

    [[(id)self.viewController expect] showAlertWithText:OCMOCK_ANY andTitle:OCMOCK_ANY];
    [self.origViewController authenticateWithFacebook];
    
    [SocializeThirdPartyFacebook stopMockingClassAndVerify];
}
- (void)testAuthenticateWithFacebookWhenFacebookAvailable {
    [SocializeThirdPartyFacebook startMockingClass];
    [SocializeFacebookAuthenticator startMockingClass];
    
    [[[SocializeThirdPartyFacebook stub] andReturnBool:YES] available];
    [[[SocializeThirdPartyFacebook stub] andReturnBool:NO] isLinkedToSocialize];

    [[SocializeFacebookAuthenticator expect] authenticateViaFacebookWithOptions:OCMOCK_ANY
                                                                        display:OCMOCK_ANY
                                                                        success:OCMOCK_ANY
                                                                        failure:OCMOCK_ANY];
    [self.origViewController authenticateWithFacebook];
    
    [SocializeThirdPartyFacebook stopMockingClassAndVerify];
    [SocializeFacebookAuthenticator stopMockingClassAndVerify];
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
    [[(id)self.viewController expect] afterLoginAction:YES];
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

- (void)expectServiceFailure {
    [[(id)self.viewController expect] stopLoadAnimation];
    [[(id)self.viewController expect] showAlertWithText:OCMOCK_ANY andTitle:OCMOCK_ANY];
}

- (id)observerMockForNotificationName:(NSString*)name object:(id)object userInfo:(NSDictionary*)userInfo {
    id observer = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observer name:name object:object];
    [[observer expect] notificationWithName:name object:object userInfo:userInfo];
    return observer;
}

- (id)observerMockForUIError:(NSError*)error {
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error forKey:SocializeUIControllerErrorUserInfoKey];
    return [self observerMockForNotificationName:SocializeUIControllerDidFailWithErrorNotification object:self.origViewController userInfo:errorInfo];
}

- (void)testServiceFailureShowsAnAlert {
    id mockError = [OCMockObject mockForClass:[NSError class]];
    id observer = [self observerMockForUIError:mockError];
    NSString *testDescription = @"testDescription";
    [[[mockError stub] andReturn:testDescription] localizedDescription];
    [[mockError stub] domain];
    [self expectServiceFailure];
    [self.viewController service:nil didFail:mockError];
    
    [observer verify];
}

- (void)testServiceAuthenticationFailureRemovesSocializeAuthenticationInfo {
    [[self.mockSocialize expect] removeSocializeAuthenticationInfo];
    
    id mockError = [OCMockObject mockForClass:[NSError class]];
    [[mockError stub] localizedDescription];
    [[[mockError stub] andReturn:SocializeErrorDomain] domain];
    [[[mockError stub] andReturnInteger:SocializeErrorServerReturnedHTTPError] code];
    id mockRequest = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    [[[mockRequest stub] andReturnInteger:401] statusCode];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:mockRequest forKey:kSocializeErrorNSHTTPURLResponseKey];
    [[[mockError stub] andReturn:userInfo] userInfo];
    [[[mockError stub] andReturn:SocializeErrorDomain] domain];

    // Expect general failure flow
    [self expectServiceFailure];
    
    [self.viewController service:nil didFail:mockError];
}

- (void)testServiceFailureDoesNotShowAlertIfAlertsSilenced {
    id mockError = [OCMockObject niceMockForClass:[NSError class]];

    id observer = [self observerMockForUIError:mockError];
    [Socialize storeUIErrorAlertsDisabled:YES];
    [self.viewController service:nil didFail:mockError];
    [observer verify];
}

- (void)testBackgroundResetsOnShow {
    id mockNav = [OCMockObject mockForClass:[UINavigationController class]];
    id mockBar = [OCMockObject mockForClass:[UINavigationBar class]];
    [[[mockNav stub] andReturn:mockBar] navigationBar];
    [[mockBar expect] resetBackground];
    [self.viewController navigationController:mockNav didShowViewController:nil animated:YES];
}

- (void)testDoneWithDelegateCallsDelegate {
    [[self.mockDelegate expect] baseViewControllerDidFinish:self.origViewController];
    [self.viewController doneButtonPressed:nil];
}

- (void)testDoneWithoutDelegateDismissesSelf {
    [[(id)self.viewController expect] dismissModalViewControllerAnimated:YES];
    self.viewController.delegate = nil;
    [self.viewController doneButtonPressed:nil];
}


@end
