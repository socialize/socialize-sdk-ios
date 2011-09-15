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
#import "PostCommentViewController.h"
#import <OCMock/OCMock.h>

#define TEST_URL @"test_entity_url"

@implementation PostCommentViewControllerTests

-(void) setUpClass
{
//    postCommentController = [[PostCommentViewController alloc] initWithNibName:nil bundle:nil entityUrlString:TEST_URL];
//    
//    id mockSocialize = [OCMockObject mockForClass: [Socialize class]];
//    [[mockSocialize expect]createCommentForEntityWithKey:TEST_URL comment:OCMOCK_ANY longitude:OCMOCK_ANY latitude:OCMOCK_ANY];
//    postCommentController.socialize = mockSocialize;
}

-(void) tearDownClass
{
    [postCommentController release];
}

-(void)tesInitWith
{
//    id postController = [OCMockObject partialMockForObject:postCommentController];
//    BOOL value = YES;
//    [[[postController expect]andReturn:OCMOCK_VALUE(value)]shouldShareLocationOnStart];
}
@end
