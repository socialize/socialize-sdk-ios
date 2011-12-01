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
#import "UIKeyboardListener.h"
#import "UILabel+FormatedText.h"
#import "Socialize.h"
#import <OCMock/OCMock.h>
#import "CommentsTableViewCell.h"
#import "SocializeGeocoderAdapter.h"
#import "SocializeComposeMessageViewController.h"

@interface SocializeComposeMessageViewController ()
- (void)setShareLocation:(BOOL)shareLocation;
- (void)adjustForOrientation:(UIInterfaceOrientation)orientation;
@end

#define TEST_URL @"test_entity_url"
#define TEST_LOCATION @"some_test_loaction_description"

@implementation SocializeComposeMessageViewControllerTests
@synthesize composeMessageViewController = composeMessageViewController_;
@synthesize mockView = mockView_;
@synthesize mockSocialize = mockSocialize_;
@synthesize mockLocationManager = mockLocationManager_;
@synthesize mockKbListener = mockKbListener_;
@synthesize mockLocationViewContainer = mockLocationViewContainer_;
@synthesize mockMapContainer = mockMapContainer_;
@synthesize mockCommentTextView = mockCommentTextView_;
@synthesize mockLocationText = mockLocationText_;
@synthesize mockDoNotShareLocationButton = mockDoNotShareLocationButton_;
@synthesize mockActivateLocationButton = mockActivateLocationButton_;
@synthesize mockMapOfUserLocation = mockMapOfUserLocation_;

+ (SocializeBaseViewController*)createController {
    return [[[SocializeComposeMessageViewController alloc] initWithNibName:nil bundle:nil entityUrlString:TEST_URL] autorelease];
}

- (BOOL)shouldRunOnMainThread
{
    return YES;
}

- (void)setUp {
    [super setUp];
    
    self.composeMessageViewController = (SocializeComposeMessageViewController*)self.viewController;

    self.mockView = [OCMockObject niceMockForClass:[UIView class]];
    [[[(id)self.composeMessageViewController stub] andReturn:self.mockView] view];
    
    self.mockLocationManager = [OCMockObject mockForClass:[SocializeLocationManager class]];
    self.composeMessageViewController.locationManager = self.mockLocationManager;
    
    self.mockKbListener = [OCMockObject mockForClass:[UIKeyboardListener class]];
    self.composeMessageViewController.kbListener = self.mockKbListener;

    self.mockLocationViewContainer = [OCMockObject niceMockForClass:[UIView class]];
    self.composeMessageViewController.locationViewContainer = self.mockLocationViewContainer;
    
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
}

- (void)tearDown {
    [super tearDown];
    
    [(id)self.composeMessageViewController verify];
    [self.mockSocialize verify];
    [self.mockLocationManager verify];
    [self.mockKbListener verify];
    [self.mockLocationViewContainer verify];
    [self.mockMapContainer verify];
    [self.mockCommentTextView verify];
    [self.mockLocationText verify];
    [self.mockDoNotShareLocationButton verify];
    [self.mockActivateLocationButton verify];
    [self.mockMapOfUserLocation verify];
    
    self.composeMessageViewController = nil;
    self.mockSocialize = nil;
    self.mockLocationManager = nil;
    self.mockMapContainer = nil;
    self.mockKbListener = nil;
    self.mockLocationViewContainer = nil;
    self.mockCommentTextView = nil;
    self.mockLocationText = nil;
    self.mockDoNotShareLocationButton = nil;
    self.mockActivateLocationButton = nil;
    self.mockMapOfUserLocation = nil;

}

-(void)testCreateMethod
{
    UINavigationController* controller = [SocializePostCommentViewController postCommentViewControllerInNavigationControllerWithEntityURL:TEST_URL];
    GHAssertNotNil(controller, nil);
}

-(void)testactivateLocationButtonPressedWithVisibleKB
{
    BOOL trueValue = YES;
    [[[self.mockLocationManager stub]andReturnValue:OCMOCK_VALUE(trueValue)]shouldShareLocation];
    
    [[[self.mockKbListener stub]andReturnValue:OCMOCK_VALUE(trueValue)]isVisible];
    
    [[self.mockCommentTextView expect] resignFirstResponder];
    
    [self.composeMessageViewController activateLocationButtonPressed:nil]; 
}

-(void)testactivateLocationButtonPressedWithInvisibleKB
{
    BOOL trueValue = YES;
    [[[self.mockLocationManager stub]andReturnValue:OCMOCK_VALUE(trueValue)]shouldShareLocation];
    
    BOOL falseValue = NO;
    [[[self.mockKbListener stub] andReturnValue:OCMOCK_VALUE(falseValue)] isVisible];
    
    
    [[self.mockCommentTextView expect]becomeFirstResponder];
    
    [self.composeMessageViewController activateLocationButtonPressed:nil]; 
}

