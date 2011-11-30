//
//  CommentsTableViewTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 9/13/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "CommentsTableViewTests.h"
#import "SocializeCommentsTableViewController.h"
#import "CommentsTableViewCell.h"
#import <OCMock/OCMock.h>
#import "SocializeTableBGInfoView.h"
#import "SocializeCommentsService.h"
#import "SocializeProfileViewController.h"

@interface SocializeCommentsTableViewController(public)
-(IBAction)viewProfileButtonTouched:(UIButton*)sender;
-(UIViewController *)getProfileViewControllerForUser:(id<SocializeUser>)user;
@end
    
@implementation CommentsTableViewTests
@synthesize commentsTableViewController = commentsTableViewController_;
@synthesize mockView = mockView_;

#define TEST_URL @"test_entity_url"

+ (SocializeBaseViewController*)createController {
    return [[[SocializeCommentsTableViewController alloc] initWithNibName:@"SocializeCommentsTableViewController" bundle:nil entryUrlString: TEST_URL] autorelease];
}

-(void)setUp {
    [super setUp];
    // super setUp creates self.viewController
    self.commentsTableViewController = (SocializeCommentsTableViewController*)self.viewController;
}

-(void)tearDown {
    [super tearDown];
    self.commentsTableViewController = nil;
}

-(void)testAfterLoginActionInitializesContent {
    [[(id)self.commentsTableViewController expect] initializeContent];
    [self.commentsTableViewController afterLoginAction]; 
}

-(void)testServiceSuccess {
    
    id mockContent = [OCMockObject mockForClass:[NSArray class]];
    [[(id)self.commentsTableViewController expect] receiveNewContent:mockContent];
    [self.commentsTableViewController service:OCMOCK_ANY didFetchElements:mockContent];
}

-(void)testDidFail {
    id mockService = [OCMockObject mockForClass:[SocializeCommentsService class]];
    [mockService stubIsKindOfClass:[SocializeCommentsService class]];
    id mockError = [OCMockObject mockForClass:[NSError class]];
    
    [[[mockError stub] andReturn:@"Entity does not exist."] localizedDescription];
    [[(id)self.commentsTableViewController expect] receiveNewContent:nil];
    [self.commentsTableViewController service:mockService didFail:mockError];
}

- (void)makeTableViewNice {
    self.mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
    self.commentsTableViewController.tableView = self.mockTableView;
}

-(void)testViewDidLoad{
//    [self makeTableViewNice];
    [super expectViewDidLoad];

    // Should configure custom label for information
    id mockErrorLabel = [OCMockObject mockForClass:[UILabel class]];
    [[[self.mockInformationView stub] andReturn:mockErrorLabel] errorLabel];
    [[mockErrorLabel expect] setText:OCMOCK_ANY];
    
    [[self.mockNavigationItem expect] setLeftBarButtonItem:self.commentsTableViewController.brandingButton];
    [[self.mockNavigationItem expect] setRightBarButtonItem:self.commentsTableViewController.doneButton];
    
    [[self.mockTableView expect] setScrollsToTop:YES];
    [[self.mockTableView expect] setAutoresizesSubviews:YES];
    [[self.mockTableView expect] setBackgroundView:OCMOCK_ANY];
    [[self.mockTableView expect] setAccessibilityLabel:@"Comments Table View"];
    
    [self.commentsTableViewController viewDidLoad]; 
}

-(void)tesNumberOfSectionsInTableView{

    id mockTable = [OCMockObject niceMockForClass:[UITableView class]];
    int numberOfSections = [self.commentsTableViewController numberOfSectionsInTableView:mockTable]; 
    GHAssertEquals(numberOfSections, 1, @"number of sections");

}

-(void)testdidSelectRowAtIndexPath{
    [self makeTableViewNice];
    self.commentsTableViewController.content = [NSArray arrayWithObject:[NSNumber numberWithInt:45]];
    
    NSIndexPath *indexSet = [NSIndexPath indexPathForRow:0 inSection:0];//[NSIndexPath indexPathWithIndexes:indexArr length:4];
    
    [[self.mockTableView expect] deselectRowAtIndexPath:OCMOCK_ANY animated:YES];
    [[self.mockNavigationController expect] pushViewController:OCMOCK_ANY animated:YES];
    
    [self.commentsTableViewController tableView:self.mockTableView didSelectRowAtIndexPath:indexSet];
}

-(void)testViewProfileButtonTouched {
    //set the tag so we can look it up in the comments array later
    id mockButton = [OCMockObject mockForClass:[UIButton class]];
    [[[mockButton expect] andReturnValue:[NSNumber numberWithInt:0]] tag];
    
    //create mock user and assign it to the comment
    id mockUser = [OCMockObject niceMockForProtocol:@protocol(SocializeUser)];
    id mockComment = [OCMockObject mockForProtocol:@protocol(SocializeComment)];
    [[[mockComment expect] andReturn:mockUser] user];
    self.commentsTableViewController.content = [NSArray arrayWithObject:mockComment];
    
    //mock out creation of profile controller and present
    id mockProfileViewController = [OCMockObject mockForClass:[SocializeProfileViewController class]];
    [[[(id)self.commentsTableViewController expect] andReturn:mockProfileViewController] getProfileViewControllerForUser:mockUser];
    [[(id)self.commentsTableViewController expect] presentModalViewController:mockProfileViewController animated:YES];
    

    [self.commentsTableViewController viewProfileButtonTouched:mockButton];
    
}
-(void)testTableViewcellForRowAtIndexPath{
    id mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
    id mockCell = [OCMockObject niceMockForClass:[CommentsTableViewCell class]];
    id mockComment = [OCMockObject niceMockForProtocol:@protocol(SocializeComment)]; 
    self.commentsTableViewController.content = [NSArray arrayWithObject:mockComment];

    [[[mockTableView expect] andReturn:mockCell] dequeueReusableCellWithIdentifier:OCMOCK_ANY];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.commentsTableViewController tableView:mockTableView cellForRowAtIndexPath:indexPath];
    
    [mockTableView verify];
    [mockCell verify];
}
/*-(void)testDidSelectIndexAtRowPath{
    
    id navigationControllerMock = [OCMockObject niceMockForClass:[UINavigationController class]];
    
    NSIndexPath* path = [[[NSIndexPath alloc] init] autorelease];
    [listView tableView:OCMOCK_ANY didSelectRowAtIndexPath:path];
    
}
*/


/*
-(void)testAnimationDidStop{

    id mockView = [OCMockObject niceMockForClass:[UIView class]];
    
    listView.view = mockView;
    [[mockView expect] layer];
    [listView animationDidStop:OCMOCK_ANY finished:YES];
    
    [mockView verify]; 
}
*/

-(void)testAddCommentButton{
    [self makeTableViewNice];
    
    [[(id)self.commentsTableViewController expect] presentModalViewController:OCMOCK_ANY animated:YES];
    
    [self.commentsTableViewController addCommentButtonPressed:OCMOCK_ANY];
}

- (void)testCommentCellLayout {
    CommentsTableViewCell *cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setComment:@"Some Comment"];
    UILabel *testSummary = [[[UILabel alloc] initWithFrame:CGRectMake(58, 32, 254, 21)] autorelease];
    cell.summaryLabel = testSummary;
    [cell layoutSubviews];
    GHAssertTrue(CGRectEqualToRect(cell.frame, CGRectMake(0, 0, 320, 65)), @"Bad frame");
    
    [cell release];
}



@end
