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
#import "_SZUserProfileViewController.h"
#import "CommentDetailsView.h"
#import <OCMock/OCMock.h>
#import "HtmlPageCreator.h"
#import "URLDownload.h"

NSString * const TEST_COMMENT = @"test comment";
NSString * const TEST_USER_NAME = @"test_user";
NSString * const TEST_FIRST_NAME = @"firstName";
NSString * const TEST_LAST_NAME = @"lastName";
NSString * const TEST_DISPLAY_NAME_FULL = @"firstName lastName";

@implementation CommentDetailsViewControllerTests

@synthesize mockProfileNavigationController = mockProfileNavigationController_;
@synthesize partialMockCommentDetailsViewController = partialMockCommentDetailsViewController_;
@synthesize mockButton = mockButton_;
@synthesize mockNavigationController = mockNavigationController_;

#pragma mark - Mock objects

-(void)setUp 
{
    self.mockProfileNavigationController = [OCMockObject niceMockForClass:[_SZUserProfileViewController class]];
    self.mockButton = [OCMockObject mockForClass:[UIButton class]];
    self.partialMockCommentDetailsViewController = [OCMockObject partialMockForObject:commentDetails];
    self.mockNavigationController = [OCMockObject mockForClass:[UINavigationController class]];
}
-(void) tearDown 
{
    [self.mockProfileNavigationController verify];
    [self.mockButton verify];
    [self.partialMockCommentDetailsViewController verify];
    [self.mockNavigationController verify];
    
    self.mockProfileNavigationController = nil;
    self.mockButton = nil;
    self.partialMockCommentDetailsViewController = nil;
    self.mockNavigationController = nil;
}

-(void)setUpClass
{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
    commentDetails = [[SocializeCommentDetailsViewController alloc] initWithNibName:@"SocializeCommentDetailsViewController" bundle:nil];
#pragma GCC diagnostic pop
    [Socialize storeConsumerKey:@"12341234"];
    [Socialize storeConsumerSecret:@"12341234"];
}

-(void)tearDownClass
{
    [commentDetails release]; commentDetails = nil;
}

- (BOOL)shouldRunOnMainThread {
    return YES;
}

-(id) mockCommentWithDate:(NSDate*)date lat:(NSNumber*)lat lng:(NSNumber*)lng profileUrl:(NSString*)url displayName:(NSString*)displayName
{
    id mockComment = [OCMockObject mockForProtocol:@protocol(SocializeComment)];
    [[[mockComment stub] andReturn:TEST_COMMENT]text];
    [[[mockComment stub] andReturn:date]date];
    [[[mockComment stub] andReturn:lat]lat];
    [[[mockComment stub] andReturn:lng]lng];
    
    id mockUser = nil;
    if([displayName isEqualToString:TEST_DISPLAY_NAME_FULL]) {
        mockUser = [self mockUserFullWithUrl:url];
    }
    else if([displayName isEqualToString:TEST_FIRST_NAME]) {
        mockUser = [self mockUserFirstOnlyWithUrl:url];
    }
    else if([displayName isEqualToString:TEST_LAST_NAME]) {
        mockUser = [self mockUserLastOnlyWithUrl:url];
    }
    else if([displayName isEqualToString:TEST_USER_NAME]) {
        mockUser = [self mockUserNoneWithUrl:url];
    }

    [[[mockComment stub] andReturn: mockUser]user];
    return mockComment;
}

-(id) mockUserFullWithUrl:(NSString*)url
{
    id mockUser = [OCMockObject mockForProtocol: @protocol(SocializeUser)];
    [[[mockUser stub] andReturn:TEST_USER_NAME] userName];
    [[[mockUser stub] andReturn:TEST_FIRST_NAME] firstName];
    [[[mockUser stub] andReturn:TEST_LAST_NAME] lastName];
    [[[mockUser stub] andReturn:TEST_DISPLAY_NAME_FULL] displayName];
    [[[mockUser stub] andReturn:url] smallImageUrl];
    
    return mockUser;
}

-(id) mockUserNoneWithUrl:(NSString*)url
{
    id mockUser = [OCMockObject mockForProtocol: @protocol(SocializeUser)];
    [[[mockUser stub] andReturn:TEST_USER_NAME] userName];
    [[[mockUser stub] andReturn:TEST_USER_NAME] displayName];
    [[[mockUser stub] andReturn:url] smallImageUrl];
    
    return mockUser;
}

