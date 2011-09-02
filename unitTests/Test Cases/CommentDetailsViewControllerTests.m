/*
 * CommentDetailsViewControllerTests.m
 * SocializeSDK
 *
 * Created on 9/2/11.
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

#import "CommentDetailsViewControllerTests.h"
#import "CommentDetailsViewController.h"
#import "SocializeComment.h"
#import "CommentDetailsView.h"
#import <OCMock/OCMock.h>

#define TEST_COMMENT @"test comment"
#define TEST_USER_NAME @"test_user"

@implementation CommentDetailsViewControllerTests

#pragma mark - Mock objects

-(id) mockCommentWithDate: (NSDate*) date lat: (NSNumber*)lat lng: (NSNumber*)lng profileUrl: (NSString*)url
{
    id mockComment = [OCMockObject mockForProtocol:@protocol(SocializeComment)];
    [[[mockComment stub] andReturn:TEST_COMMENT]text];
    [[[mockComment stub] andReturn:date]date];
    [[[mockComment stub] andReturn:lat]lat];
    [[[mockComment stub] andReturn:lng]lng];
    
    id mockUser = [OCMockObject mockForProtocol: @protocol(SocializeUser)];
    [[[mockUser stub] andReturn:TEST_USER_NAME] userName];
    [[[mockUser stub] andReturn:url] smallImageUrl];
    
    [[[mockComment stub] andReturn: mockUser]user];
    return mockComment;
}

-(void)setUpClass
{
    //commentDetails = [[CommentDetailsViewController alloc] init];
    commentDetails = [[CommentDetailsViewController alloc] initWithNibName:@"CommentDetailsViewController" bundle:nil];
    //commentDetails.commentDetailsView = [[[CommentDetailsView alloc] initWithCoder:nil] autorelease];
}

-(void)tearDownClass
{
    [commentDetails release]; commentDetails = nil;
}

-(void)setUp
{ 
}

-(void)tearDown
{
    [commentDetails viewWillDisappear:YES];
}

- (void) testViewDidLoad 
{ 
    GHAssertNotNULL(commentDetails, @"Notice View Controller should not be NULL"); 
    GHAssertNotNULL([commentDetails view], @"Notice View Controller's View should not be NULL"); 
} 

-(void) testShowComment
{
    commentDetails.comment = [self  mockCommentWithDate:[NSDate date] lat:nil lng:nil profileUrl:nil];
    
    [commentDetails viewDidLoad]; 
    [commentDetails viewWillAppear:YES];
    
    GHAssertEqualStrings(commentDetails.commentDetailsView.positionLable.text, @"Could not load comment.",nil);
}

@end
