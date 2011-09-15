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
#import "PostCommentViewControllerForTest.h"
#import "CommentMapView.h"
#import <OCMock/OCMock.h>

#define TEST_URL @"test_entity_url"

@implementation PostCommentViewControllerTests

// By default NO, but if you have a UI test or test dependent on running on the main thread return YES
- (BOOL)shouldRunOnMainThread
{
    return YES;
}

-(void)testInit
{
    PostCommentViewControllerForTest* controller = [[PostCommentViewControllerForTest alloc]initWithEntityUrlString:TEST_URL keyboardListener:nil locationManager:nil];
    [controller viewDidLoad];
    [controller viewDidAppear:YES];

    GHAssertNotNil(controller.view, nil);
    GHAssertEqualStrings(controller.title, @"New Comment", nil);
    GHAssertNotNil(controller.navigationItem.leftBarButtonItem, nil);
    GHAssertNotNil(controller.navigationItem.rightBarButtonItem, nil);
    
    [[(id)controller.commentTextView expect]becomeFirstResponder];
    [[(id)controller.mapOfUserLocation expect]configurate];
    
    [controller viewDidUnload];
    [controller verify];
    
    [controller release];
}

-(void)testCreateMethod
{
    UINavigationController* controller = [PostCommentViewControllerForTest createAndShowPostViewControllerWithEntityUrl:TEST_URL andImageForNavBar:nil];
    GHAssertNotNil(controller, nil);
}

@end