-(id) mockUserFirstOnlyWithUrl:(NSString*)url
{
    id mockUser = [OCMockObject mockForProtocol: @protocol(SocializeUser)];
    [[[mockUser stub] andReturn:TEST_USER_NAME] userName];
    [[[mockUser stub] andReturn:TEST_FIRST_NAME] firstName];
    [[[mockUser stub] andReturn:TEST_FIRST_NAME] displayName];
    [[[mockUser stub] andReturn:url] smallImageUrl];
    
    return mockUser;
}

-(id) mockUserLastOnlyWithUrl:(NSString*)url
{
    id mockUser = [OCMockObject mockForProtocol: @protocol(SocializeUser)];
    [[[mockUser stub] andReturn:TEST_USER_NAME] userName];
    [[[mockUser stub] andReturn:TEST_LAST_NAME] lastName];
    [[[mockUser stub] andReturn:TEST_LAST_NAME] displayName];
    [[[mockUser stub] andReturn:url] smallImageUrl];
    
    return mockUser;
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


- (void) testViewDidLoad 
{ 
    GHAssertNotNULL(commentDetails, @"Notice View Controller should not be NULL"); 
} 

//tests all permutations of displayName given first & last names
-(void) testShowComment
{
    [self showCommentWithDisplayName:TEST_DISPLAY_NAME_FULL];
    [self showCommentWithDisplayName:TEST_FIRST_NAME];
    [self showCommentWithDisplayName:TEST_LAST_NAME];
    [self showCommentWithDisplayName:TEST_USER_NAME];
}

-(void) showCommentWithDisplayName:(NSString *)displayName
{
    id mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    [[[mockSocialize stub] andReturnBool:YES] isAuthenticated];
    [[[mockSocialize stub] andReturnBool:YES] isAuthenticatedWithThirdParty];
    [[mockSocialize stub] setDelegate:nil];
    commentDetails.socialize = mockSocialize;
    
    id mockComment = [self mockCommentWithDate:[NSDate date] lat:nil lng:nil profileUrl:nil displayName:displayName];
    commentDetails.comment = mockComment;
    
    id mockDetailView = [OCMockObject niceMockForClass: [CommentDetailsView class]];
    [[mockDetailView expect] setShowMap: NO];
    [[mockDetailView expect] updateLocationText: @"No location associated with this comment."
                                          color:[UIColor colorWithRed:127/ 255.f green:139/ 255.f blue:147/ 255.f alpha:1.0]
                                       fontName:@"Helvetica-Oblique" fontSize:12];
    
    [[mockDetailView expect] updateNavigationImage: [UIImage imageNamed:@"socialize-comment-details-icon-geo-disabled.png"]];
    [[mockDetailView expect] updateUserName:displayName];
    [[mockDetailView expect] configurateView];
    
    commentDetails.commentDetailsView = mockDetailView;
    [[[self.partialMockCommentDetailsViewController stub] andReturn:mockDetailView] view];
    
    [self.partialMockCommentDetailsViewController viewDidLoad];
    [self.partialMockCommentDetailsViewController viewWillAppear:YES];
    
    [mockComment verify];
    [mockDetailView verify];
    
    [self.partialMockCommentDetailsViewController viewWillDisappear:YES];
}

-(void) testProfileButtonTapped {
    
    [[[self.partialMockCommentDetailsViewController expect] andReturn:self.mockProfileNavigationController] getProfileViewControllerForUser:OCMOCK_ANY];
    [[[self.partialMockCommentDetailsViewController expect] andReturn:OCMOCK_ANY] createLeftNavigationButtonWithCaption:OCMOCK_ANY];
    
    //setup mock navigation controller
    [[[self.partialMockCommentDetailsViewController expect] andReturn:self.mockNavigationController] navigationController];
    [[self.mockNavigationController expect] pushViewController:self.mockProfileNavigationController animated:YES];

    id mockSender = [OCMockObject mockForClass:[UIButton class]];
    [commentDetails profileButtonTapped:mockSender];
}



@end
