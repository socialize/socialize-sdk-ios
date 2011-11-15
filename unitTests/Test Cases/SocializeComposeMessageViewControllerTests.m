//
//  SocializeComposeMessageViewControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/15/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeComposeMessageViewControllerTests.h"
#import "ComposeMessageViewControllerForTest.h"
#import "CommentMapView.h"
#import "SocializeLocationManager.h"
#import "UIKeyboardListener.h"
#import "UILabel+FormatedText.h"
#import "Socialize.h"
#import <OCMock/OCMock.h>
#import "CommentsTableViewCell.h"
#import "SocializeGeocoderAdapter.h"

#define TEST_URL @"test_entity_url"
#define TEST_LOCATION @"some_test_loaction_description"

@implementation SocializeComposeMessageViewControllerTests

- (BOOL)shouldRunOnMainThread
{
    return YES;
}

-(void)testCreateMethod
{
    UINavigationController* controller = [ComposeMessageViewControllerForTest postCommentViewControllerInNavigationControllerWithEntityURL:TEST_URL];
    GHAssertNotNil(controller, nil);
}

-(void)testactivateLocationButtonPressedWithVisibleKB
{
    id mockLocationManager = [OCMockObject mockForClass: [SocializeLocationManager class]];
    BOOL trueValue = YES;
    [[[mockLocationManager stub]andReturnValue:OCMOCK_VALUE(trueValue)]shouldShareLocation];
    
    id mockKbListener = [OCMockObject mockForClass: [UIKeyboardListener class]];
    [[[mockKbListener stub]andReturnValue:OCMOCK_VALUE(trueValue)]isVisible];
    
    ComposeMessageViewControllerForTest* controller = [[ComposeMessageViewControllerForTest alloc]initWithEntityUrlString:TEST_URL keyboardListener:mockKbListener locationManager:mockLocationManager];
    
    [[(id)controller.commentTextView expect]resignFirstResponder];
    
    [controller activateLocationButtonPressed:nil]; 
    
    [controller verify];   
    [controller release];
}

-(void)testactivateLocationButtonPressedWithInvisibleKB
{
    id mockLocationManager = [OCMockObject mockForClass: [SocializeLocationManager class]];
    BOOL trueValue = YES;
    [[[mockLocationManager stub]andReturnValue:OCMOCK_VALUE(trueValue)]shouldShareLocation];
    
    id mockKbListener = [OCMockObject mockForClass: [UIKeyboardListener class]];
    BOOL falseValue = NO;
    [[[mockKbListener stub]andReturnValue:OCMOCK_VALUE(falseValue)]isVisible];
    
    ComposeMessageViewControllerForTest* controller = [[ComposeMessageViewControllerForTest alloc]initWithEntityUrlString:TEST_URL keyboardListener:mockKbListener locationManager:mockLocationManager];
    
    [[(id)controller.commentTextView expect]becomeFirstResponder];
    
    [controller activateLocationButtonPressed:nil]; 
    
    [controller verify];   
    [controller release];
}

-(void)testdoNotShareLocationButtonPressed
{   
    ComposeMessageViewControllerForTest* controller = [[ComposeMessageViewControllerForTest alloc]initWithEntityUrlString:TEST_URL keyboardListener:nil locationManager:nil];
    
    [[(id)controller.commentTextView expect]becomeFirstResponder];
    [[(id)controller.locationText expect] text:@"Location will not be shared."  withFontName: @"Helvetica-Oblique"  withFontSize: 12.0 withColor:OCMOCK_ANY];
    
    [controller doNotShareLocationButtonPressed:nil]; 
    
    [controller verify];   
    [controller release];
}

-(void)testSupportOrientation
{
    ComposeMessageViewControllerForTest* controller = [[ComposeMessageViewControllerForTest alloc]initWithEntityUrlString:TEST_URL keyboardListener:nil locationManager:nil];
    GHAssertTrue([controller shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortrait], nil);
    
    [controller release];
}

-(void)testSupportLandscapeRotation
{
    ComposeMessageViewControllerForTest* controller = [[ComposeMessageViewControllerForTest alloc]initWithEntityUrlString:TEST_URL keyboardListener:nil locationManager:nil];
    GHAssertTrue([controller shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft], nil);
}

-(void)testLandscapeLayout
{   
    SocializePostCommentViewController * controller = [[SocializePostCommentViewController alloc] initWithNibName:@"SocializeComposeMessageViewControllerLandscape" 
                                                                                                           bundle:nil 
                                                                                                  entityUrlString:TEST_URL
                                                       ];
    
    [controller shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    
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
    SocializePostCommentViewController * controller = [[SocializePostCommentViewController alloc] initWithNibName:@"SocializePostCommentViewController" 
                                                                                                           bundle:nil 
                                                                                                  entityUrlString:TEST_URL
                                                       ];
    
    [controller shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
    
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



@end
