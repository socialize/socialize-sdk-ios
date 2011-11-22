/*
 * CommentDetailsViewTests.m
 * SocializeSDK
 *
 * Created on 9/6/11.
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

#import "CommentDetailsViewTests.h"
#import "CommentDetailsViewForTest.h"
#import "CommentMapView.h"
#import <OCMock/OCMock.h>


@implementation CommentDetailsViewTests

-(BOOL)shouldRunOnMainThread
{
    return YES;
}

-(void)setUpClass
{
    commentView = [[CommentDetailsViewForTest alloc] init];
}

-(void)tearDownClass
{
    [commentView release]; commentView = nil;
}

-(void)testUpdateProfileImage
{
    id image = [OCMockObject mockForClass: [UIImage class]];
    
    id profile = [OCMockObject niceMockForClass:[UIImageView class]];
    [[profile expect]setImage:image];
    commentView.profileImage = profile;
    
    [commentView updateProfileImage:image];
    
    [profile verify];
}

-(void)testUpdateLocationText
{   
    id positionLable = [OCMockObject niceMockForClass: [UILabel class]];
    [[positionLable expect]setText:@"Location"];
    commentView.positionLable = positionLable;
    
    [commentView updateLocationText:@"Location"];
    
    [positionLable verify];
}

-(void)testUpdateNavigationImage
{
    id image = [OCMockObject mockForClass: [UIImage class]];
    
    id navigationImage = [OCMockObject niceMockForClass:[UIImageView class]];
    [[navigationImage expect]setImage:image];
    commentView.navImage = navigationImage;
    
    [commentView updateNavigationImage:image];
    
    [navigationImage verify];
}

-(void)testUpdateUserName
{
    NSString *testName = @"somestring";
    id mockButton = [OCMockObject mockForClass:[UIButton class]];
    id mockLabel = [OCMockObject mockForClass:[UILabel class]];
    [[mockButton expect] setTitle:testName forState:UIControlStateNormal];
    commentView.profileNameButton = mockButton;
    [commentView updateUserName:testName];
    [mockButton verify];
    [mockLabel verify];
}

-(void)testUpdateGeoLocation
{
    CLLocationCoordinate2D location = {1.1, 2.3};
    
    id mockMap = [OCMockObject niceMockForClass: [CommentMapView class]];
    [[mockMap expect]setFitLocation:location withSpan:[CommentMapView coordinateSpan]];
    [[mockMap expect]setAnnotationOnPoint:location]; 
    commentView.mapOfUserLocation = mockMap;

    [commentView updateGeoLocation:location];
    
    [mockMap verify];
}

-(void) testUpdateCommentMsg
{
    id mockCommentView = [OCMockObject niceMockForClass: [UIWebView class]];
    [[mockCommentView expect]loadHTMLString: @"Comment" baseURL:nil]; 
    commentView.commentMessage = mockCommentView;
    
    [commentView updateCommentMsg:@"Comment"];
     
    [mockCommentView   verify];
}

-(void) testConfigurateView
{
    id mockMap = [OCMockObject niceMockForClass: [CommentMapView class]];
    [[mockMap expect] roundCorners];
    commentView.mapOfUserLocation = mockMap;
    
    [commentView configurateView];
    
    [mockMap verify];
}

-(void)testWebViewDidLoad
{
    id mockCommentView = [OCMockObject niceMockForClass: [UIWebView class]];
    [[[mockCommentView expect]andReturn:@"500"]stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"wrapper\").offsetHeight;"];
    
    commentView.commentMessage = mockCommentView;
    commentView.showMap = YES;
    [commentView webViewDidFinishLoad:mockCommentView];
    
    commentView.showMap = NO;
    [commentView webViewDidFinishLoad:mockCommentView];
    
    [mockCommentView verify];
}


-(void)testAutoresizeMask
{
    CommentDetailsView* view = [[CommentDetailsView alloc] initWithCoder:nil];
    GHAssertTrue(view.autoresizingMask == (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin), nil);
    [view release];
}

@end
