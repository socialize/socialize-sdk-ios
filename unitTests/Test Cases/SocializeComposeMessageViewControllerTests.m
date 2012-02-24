//
//  SocializeComposeMessageViewControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/15/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeComposeMessageViewControllerTests.h"
#import "CommentMapView.h"
#import "SocializeLocationManager.h"
#import "UILabel+FormatedText.h"
#import "Socialize.h"
#import <OCMock/OCMock.h>
#import "CommentsTableViewCell.h"
#import "SocializeGeocoderAdapter.h"
#import "SocializeComposeMessageViewController.h"
#import "SocializeHorizontalContainerView.h"

@interface SocializeComposeMessageViewController ()
- (void)setShareLocation:(BOOL)shareLocation;
- (void)adjustForOrientation:(UIInterfaceOrientation)orientation;
- (void)configureDoNotShareLocationButton;
@end

#define TEST_URL @"test_entity_url"
#define TEST_LOCATION @"some_test_loaction_description"

@implementation SocializeComposeMessageViewControllerTests
@synthesize composeMessageViewController = composeMessageViewController_;
@synthesize mockSocialize = mockSocialize_;
@synthesize mockLocationManager = mockLocationManager_;
@synthesize mockUpperContainer = mockUpperContainer_;
@synthesize mockLowerContainer = mockLowerContainer_;
@synthesize mockMapContainer = mockMapContainer_;
@synthesize mockCommentTextView = mockCommentTextView_;
@synthesize mockLocationText = mockLocationText_;
@synthesize mockDoNotShareLocationButton = mockDoNotShareLocationButton_;
@synthesize mockActivateLocationButton = mockActivateLocationButton_;
@synthesize mockMapOfUserLocation = mockMapOfUserLocation_;
@synthesize mockDelegate = mockDelegate_;
@synthesize mockSendButton = mockSendButton_;
@synthesize mockMessageActionButtonContainer = mockMessageActionButtonContainer_;

+ (SocializeBaseViewController*)createController {
    return [[[SocializeComposeMessageViewController alloc] initWithEntityUrlString:TEST_URL] autorelease];
}

- (BOOL)shouldRunOnMainThread
{
    return YES;
}

- (void)setUp {
    [super setUp];
    
    self.composeMessageViewController = (SocializeComposeMessageViewController*)self.viewController;

    self.mockUpperContainer = [OCMockObject niceMockForClass:[UIView class]];
    self.composeMessageViewController.upperContainer = self.mockUpperContainer;
    
    self.mockLowerContainer = [OCMockObject niceMockForClass:[UIView class]];
    self.composeMessageViewController.lowerContainer = self.mockLowerContainer;

    self.mockMapContainer = [OCMockObject niceMockForClass: [UIView class]];
    self.composeMessageViewController.mapContainer = self.mockMapContainer;
    
    self.mockCommentTextView = [OCMockObject niceMockForClass: [UITextView class]];
    self.composeMessageViewController.commentTextView = self.mockCommentTextView;
    
    self.mockLocationText = [OCMockObject niceMockForClass: [UILabel class]];
    self.composeMessageViewController.locationText = self.mockLocationText;

    self.mockDoNotShareLocationButton = [OCMockObject niceMockForClass: [UIButton class]];
    self.composeMessageViewController.doNotShareLocationButton = self.mockDoNotShareLocationButton;

    self.mockActivateLocationButton = [OCMockObject niceMockForClass: [UIButton class]];
    self.composeMessageViewController.activateLocationButton = self.mockActivateLocationButton;

    self.mockMapOfUserLocation = [OCMockObject niceMockForClass: [CommentMapView class]];
    self.composeMessageViewController.mapOfUserLocation = self.mockMapOfUserLocation;

    [[[self.mockNavigationItem stub] andReturn:self.mockSendButton] rightBarButtonItem];
    [[[self.mockNavigationItem stub] andReturn:self.mockCancelButton] leftBarButtonItem];
    
    self.mockSendButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.composeMessageViewController.sendButton = self.mockSendButton;
    
    self.mockMessageActionButtonContainer = [OCMockObject mockForClass:[SocializeHorizontalContainerView class]];
    self.composeMessageViewController.messageActionButtonContainer = self.mockMessageActionButtonContainer;
    
    self.mockLocationManager = [OCMockObject mockForClass:[SocializeLocationManager class]];
    self.composeMessageViewController.locationManager = self.mockLocationManager;
}

- (void)tearDown {
    [(id)self.composeMessageViewController verify];
    [self.mockSocialize verify];
    [self.mockLocationManager verify];
    [self.mockUpperContainer verify];
    [self.mockLowerContainer verify];
    [self.mockMapContainer verify];
    [self.mockCommentTextView verify];
    [self.mockLocationText verify];
    [self.mockDoNotShareLocationButton verify];
    [self.mockActivateLocationButton verify];
    [self.mockMapOfUserLocation verify];
    [self.mockDelegate verify];
    [self.mockSendButton verify];
    [self.mockMessageActionButtonContainer verify];
    
    self.composeMessageViewController = nil;
    self.mockSocialize = nil;
    self.mockLocationManager = nil;
    self.mockMapContainer = nil;
    self.mockUpperContainer = nil;
    self.mockLowerContainer = nil;
    self.mockCommentTextView = nil;
    self.mockLocationText = nil;
    self.mockDoNotShareLocationButton = nil;
    self.mockActivateLocationButton = nil;
    self.mockMapOfUserLocation = nil;
    self.mockDelegate = nil;
    self.mockSendButton = nil;
    self.mockMessageActionButtonContainer = nil;
    
    [super tearDown];
}

