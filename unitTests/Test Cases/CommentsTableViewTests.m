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
#import "SocializePostCommentViewController.h"
#import "SocializeTableBGInfoView.h"
#import "SocializeCommentsService.h"

@interface SocializeCommentsTableViewController(public)
-(IBAction)viewProfileButtonTouched:(UIButton*)sender;
-(UIViewController *)getProfileViewControllerForUser:(id<SocializeUser>)user;
@end
    
@implementation CommentsTableViewTests
@synthesize mockSocialize = mockSocialize_;
@synthesize mockComment = mockComment_;
@synthesize partialMockCommentTableViewController = partialMockCommentTableViewController_;
#define TEST_URL @"test_entity_url"

-(void) setUpClass
{
      listView = [[SocializeCommentsTableViewController alloc] initWithNibName:@"SocializeCommentsTableViewController" bundle:nil entryUrlString: TEST_URL];
    postCommentController = [OCMockObject niceMockForClass:[SocializeComposeMessageViewController class]];
    self.mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    [[self.mockSocialize stub] setDelegate:nil];
    listView.socialize = self.mockSocialize;
    
    
}

-(void) tearDownClass
{
    [self.mockSocialize verify];
    [listView release];
    //[postCommentController release];
}
-(void)setUp {
    self.mockComment = [OCMockObject mockForProtocol:@protocol(SocializeComment)];
    self.partialMockCommentTableViewController = [OCMockObject partialMockForObject:listView];
}
-(void)tearDown {
    //verify global mocks
    [self.mockComment verify];
    [self.partialMockCommentTableViewController verify];
    
    //reset the objects back to nil
    self.mockComment = nil;
    self.partialMockCommentTableViewController = nil;
}

/*
-(void)testViewWillAppear {
    [[[self.mockSocialize stub]andReturnBool:YES]isAuthenticated];
    [[self.mockSocialize expect] getCommentList:TEST_URL first:OCMOCK_ANY last:OCMOCK_ANY];
    [[(id)self.partialMockCommentTableViewController expect] viewWillAppear:YES];
    [[(id)self.partialMockCommentTableViewController expect] startLoadingContent];
    [listView viewWillAppear:YES]; 
}
 */

-(void)testServiceSuccess {
    
    id mockContent = [OCMockObject mockForClass:[NSArray class]];
    [[(id)self.partialMockCommentTableViewController expect] receiveNewContent:mockContent];
    [self.partialMockCommentTableViewController service:OCMOCK_ANY didFetchElements:mockContent];
}

-(void)testDidFail {
    id mockService = [OCMockObject mockForClass:[SocializeCommentsService class]];
    [mockService stubIsKindOfClass:[SocializeCommentsService class]];
    id mockError = [OCMockObject mockForClass:[NSError class]];
    
    [[[mockError stub] andReturn:@"Entity does not exist."] localizedDescription];
    [[(id)self.partialMockCommentTableViewController expect] receiveNewContent:nil];
    [listView service:mockService didFail:mockError];
}

-(void)testViewDidLoad{
    
    id mockTable = [OCMockObject niceMockForClass:[UITableView class]];
    
    [[mockTable expect] setBackgroundView:OCMOCK_ANY];
    listView.tableView = mockTable;
    [listView viewDidLoad]; 
    
    [mockTable verify]; 
}

-(id)postCommentControllerInstance{
    return postCommentController;
}

-(void)tesNumberOfSectionsInTableView{

    id mockTable = [OCMockObject niceMockForClass:[UITableView class]];
    int numberOfSections = [listView numberOfSectionsInTableView:mockTable]; 
    GHAssertEquals(numberOfSections, 1, @"number of sections");

}

-(void)testdidSelectRowAtIndexPath{
    
    id mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
    listView.tableView = mockTableView;
    listView.content = [NSArray arrayWithObject:[NSNumber numberWithInt:45]];
    
    NSIndexPath *indexSet = [NSIndexPath indexPathForRow:0 inSection:0];//[NSIndexPath indexPathWithIndexes:indexArr length:4];
    
    [[mockTableView expect] deselectRowAtIndexPath:OCMOCK_ANY animated:YES];
    [listView tableView:mockTableView didSelectRowAtIndexPath:indexSet];
    
    [mockTableView verify];
}

-(void)testViewProfileButtonTouched {
    //set the tag so we can look it up in the comments array later
    id mockButton = [OCMockObject mockForClass:[UIButton class]];
    [[[mockButton expect] andReturnValue:[NSNumber numberWithInt:0]] tag];
    
    //create mock user and assign it to the comment
    id mockUser = [OCMockObject niceMockForProtocol:@protocol(SocializeUser)];
    [[[self.mockComment expect] andReturn:mockUser] user];
    listView.content = [NSArray arrayWithObject:self.mockComment];
    
    //mock out creation of profile controller and present
    id mockProfileViewController = [OCMockObject mockForClass:[SocializeProfileViewController class]];
    [[[self.partialMockCommentTableViewController expect] andReturn:mockProfileViewController] getProfileViewControllerForUser:mockUser];
    [[self.partialMockCommentTableViewController expect] presentModalViewController:mockProfileViewController animated:YES];
    

    [listView viewProfileButtonTouched:mockButton];
    
}
-(void)testTableViewcellForRowAtIndexPath{
    id mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
    id mockCell = [OCMockObject niceMockForClass:[CommentsTableViewCell class]];
    id mockComment = [OCMockObject niceMockForProtocol:@protocol(SocializeComment)]; 
    listView.content = [NSArray arrayWithObject:mockComment];

    [[[mockTableView expect] andReturn:mockCell] dequeueReusableCellWithIdentifier:OCMOCK_ANY];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [listView tableView:mockTableView cellForRowAtIndexPath:indexPath];
    
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
    
    id partialMockController = [OCMockObject partialMockForObject:listView];
    id mockTable = [OCMockObject niceMockForClass:[UITableView class]];
    id mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    [[mockSocialize stub] setDelegate:nil];

    listView.tableView = mockTable;
    listView.socialize = mockSocialize;
    
    [[partialMockController expect] presentModalViewController:OCMOCK_ANY animated:YES];
//    [[[partialMockController stub] andCall:@selector(postCommentControllerInstance) onObject:self] postCommentControllerInstance];
    
    [listView addCommentButtonPressed:OCMOCK_ANY];
    [partialMockController verify]; 
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
