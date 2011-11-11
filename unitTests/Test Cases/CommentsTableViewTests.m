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

@implementation CommentsTableViewTests

#define TEST_URL @"test_entity_url"

-(void) setUpClass
{
      listView = [[SocializeCommentsTableViewController alloc] initWithNibName:@"SocializeCommentsTableViewController" bundle:nil entryUrlString: TEST_URL];
    postCommentController = [OCMockObject niceMockForClass:[SocializeComposeMessageViewController class]];
}

-(void) tearDownClass
{
    [listView release];
    //[postCommentController release];
}

-(void)testViewDidAppear {
    
    id mockSocialize = [OCMockObject mockForClass: [Socialize class]];
    BOOL retValue = YES;
    [[[mockSocialize stub]andReturnValue:OCMOCK_VALUE(retValue)]isAuthenticated];
    [[mockSocialize expect] getCommentList:TEST_URL first:OCMOCK_ANY last:OCMOCK_ANY];
    listView.socialize = mockSocialize;
    [listView viewWillAppear:YES]; 
    
    [mockSocialize verify]; 
}

-(void)testServiceSuccess {
    
    id mockTable = [OCMockObject niceMockForClass:[UITableView class]];
    id mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    BOOL retValue = YES;
    [[[mockSocialize stub]andReturnValue:OCMOCK_VALUE(retValue)]isAuthenticated];
    [[mockSocialize expect] getCommentList:OCMOCK_ANY first:nil last:nil]; 

    [[mockTable expect] reloadData];
    listView.tableView = mockTable;
    listView.socialize = mockSocialize;
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
    id mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    
    [[mockTable expect] setBackgroundView:OCMOCK_ANY];
    listView.tableView = mockTable;
    listView.socialize = mockSocialize;
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

-(void)tableViewcellForRowAtIndexPath{
    
    id partialTableViewMock = [OCMockObject partialMockForObject:listView.tableView];
    id tableViewCellMock = [OCMockObject niceMockForClass:[CommentsTableViewCell class]];
    listView.arrayOfComments = [NSArray arrayWithObject:[NSNumber numberWithInt:45]];

    [[[partialTableViewMock expect] andReturn:tableViewCellMock] dequeueReusableCellWithIdentifier:OCMOCK_ANY];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [listView tableView:listView.tableView cellForRowAtIndexPath:indexPath];
    
    [[tableViewCellMock expect] locationPin];
    [partialTableViewMock verify];
    
}

-(void)testSupportLandscapeRotation
{
    GHAssertTrue([listView shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft], nil);
}

-(void)testThatInformationViewIsOntheCenterAfterRotation
{
    [listView shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    GHAssertTrue(CGPointEqualToPoint(listView.informationView.center,listView.tableView.center),nil);
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

/*
-(void)testAddCommentButton{
    
    id partialMockController = [OCMockObject partialMockForObject:listView];
    id mockTable = [OCMockObject niceMockForClass:[UITableView class]];
    id mockSocialize = [OCMockObject mockForClass:[Socialize class]];

    listView.tableView = mockTable;
    listView.socialize = mockSocialize;
    
    [[partialMockController expect] presentModalViewController:OCMOCK_ANY animated:YES];
    [[[partialMockController stub] andCall:@selector(postCommentControllerInstance) onObject:self] postCommentControllerInstance];
    
    [listView addCommentButtonPressed:OCMOCK_ANY];
    [partialMockController verify]; 
}
*/


@end