-(void)testdoNotShareLocationButtonPressed
{   
    BOOL falseValue = NO;
    [[[self.mockLocationManager stub]andReturnValue:OCMOCK_VALUE(falseValue)]shouldShareLocation];

    [[self.mockLocationManager expect] setShouldShareLocation:NO];
    [[self.mockCommentTextView expect]becomeFirstResponder];
    [[self.mockLocationText expect] text:@"Location will not be shared."  withFontName: @"Helvetica-Oblique"  withFontSize: 12.0 withColor:OCMOCK_ANY];
//    [[(id)self.composeMessageViewController expect] setShareLocation:NO];
    
    [self.composeMessageViewController doNotShareLocationButtonPressed:nil]; 
}

-(void)testSupportOrientation
{
//    GHAssertTrue([self.composeMessageViewController shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortrait], nil);
}

-(void)testSupportLandscapeRotation
{
    BOOL onIos5 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0;
    BOOL shouldRotateLandscape = [self.composeMessageViewController shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    
    GHAssertEquals(onIos5, shouldRotateLandscape, nil);
}

- (void)testLandscapeLayout {
    SocializeComposeMessageViewController * controller = [[SocializePostCommentViewController alloc] initWithNibName:@"SocializeComposeMessageViewControllerLandscape" 
                                                                                                           bundle:nil 
                                                                                                  entityUrlString:TEST_URL
                                                       ];
    
//    [controller shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    [controller adjustForOrientation:UIInterfaceOrientationLandscapeRight];
    
    int keyboardHeigth = 162;
    int viewWidth = 460;
    int viewHeight = 320;
    int aciviticontainerHeight = 39;
    CGRect expectedCommentFrame = CGRectMake(0,0, viewWidth, viewHeight - aciviticontainerHeight - keyboardHeigth);
    CGRect expectedActivityLocationFrame = CGRectMake(0, expectedCommentFrame.origin.y + expectedCommentFrame.size.height, viewWidth, aciviticontainerHeight);
    CGRect expectedMapContainerFrame = CGRectMake(0,viewHeight - keyboardHeigth, viewWidth, keyboardHeigth);
    
    GHAssertTrue(CGRectEqualToRect(expectedCommentFrame, controller.commentTextView.frame), nil);
    GHAssertTrue(CGRectEqualToRect(expectedActivityLocationFrame, controller.locationViewContainer.frame), nil);    
    GHAssertTrue(CGRectEqualToRect(expectedMapContainerFrame, controller.mapContainer.frame), nil);    
}

-(void)testPortraitLayout
{   
    SocializePostCommentViewController * controller = [[SocializePostCommentViewController alloc] initWithNibName:@"SocializeComposeMessageViewController" 
                                                                                                           bundle:nil 
                                                                                                  entityUrlString:TEST_URL
                                                       ];
    
    [controller adjustForOrientation:UIInterfaceOrientationPortrait];
//    [controller shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
    
    int keyboardHeigth = 216;
    int viewWidth = 320;
    int viewHeight = 460;
    int aciviticontainerHeight = 39;
    CGRect expectedCommentFrame = CGRectMake(0,0, viewWidth, viewHeight - aciviticontainerHeight - keyboardHeigth);
    CGRect expectedActivityLocationFrame = CGRectMake(0, expectedCommentFrame.origin.y + expectedCommentFrame.size.height, viewWidth, aciviticontainerHeight);
    CGRect expectedMapContainerFrame = CGRectMake(0,viewHeight - keyboardHeigth, viewWidth, keyboardHeigth);
    
    GHAssertTrue(CGRectEqualToRect(expectedCommentFrame, controller.commentTextView.frame), nil);
    GHAssertTrue(CGRectEqualToRect(expectedActivityLocationFrame, controller.locationViewContainer.frame), nil);    
    GHAssertTrue(CGRectEqualToRect(expectedMapContainerFrame, controller.mapContainer.frame), nil);    
}

- (void)prepareForViewDidLoad {
    [[self.mockNavigationItem expect] setLeftBarButtonItem:self.mockCancelButton];
    [[self.mockNavigationItem expect] setRightBarButtonItem:self.mockSendButton];
    [[self.mockSendButton expect] setEnabled:NO];
    [[self.mockCancelButton expect] setEnabled:NO];
    BOOL noValue = NO;
    [[[self.mockLocationManager stub] andReturnValue:OCMOCK_VALUE(noValue)] shouldShareLocation];
    [[self.mockLocationManager expect] setShouldShareLocation:NO];
}

- (void)testViewDidLoad {
    [self prepareForViewDidLoad];
    [(id)self.composeMessageViewController viewDidLoad];
}


@end
