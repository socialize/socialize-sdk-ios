/*
 * PostCommentViewControllerTests.m
 * SocializeSDK
 *
 * Created on 9/7/11.
 * 
 * Copyright (c) 2011 Socialize, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * See Also: http://gabriel.github.com/gh-unit/
 */

#import "PostCommentViewControllerTests.h"
#import "CommentMapView.h"
#import "SocializeLocationManager.h"
#import "UILabel+FormatedText.h"
#import "Socialize.h"
#import <OCMock/OCMock.h>
#import "CommentsTableViewCell.h"
#import "SocializeGeocoderAdapter.h"
#import "SocializePrivateDefinitions.h"
#import "SocializeSubscriptionService.h"
#import "SocializeHorizontalContainerView.h"
#import "SocializeCommentCreator.h"
#import "SocializeFacebookAuthenticator.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeThirdPartyTwitter.h"
#import "SocializeTwitterAuthenticator.h"

#define TEST_URL @"test_entity_url"
#define TEST_LOCATION @"some_test_loaction_description"

@interface SocializePostCommentViewController (Tests)
- (void)dismissSelf;
- (void)configureFacebookButton;
@end

@implementation PostCommentViewControllerTests
@synthesize postCommentViewController = postCommentViewController_;
@synthesize mockFacebookButton = mockFacebookButton_;
@synthesize mockTwitterButton = mockTwitterButton_;
@synthesize mockUnsubscribeButton = mockUnsubscribeButton_;
@synthesize mockEnableSubscribeButton = mockEnableSubscribeButton_;
@synthesize mockSubscribeContainer = mockSubscribeContainer_;

+ (SocializeBaseViewController*)createController {
    return [SocializePostCommentViewController postCommentViewControllerWithEntityURL:TEST_URL];
}

- (void)setUp {
    [super setUp];
    
    [SocializeCommentCreator startMockingClass];
    [SocializeThirdPartyFacebook startMockingClass];
    [SocializeFacebookAuthenticator startMockingClass];
    [SocializeThirdPartyTwitter startMockingClass];
    [SocializeTwitterAuthenticator startMockingClass];
    
    // super setUp creates self.viewController
    self.postCommentViewController = (SocializePostCommentViewController*)self.viewController;
    
    self.mockFacebookButton = [OCMockObject mockForClass:[UIButton class]];
    self.postCommentViewController.facebookButton = self.mockFacebookButton;
    
    self.mockTwitterButton = [OCMockObject mockForClass:[UIButton class]];
    self.postCommentViewController.twitterButton = self.mockTwitterButton;

    self.mockUnsubscribeButton = [OCMockObject mockForClass:[UIButton class]];
    self.postCommentViewController.unsubscribeButton = self.mockUnsubscribeButton;
    
    self.mockEnableSubscribeButton = [OCMockObject mockForClass:[UIButton class]];
    self.postCommentViewController.enableSubscribeButton = self.mockEnableSubscribeButton;
    
    self.mockSubscribeContainer = [OCMockObject mockForClass:[UIView class]];
    self.postCommentViewController.subscribeContainer = self.mockSubscribeContainer;
    
}

- (void)tearDown {
    [SocializeCommentCreator stopMockingClassAndVerify];
    [SocializeThirdPartyFacebook stopMockingClassAndVerify];
    [SocializeFacebookAuthenticator stopMockingClassAndVerify];
    [SocializeThirdPartyTwitter stopMockingClassAndVerify];
    [SocializeTwitterAuthenticator stopMockingClassAndVerify];
    
    [self.mockFacebookButton verify];
    
    self.postCommentViewController = nil;
    self.mockFacebookButton = nil;
    
    [super tearDown];
}

// By default NO, but if you have a UI test or test dependent on running on the main thread return YES
- (BOOL)shouldRunOnMainThread
{
    return YES;
}

