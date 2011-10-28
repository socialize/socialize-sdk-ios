/*
 * SocializeActionBarTests.m
 * SocializeSDK
 *
 * Created on 10/10/11.
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

#import "SocializeActionBarTests.h"
#import "SocializeActionBar.h"
#import <OCMock/OCMock.h>

#define TEST_ENTITY_URL @"http://test.com"

@implementation SocializeActionBarTests

-(void)setUpClass
{
    UIView *parentView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,460)] autorelease];

    mockParentController = [OCMockObject mockForClass:[UIViewController class]];
    actionBar = [[SocializeActionBar actionBarWithUrl:TEST_ENTITY_URL presentModalInController:mockParentController] retain];
    
    [parentView addSubview:actionBar.view];
    [(SocializeActionView*)actionBar.view positionInSuperview];
}

-(void)tearDownClass
{
    [actionBar release];
}

-(void)tearDown
{
    [mockParentController verify];
    [mockParantView verify];
}

-(void)testCreateCheck
{
    GHAssertNotNil(actionBar.view, nil);
    GHAssertTrue(CGRectEqualToRect(actionBar.view.frame, CGRectMake(0,416,320,44)), nil);
    GHAssertTrue([actionBar.view isKindOfClass: [SocializeActionView class]] ,nil);
    GHAssertEqualStrings(actionBar.entity.key, TEST_ENTITY_URL, nil);
}

- (void)testModalCommentDisplay {
    [[mockParentController expect] presentModalViewController:OCMOCK_ANY animated:YES];
    [actionBar commentButtonTouched:nil];
    [mockParentController verify];
}

@end
