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

@implementation PostCommentViewControllerTests

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

-(void)testSendBtnPressedWithGeo
{
    id mockLocationManager = [OCMockObject mockForClass: [SocializeLocationManager class]];
    BOOL trueValue = YES;
    [[[mockLocationManager stub]andReturnValue:OCMOCK_VALUE(trueValue)]shouldShareLocation];
    
    id mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    [[mockSocialize expect] createCommentForEntityWithKey:TEST_URL comment:OCMOCK_ANY longitude:OCMOCK_ANY latitude:OCMOCK_ANY];
    BOOL retValue = YES;
    [[[mockSocialize stub]andReturnValue:OCMOCK_VALUE(retValue)]isAuthenticatedWithFacebook];
    
    ComposeMessageViewControllerForTest* controller = [[ComposeMessageViewControllerForTest alloc]initWithEntityUrlString:TEST_URL keyboardListener:nil locationManager:mockLocationManager];
    controller.socialize = mockSocialize;
    
    [controller performSelector: @selector(sendButtonPressed:)withObject:nil];
    
    [controller verify];
    [mockSocialize verify];
    
    [[mockSocialize expect] setDelegate:nil];
    [controller release];    
}

-(void)testSendBtnPressed
{
    id mockLocationManager = [OCMockObject mockForClass: [SocializeLocationManager class]];
    BOOL trueValue = NO;
    [[[mockLocationManager stub]andReturnValue:OCMOCK_VALUE(trueValue)]shouldShareLocation];
    
    id mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    [[mockSocialize expect] createCommentForEntityWithKey:TEST_URL comment:OCMOCK_ANY longitude:nil latitude:nil];
    BOOL retValue = YES;
    [[[mockSocialize stub]andReturnValue:OCMOCK_VALUE(retValue)]isAuthenticatedWithFacebook];
    
    ComposeMessageViewControllerForTest* controller = [[ComposeMessageViewControllerForTest alloc]initWithEntityUrlString:TEST_URL keyboardListener:nil locationManager:mockLocationManager];
    controller.socialize = mockSocialize;
    
    [controller performSelector: @selector(sendButtonPressed:)withObject:nil];
    
    [controller verify];
    [mockSocialize verify];
    
    [[mockSocialize expect] setDelegate:nil];
    [controller release];    
}

-(void)testEnableSendBtn
{
    ComposeMessageViewControllerForTest* controller = [[ComposeMessageViewControllerForTest alloc]initWithEntityUrlString:TEST_URL keyboardListener:nil locationManager:nil];

    id mockBtn = [OCMockObject niceMockForClass: [UIBarButtonItem class]];
    [[mockBtn expect] setEnabled:YES];
    controller.navigationItem.rightBarButtonItem = mockBtn;
  
    [[[(id)controller.commentTextView stub]andReturn: @"Sample text"] text];    

    [controller textViewDidChange: nil];
    
    [controller verify];
    [mockBtn verify];
    
    controller.navigationItem.rightBarButtonItem = nil;
     
    [controller release]; 
}

-(void)testDisableSendBtn
{
    ComposeMessageViewControllerForTest* controller = [[ComposeMessageViewControllerForTest alloc]initWithEntityUrlString:TEST_URL keyboardListener:nil locationManager:nil];
    
    id mockBtn = [OCMockObject niceMockForClass: [UIBarButtonItem class]];
    [[mockBtn expect] setEnabled:NO];
    controller.navigationItem.rightBarButtonItem = mockBtn;
    
    [[[(id)controller.commentTextView stub]andReturn: @""] text];    
    
    [controller textViewDidChange: nil];
    
    [controller verify];
    [mockBtn verify];
    
    controller.navigationItem.rightBarButtonItem = nil;
    
    [controller release]; 
}

@end