/*
-(void)testInit
{
    id mockLocationManager = [OCMockObject mockForClass: [SocializeLocationManager class]];
    BOOL trueValue = YES;
    [[[mockLocationManager stub]andReturnValue:OCMOCK_VALUE(trueValue)]shouldShareLocation];
    [[mockLocationManager expect]setShouldShareLocation:YES];
    [[[mockLocationManager stub]andReturnValue:OCMOCK_VALUE(trueValue)]applicationIsAuthorizedToUseLocationServices];
    [[[mockLocationManager stub]andReturn:TEST_LOCATION]currentLocationDescription];
    
    
    PostCommentViewControllerForTest* controller = [[PostCommentViewControllerForTest alloc]initWithEntityUrlString:TEST_URL keyboardListener:nil locationManager:mockLocationManager];
    
    [[(id)controller.commentTextView expect]becomeFirstResponder];
    [[(id)controller.mapOfUserLocation expect]configurate];
    [[(id)controller.activateLocationButton expect]setImage:OCMOCK_ANY forState:UIControlStateNormal];
    [[(id)controller.activateLocationButton expect]setImage:OCMOCK_ANY forState:UIControlStateHighlighted];
    
    id mockSocialize = [OCMockObject mockForClass: [Socialize class]];
    BOOL retValue = YES;
    [[[mockSocialize stub]andReturnValue:OCMOCK_VALUE(retValue)] isAuthenticated];
    
    controller.socialize =  mockSocialize;
    
    [controller viewDidLoad];
    [controller viewWillAppear:YES];

    GHAssertNotNil(controller.view, nil);
    GHAssertEqualStrings(controller.title, @"New Comment", nil);
    GHAssertNotNil(controller.navigationItem.leftBarButtonItem, nil);
    GHAssertNotNil(controller.navigationItem.rightBarButtonItem, nil);
    
    [controller verify];
    [mockSocialize verify];
    
    [[mockSocialize expect] setDelegate:nil];
    [controller viewDidUnload];
    [controller release];
}
*/

- (void)expectCreateComment {
    [[self.mockSendButton expect] setEnabled:NO];
    [[SocializeCommentCreator expect] createComment:OCMOCK_ANY options:OCMOCK_ANY display:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

-(void)testSendButtonPressedWithGeo
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kSocializeShouldShareLocationKey];

    [self expectCreateComment];
    [[[(id)self.viewController stub]andReturnBool:NO] shouldShowAuthViewController];
    
    [self.postCommentViewController performSelector: @selector(sendButtonPressed:)withObject:nil];
}

-(void)testSendButtonPressed
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kSocializeShouldShareLocationKey];
    
    [self expectCreateComment];
    [[[(id)self.viewController stub]andReturnBool:NO] shouldShowAuthViewController];
    

    [self.postCommentViewController performSelector: @selector(sendButtonPressed:)withObject:nil];
}

-(void)testEnableSendButtonWhenCommentTextPopulated
{
    [[[self.mockCommentTextView stub]andReturn: @"Sample text"] text];    

    [[self.mockSendButton expect] setEnabled:YES];
    [self.postCommentViewController textViewDidChange: nil];
}

-(void)testDisableSendButtonWhenCommentTextEmpty
{
    [[[self.mockCommentTextView stub]andReturn: @""] text];    
    [[self.mockSendButton expect] setEnabled:NO];
    [self.postCommentViewController textViewDidChange: nil];
    [self.mockSendButton verify];
}
/*
- (void)testViewDidUnloadFreesViews {
    [[(id)self.postCommentViewController expect] setFacebookButton:nil];
    [self.postCommentViewController viewDidUnload];
}*/

- (id)mockMKUserLocationWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    id mockLocation = [OCMockObject mockForClass:[CLLocation class]];
    [[[mockLocation stub] andReturnValue:OCMOCK_VALUE(coordinate)] coordinate];
    id mockUserLocation = [OCMockObject mockForClass:[MKUserLocation class]];
    [[[mockUserLocation stub] andReturn:mockLocation] location];

    return mockUserLocation;
}

//- (void)testFinishCreateCommentCreatesSocializeCommentIfNeeded {
//    NSString *testText = @"testText";
//    
//    CLLocationDegrees latitude = 1.1;
//    CLLocationDegrees longitude = 1.2;
//    NSNumber *latitudeNumber = [NSNumber numberWithFloat:latitude];
//    NSNumber *longitudeNumber = [NSNumber numberWithFloat:longitude];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kSocializeShouldShareLocationKey];
//
//    id mockLocation = [self mockMKUserLocationWithLatitude:latitude longitude:longitude];
//    [[[self.mockMapOfUserLocation stub] andReturn:mockLocation] userLocation];
//    [[[self.mockCommentTextView stub] andReturn:testText] text];
//    [[self.mockSendButton expect] setEnabled:NO];
////    [[self.mockCancelButton expect] setEnabled:NO];
//    [[self.mockSocialize expect] createCommentForEntityWithKey:TEST_URL comment:testText longitude:longitudeNumber latitude:latitudeNumber subscribe:YES];
//
//    [self.postCommentViewController createComment];
//}

