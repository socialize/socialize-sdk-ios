//
//  CommentsTableViewTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 9/13/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "CommentsTableViewTests.h"
#import "SocializeCommentsTableViewController.h"
#import <OCMock/OCMock.h>


@implementation CommentsTableViewTests

#define TEST_URL @"test_entity_url"

-(void) setUpClass
{
      listView = [[SocializeCommentsTableViewController alloc] initWithNibName:@"SocializeCommentsTableViewController" bundle:nil entryUrlString: TEST_URL];
//    id mockSocialize = [OCMockObject niceMockForClass: [Socialize class]];
//    [[mockSocialize expect] createCommentForEntityWithKey:TEST_URL comment:OCMOCK_ANY longitude:OCMOCK_ANY latitude:OCMOCK_ANY] ;
//    listView.socialize = mockSocialize;
}

-(void) tearDownClass
{
    [listView release];
    //[postCommentController release];
}

-(void)testViewDidAppear {
    
    id mockSocialize = [OCMockObject niceMockForClass: [Socialize class]];

    [[mockSocialize expect] getCommentList:TEST_URL first:OCMOCK_ANY last:OCMOCK_ANY];
    listView.socialize = mockSocialize;
    [listView viewWillAppear:YES]; 
    
    [mockSocialize verify]; 
}

-(void)testServiceSuccess {
    
    id mockTable = [OCMockObject niceMockForClass:[UITableView class]];

    [[mockTable expect] reloadData];
    listView.tableView = mockTable;
    [listView viewWillAppear:YES]; 
    
    [mockTable verify]; 
}

@end
