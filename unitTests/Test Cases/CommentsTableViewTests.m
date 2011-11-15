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
#import "TableBGInfoView.h"


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
    listView.socialize = self.mockSocialize;
    
    
}

-(void) tearDownClass
{
    [[self.mockSocialize expect] setDelegate:nil];
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

-(void)testViewDidAppear {
    
    BOOL retValue = YES;
    [[[self.mockSocialize stub]andReturnValue:OCMOCK_VALUE(retValue)]isAuthenticated];
    [[self.mockSocialize expect] getCommentList:TEST_URL first:OCMOCK_ANY last:OCMOCK_ANY];
    [listView viewWillAppear:YES]; 
    
    [self.mockSocialize verify]; 
}

-(void)testServiceSuccess {
    
    id mockTable = [OCMockObject niceMockForClass:[UITableView class]];
    BOOL retValue = YES;
    [[[self.mockSocialize stub]andReturnValue:OCMOCK_VALUE(retValue)]isAuthenticated];
    [[self.mockSocialize expect] getCommentList:OCMOCK_ANY first:nil last:nil]; 
    listView.socialize = self.mockSocialize;
    
    [[mockTable expect] reloadData];
    listView.tableView = mockTable;
    [listView service:OCMOCK_ANY didFetchElements:OCMOCK_ANY];
    [listView viewWillAppear:YES]; 

    [mockTable verify]; 
}

-(void)testDidFail {
    id mockError = [OCMockObject mockForClass:[NSError class]];
    
    [[[mockError expect] andReturn:@"Entity does not exist."] localizedDescription];
    [listView service:nil didFail:mockError];
    [mockError verify];
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

-(void)testNumberOfRowsInSectionWhenLoading{
    
    NSInteger section = 0; 
    listView.isLoading = NO;
    
    id mockInformationView = [OCMockObject niceMockForClass:[TableBGInfoView class]];

    listView.informationView = mockInformationView;

    [[mockInformationView expect ]setHidden:NO];
    [listView tableView:OCMOCK_ANY numberOfRowsInSection:section];
    
    [mockInformationView verify];
}

-(void)testNumberOfRowsInSectionWhenNotLoading{
    
    NSInteger section = 0; 
    listView.isLoading = NO;
    
    id mockInformationView = [OCMockObject niceMockForClass:[TableBGInfoView class]];
    
    listView.informationView = mockInformationView;
    listView.arrayOfComments = [NSArray arrayWithObject:[NSNumber numberWithInt:45]];
    
    [[mockInformationView expect ]setHidden:YES];
    [listView tableView:OCMOCK_ANY numberOfRowsInSection:section];
    
    [mockInformationView verify];
}

-(void)testdidSelectRowAtIndexPath{
    
    id mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
    listView.tableView = mockTableView;
    listView.arrayOfComments = [NSArray arrayWithObject:[NSNumber numberWithInt:45]];
    
    NSIndexPath *indexSet = [NSIndexPath indexPathForRow:0 inSection:0];//[NSIndexPath indexPathWithIndexes:indexArr length:4];
    
    [[mockTableView expect] deselectRowAtIndexPath:OCMOCK_ANY animated:YES];
    [listView tableView:mockTableView didSelectRowAtIndexPath:indexSet];
    
    [mockTableView verify];
}
-(void)testTableViewcellForRowNoCommentsLoading {
    listView.arrayOfComments = nil;
    listView.isLoading = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [listView tableView:listView.tableView cellForRowAtIndexPath:indexPath];
}
-(void)testViewProfileButtonTouched {
    //set the tag so we can look it up in the comments array later
    id mockButton = [OCMockObject mockForClass:[UIButton class]];
    [[[mockButton expect] andReturnValue:[NSNumber numberWithInt:0]] tag];
    
    //create mock user and assign it to the comment
    id mockUser = [OCMockObject niceMockForProtocol:@protocol(SocializeUser)];
    [[[self.mockComment expect] andReturn:mockUser] user];
    listView.arrayOfComments = [NSArray arrayWithObject:self.mockComment];
    
    //mock out creation of profile controller and present
    id mockProfileViewController = [OCMockObject mockForClass:[SocializeProfileViewController class]];
    [[[self.partialMockCommentTableViewController expect] andReturn:mockProfileViewController] getProfileViewControllerForUser:mockUser];
    [[self.partialMockCommentTableViewController expect] presentModalViewController:mockProfileViewController animated:YES];
    

    [listView viewProfileButtonTouched:mockButton];
    
}
-(void)testTableViewcellForRowAtIndexPath{
    
    id partialTableViewMock = [OCMockObject partialMockForObject:listView.tableView];
    id tableViewCellMock = [OCMockObject niceMockForClass:[CommentsTableViewCell class]];
    id mockComment = [OCMockObject niceMockForProtocol:@protocol(SocializeComment)]; 
    listView.arrayOfComments = [NSArray arrayWithObject:mockComment];

    [[[partialTableViewMock expect] andReturn:tableViewCellMock] dequeueReusableCellWithIdentifier:OCMOCK_ANY];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [listView tableView:listView.tableView cellForRowAtIndexPath:indexPath];
    
    [[tableViewCellMock expect] locationPin];
    [partialTableViewMock verify];
    
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

    listView.tableView = mockTable;
    listView.socialize = mockSocialize;
    
    [[partialMockController expect] presentModalViewController:OCMOCK_ANY animated:YES];
//    [[[partialMockController stub] andCall:@selector(postCommentControllerInstance) onObject:self] postCommentControllerInstance];
    
    [listView addCommentButtonPressed:OCMOCK_ANY];
    [partialMockController verify]; 
}


@end