- (void)ignoreButtons {
    [self.mockFacebookButton makeNice];
    [self.mockTwitterButton makeNice];
    [self.mockMessageActionButtonContainer makeNice];
    [self.mockEnableSubscribeButton makeNice];
    [self.mockUnsubscribeButton makeNice];
    [self.mockSendButton makeNice];
}

- (void)testAuthingWithFacebookCreatesComment {
    [self ignoreTwitter];
    
    [[[SocializeThirdPartyFacebook stub] andReturnBool:YES] isLinkedToSocialize];
    [[[SocializeThirdPartyFacebook stub] andReturnBool:YES] available];
    
    [self ignoreButtons];
    
    [self expectCreateComment];
    // Authenticate view controller completed facebook auth
    [self.postCommentViewController socializeAuthViewController:nil didAuthenticate:nil];
}

- (void)testMessageActionButtonsWhenEverythingAvailable {
    [[[SocializeThirdPartyFacebook stub] andReturnBool:YES] available];
    [[[SocializeThirdPartyTwitter stub] andReturnBool:YES] available];
    [[[self.mockSocialize stub] andReturnBool:YES] notificationsAreConfigured];
    
    [[[(id)self.postCommentViewController expect] andDo1:^(NSArray *buttons) {
        GHAssertTrue([buttons containsObject:self.mockTwitterButton], nil);
        GHAssertTrue([buttons containsObject:self.mockFacebookButton], nil);
        GHAssertTrue([buttons containsObject:self.mockEnableSubscribeButton], nil);
    }] setMessageActionButtons:OCMOCK_ANY];
    
    [self.postCommentViewController configureMessageActionButtons];
}

-(void) prepareForViewDidLoad {
    [[(id)self.postCommentViewController expect] configureFacebookButton];
    [[(id)self.postCommentViewController expect] addSocializeRoundedGrayButtonImagesToButton:OCMOCK_ANY];
    [[(id)self.postCommentViewController expect] setDontSubscribeToDiscussion:NO];        
    [[self.mockEnableSubscribeButton expect] setEnabled:NO];

    // We are authenticated, expect to get subscription right away
    [[[self.mockSocialize stub] andReturnBool:YES] isAuthenticated];
    [[(id)self.postCommentViewController expect] getSubscriptionStatus];
}

-(void) testViewDidLoad {
    [super prepareForViewDidLoad];
    [self prepareForViewDidLoad];
    [self.postCommentViewController viewDidLoad];
}

- (void)postCommentViewController:(SocializePostCommentViewController *)postCommentViewController didCreateComment:(id<SocializeComment>)comment {
    [self notify:kGHUnitWaitStatusSuccess];
}

- (void)testThatBigUnsubscribeButtonUpdatesOtherButtonAndDontSubscribeState {
    [[self.mockCommentTextView expect] becomeFirstResponder];
    [[self.mockEnableSubscribeButton expect] setSelected:NO];
    
    GHAssertFalse(self.postCommentViewController.dontSubscribeToDiscussion, @"Should be subscribed");
    [self.postCommentViewController unsubscribeButtonPressed:nil];
    GHAssertTrue(self.postCommentViewController.dontSubscribeToDiscussion, @"Should not be subscribed");
}

- (void)testThatPressingEnableSubscribeWhenNotSubscribedReenablesSubscribe {
    [[self.mockLowerContainer expect] addSubview:self.mockSubscribeContainer];

    // Test frame data for lower container
    CGRect lowerFrame = CGRectMake(0, 0, 320, 180);
    [[[self.mockLowerContainer stub] andReturnValue:OCMOCK_VALUE(lowerFrame)] frame];

    // Preconfigure the subscription status, and expect disable on state because of this
    [[self.mockEnableSubscribeButton expect] setSelected:NO];
    self.postCommentViewController.dontSubscribeToDiscussion = YES;
    
    // Expect reenable on state for enable subscribe button
    [[self.mockEnableSubscribeButton expect] setSelected:YES];

    // Frame should be set to exactly match lower container
    [[self.mockSubscribeContainer expect] setFrame:CGRectMake(0, 0, lowerFrame.size.width, lowerFrame.size.height)];

    [self.postCommentViewController enableSubscribeButtonPressed:nil];
    GHAssertFalse(self.postCommentViewController.dontSubscribeToDiscussion, @"Should be subscribed");
}