-(void)testCreateMethod
{
    UINavigationController* controller = [SocializePostCommentViewController postCommentViewControllerInNavigationControllerWithEntityURL:TEST_URL delegate:nil];
    GHAssertNotNil(controller, nil);
}

-(void)testactivateLocationButtonPressedWithVisibleKB
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kSocializeShouldShareLocationKey];
    [[[self.mockCommentTextView stub] andReturnBool:YES] isFirstResponder];

    // Keyboard should hide
    [[self.mockCommentTextView expect] resignFirstResponder];
    
    [self.composeMessageViewController activateLocationButtonPressed:nil]; 
}

-(void)testactivateLocationButtonPressedWithInvisibleKB
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kSocializeShouldShareLocationKey];
    [[[self.mockCommentTextView stub] andReturnBool:NO] isFirstResponder];

    // Keyboard should show
    [[self.mockCommentTextView expect] becomeFirstResponder];
    
    [self.composeMessageViewController activateLocationButtonPressed:nil]; 
}

-(void)testdoNotShareLocationButtonPressed
{   
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kSocializeShouldShareLocationKey];

    [[self.mockCommentTextView expect]becomeFirstResponder];
//    [[self.mockLocationText expect] text:@"Location will not be shared."  withFontName: @"Helvetica-Oblique"  withFontSize: 12.0 withColor:OCMOCK_ANY];
//    [[(id)self.composeMessageViewController expect] setShareLocation:NO];
    
    [self.composeMessageViewController doNotShareLocationButtonPressed:nil]; 
    BOOL shareLocation = [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeShouldShareLocationKey] boolValue];
    GHAssertFalse(shareLocation, @"Should have been set false");
}

-(void)testSupportOrientation
{
    GHAssertTrue([self.composeMessageViewController shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait], nil);
    GHAssertTrue([self.composeMessageViewController shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft], nil);
    GHAssertTrue([self.composeMessageViewController shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight], nil);
    GHAssertFalse([self.composeMessageViewController shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown], nil);
}

#define STATUS_BAR_HEIGHT 20
#define NAVIGATION_BAR_HEIGHT 32

- (void)testAdjustingForNewKeyboard {
    CGRect testViewFrame = CGRectMake(0, 0, 480, 268);
    [[[self.mockView stub] andReturnValue:OCMOCK_VALUE(testViewFrame)] frame];
    CGRect keyboardEndFrame = CGRectMake(158, 0, 162, 480);
    
    // An example landscape keyboard in view coordinates, (for a view shifted down 52px for status and navigation bar)
    CGRect keyboardEndFrameInViewCoordinates = CGRectMake(0, 106, 480, 162);
    [[[self.mockKeyboardListener stub] andReturnValue:OCMOCK_VALUE(keyboardEndFrameInViewCoordinates)] convertKeyboardRect:keyboardEndFrame toView:self.mockView];

    // Lower container should become keyboard frame
    [[self.mockLowerContainer expect] setFrame:keyboardEndFrameInViewCoordinates];
    
    // Upper container should become remainder
    CGFloat keyboardHeight = keyboardEndFrameInViewCoordinates.size.height;
    CGFloat upperHeight = testViewFrame.size.height - keyboardHeight;
    [[self.mockUpperContainer expect] setFrame:CGRectMake(0, 0, testViewFrame.size.width, upperHeight)];

    [self.composeMessageViewController keyboardListener:nil keyboardWillShowWithWithBeginFrame:CGRectZero endFrame:keyboardEndFrame animationCurve:UIViewAnimationCurveEaseIn animationDuration:.3f];
}

- (void)prepareForViewDidLoad {
    
    [[(id)self.composeMessageViewController expect] configureDoNotShareLocationButton];
    [[self.mockNavigationItem expect] setLeftBarButtonItem:self.mockCancelButton];
    [[self.mockNavigationItem expect] setRightBarButtonItem:self.mockSendButton];
    [[self.mockSendButton expect] setEnabled:NO];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kSocializeShouldShareLocationKey];
}

- (void)testViewDidLoad {
    [self prepareForViewDidLoad];
    [(id)self.composeMessageViewController viewDidLoad];
}

- (void)testAllowingLocationUpdatesBar {
    CLAuthorizationStatus status = kCLAuthorizationStatusAuthorized;
    NSValue *statusValue = [NSValue valueWithBytes:&status objCType:@encode(CLAuthorizationStatus)];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:statusValue forKey:kSocializeCLAuthorizationStatusKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeCLAuthorizationStatusDidChangeNotification object:self userInfo:userInfo];
}

- (void)testMapViewLocationUpdateUpdatesLocationManager {
    id mockMKUserLocation = [OCMockObject niceMockForClass:[MKUserLocation class]];
    id mockLocation = [OCMockObject niceMockForClass:[CLLocation class]];
    [[[mockMKUserLocation stub] andReturn:mockLocation] location];
    [[self.mockLocationManager expect] setLastLocation:mockLocation];
    
    [self.composeMessageViewController mapView:nil didUpdateUserLocation:mockMKUserLocation];
}

@end
