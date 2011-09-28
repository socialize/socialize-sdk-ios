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
#import "SocializeCommentDetailsViewController.h"
#import "SocializeComment.h"
#import "CommentDetailsView.h"
#import <OCMock/OCMock.h>
#import "HtmlPageCreator.h"
#import "URLDownload.h"

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

-(NSString*) showComment:(id<SocializeComment>)comment
{   
    HtmlPageCreator* htmlCreator = [[[HtmlPageCreator alloc]init] autorelease];
    
    if([htmlCreator loadTemplate:[[NSBundle mainBundle] pathForResource:@"comment_template_clear" ofType:@"htm"]])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy 'at' h:mm a"];      
        [htmlCreator addInformation:[dateFormatter stringFromDate:comment.date] forTag:@"DATE_TEXT"];
        [dateFormatter release]; dateFormatter = nil;
        
        if(comment.text)
        {        
            NSMutableString* commentText = [[[NSMutableString alloc] initWithString:comment.text] autorelease];       
            [commentText replaceOccurrencesOfString: @"\n" withString:@"<br>" options:NSLiteralSearch range:NSMakeRange(0, [commentText length])];
            [htmlCreator addInformation:commentText forTag: @"COMMENT_TEXT"];
        }
        else
        {
            [htmlCreator addInformation:@"Could not load comment." 
                                 forTag: @"COMMENT_TEXT"];    
        }
    }
    return [[[htmlCreator html] copy] autorelease];
}

-(void)setUpClass
{
    commentDetails = [[SocializeCommentDetailsViewController alloc] initWithNibName:@"CommentDetailsViewController" bundle:nil];
    [Socialize storeSocializeApiKey:@"12341234" andSecret: @"12341234"];
}

-(void)tearDownClass
{
    [commentDetails release]; commentDetails = nil;
}

- (void) testViewDidLoad 
{ 
    GHAssertNotNULL(commentDetails, @"Notice View Controller should not be NULL"); 
} 

-(void) testShowComment
{
    id mockComment = [self  mockCommentWithDate:[NSDate date] lat:nil lng:nil profileUrl:nil];
    commentDetails.comment = mockComment;
    
     id mockDeteailView = [OCMockObject niceMockForClass: [CommentDetailsView class]];
    [[mockDeteailView expect] setShowMap: NO];
    [[mockDeteailView expect] updateLocationText: @"No location associated with this comment." color:[UIColor colorWithRed:127/ 255.f green:139/ 255.f blue:147/ 255.f alpha:1.0] fontName:@"Helvetica-Oblique" fontSize:12];
   
    [[mockDeteailView expect] updateNavigationImage: [UIImage imageNamed:@"socialize-comment-details-icon-geo-disabled.png"]];
    [[mockDeteailView expect] updateUserName:TEST_USER_NAME];
    [[mockDeteailView expect] configurateView];
    [[mockDeteailView expect] updateCommentMsg:[self showComment:mockComment]];
        
     commentDetails.commentDetailsView = mockDeteailView;
    
    [commentDetails viewDidLoad]; 
    [commentDetails viewWillAppear:YES];
    
    [mockComment verify];
    [mockDeteailView verify];
    
    [commentDetails viewWillDisappear:YES];
}

-(void) testShowCommentWithGeo
{
    NSNumber* lat = [NSNumber numberWithDouble:1.1];
    NSNumber* lng = [NSNumber numberWithDouble:0.2];
    NSString* profileUrl = @"UserPicture";
    
    id mockComment = [self  mockCommentWithDate:[NSDate date] lat:lat lng:lng profileUrl:profileUrl];
    commentDetails.comment = mockComment;
    
    id mockDeteailView = [OCMockObject niceMockForClass: [CommentDetailsView class]];
    [[mockDeteailView expect] setShowMap: YES];
    
    CLLocationCoordinate2D centerPoint = {[lat doubleValue], [lng doubleValue]};        
    [[mockDeteailView expect] updateGeoLocation: centerPoint];
    
    [[mockDeteailView expect] updateNavigationImage: [UIImage imageNamed:@"socialize-comment-details-icon-geo-enabled.png"]];
    [[mockDeteailView expect] updateUserName:TEST_USER_NAME];
    [[mockDeteailView expect] configurateView];
    [[mockDeteailView expect] updateCommentMsg:[self showComment:mockComment]];
    
    commentDetails.commentDetailsView = mockDeteailView;
    
    commentDetails.loaderFactory = [[^URLDownload*(NSString* url, id sender, SEL selector, id tag){
        GHAssertEqualStrings(profileUrl, url, nil);
        return nil;
    } copy]autorelease];
    
    [commentDetails viewDidLoad]; 
    [commentDetails viewWillAppear:YES];
    
    [mockComment verify];
    [mockDeteailView verify];
    
    [commentDetails viewWillDisappear:YES];
}

-(void) testReverseGeocoderWithNeighborhood
{
    id mockDeteailView = [OCMockObject niceMockForClass: [CommentDetailsView class]];
    [[mockDeteailView expect]updateLocationText:@"Neighborhood, City"];
    commentDetails.commentDetailsView = mockDeteailView;

    
    id mockMKPlacemark = [OCMockObject mockForClass: [MKPlacemark class]];
    [[[mockMKPlacemark expect]andReturn:@""]administrativeArea];
    [[[mockMKPlacemark expect]andReturn:@"City"]locality];
    [[[mockMKPlacemark expect]andReturn:@"Neighborhood"]subLocality];
    [commentDetails reverseGeocoder: nil didFindPlacemark: mockMKPlacemark];
    
    [mockMKPlacemark verify];
    [mockDeteailView verify];
}

-(void) testReverseGeocoder
{
    id mockDeteailView = [OCMockObject niceMockForClass: [CommentDetailsView class]];
    [[mockDeteailView expect]updateLocationText:@"City, State"];
    commentDetails.commentDetailsView = mockDeteailView;
    
    
    id mockMKPlacemark = [OCMockObject mockForClass: [MKPlacemark class]];
    [[[mockMKPlacemark expect]andReturn:@"State"]administrativeArea];
    [[[mockMKPlacemark expect]andReturn:@"City"]locality];
    [[[mockMKPlacemark expect]andReturn:@""]subLocality];
    [commentDetails reverseGeocoder: nil didFindPlacemark: mockMKPlacemark];
    
    [mockMKPlacemark verify];
    [mockDeteailView verify];
}

-(void) testReverseGeocoderDidFail
{
    id mockDeteailView = [OCMockObject niceMockForClass: [CommentDetailsView class]];
    [[mockDeteailView expect]updateLocationText:@"Could not locate the place name."];
    commentDetails.commentDetailsView = mockDeteailView;    
    
    [commentDetails reverseGeocoder: nil didFailWithError:nil];
    
    [mockDeteailView verify];
}

@end