- (void)testEnableSubscribeWhenKeyboardShownHidesKeyboardAndChangesLowerContainer {
    
    // Test frame data for lower container
    CGRect lowerFrame = CGRectMake(0, 0, 320, 180);
    [[[self.mockLowerContainer stub] andReturnValue:OCMOCK_VALUE(lowerFrame)] frame];
    
    // Keyboard is shown
    [[[self.mockCommentTextView expect] andReturnBool:YES] isFirstResponder];

    // Keyboard should hide
    [[self.mockCommentTextView expect] resignFirstResponder];

    // Lower view should update, since it is being exposed
    [[self.mockLowerContainer expect] addSubview:self.mockSubscribeContainer];

    // Frame should be set to exactly match lower container
    [[self.mockSubscribeContainer expect] setFrame:CGRectMake(0, 0, lowerFrame.size.width, lowerFrame.size.height)];
    
    [self.postCommentViewController enableSubscribeButtonPressed:nil];
}

- (void)testEnableSubscribeWhenKeyboardHiddenShowsKeyboardDoesNotChangeLowerView {
    
    // Keyboard is shown
    [[[self.mockCommentTextView expect] andReturnBool:NO] isFirstResponder];
    
    // Keyboard should show
    [[self.mockCommentTextView expect] becomeFirstResponder];
    
    // And nothing else should happen
    //
    
    [self.postCommentViewController enableSubscribeButtonPressed:nil];
}

- (void)testThatFetchingSubscriptionWithSubscribedFalseSetsDontSubscribeToDiscussion {
    
    // Create a negative subscription
    id mockSubscription = [OCMockObject mockForProtocol:@protocol(SocializeSubscription)];
    [[[mockSubscription stub] andReturnBool:NO] subscribed];
    NSArray *dataArray = [NSArray arrayWithObject:mockSubscription];
    
    // Message is from the subscription service class
    id mockService = [OCMockObject mockForClass:[SocializeSubscriptionService class]];
    [mockService stubIsKindOfClass:[SocializeSubscriptionService class]];
    
    // Should always reenable once subscription status is known
    [[self.mockEnableSubscribeButton expect] setEnabled:YES];
    
    // Selection state should be off, to reflect that we are not subscribed
    [[self.mockEnableSubscribeButton expect] setSelected:NO];
    
    [self.postCommentViewController service:mockService didFetchElements:dataArray];
}

- (void)ignoreFacebook {
    [[SocializeThirdPartyFacebook stub] isLinkedToSocialize];
    [[SocializeThirdPartyFacebook stub] available];
}

- (void)ignoreTwitter {
    [[SocializeThirdPartyTwitter stub] isLinkedToSocialize];
    [[SocializeThirdPartyTwitter stub] available];
}

- (void)testAfterLoginGetsSubscriptionIfUserChanged {
    [self ignoreFacebook];
    [self ignoreTwitter];
    [self ignoreButtons];
    
    NSString *testKey = @"testKey";
    self.postCommentViewController.entityURL = testKey;
    
    // don't care about these here
    self.mockFacebookButton = self.postCommentViewController.facebookButton = [OCMockObject niceMockForClass:[UIButton class]];    
    self.mockMessageActionButtonContainer = self.postCommentViewController.messageActionButtonContainer = [OCMockObject niceMockForClass:[SocializeHorizontalContainerView class]];
    
    [[self.mockEnableSubscribeButton expect] setEnabled:NO];
    [[self.mockSocialize expect] getSubscriptionsForEntityKey:testKey first:nil last:nil];
    [self.postCommentViewController afterLoginAction:YES];
}

- (void)expectTwitterLogin {
    [[SocializeTwitterAuthenticator expect] authenticateViaTwitterWithOptions:OCMOCK_ANY display:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];

}

- (void)testPressingTwitterButtonAttemptsLogin {
    [[[SocializeThirdPartyTwitter stub] andReturnBool:NO] isLinkedToSocialize];
    [[[self.mockTwitterButton stub] andReturnBool:NO] isSelected];
    
    [self expectTwitterLogin];
    
    [self.postCommentViewController twitterButtonPressed:self.mockTwitterButton];
}

@end
