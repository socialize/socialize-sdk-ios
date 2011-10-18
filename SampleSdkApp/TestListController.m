//
//  TestListController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/26/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "TestListController.h"
#import "TestGetEntityViewController.h"
#import "TestCreateEntityViewController.h"
#import "TestCreateCommentViewController.h"
#import "TestFetchCommentsViewController.h"
#import "TestLikeViewController.h"
#import "LikeListViewController.h"
#import "TestViewCreationViewController.h"
#import "AuthenticateViewController.h"
#import <Socialize/Socialize.h>
#import "TestShowSmallUserInfo.h"
#import "TestSocializeActionBar.h"
#import "InputBox.h"

#if RUN_KIF_TESTS
#import <OCMock/OCMock.h>
#endif

@implementation TestListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        
        _testList = [[NSArray arrayWithObjects:
                      @"Test get an Entity",
                      @"Test create an Entity",
                      @"Test create a comment",
                      @"Test get comments for an entity",
                      @"Test like/unlike",
                      @"Test getting a list of likes",
                      @"Test create view",
                      @"Test create comment view controller",
                      @"Test small user info after authentication",
                      @"Test User Profile",
                      @"Test Socialize Action Bar",
                      nil
                      ]retain];

    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(NSString*) getEntityKey
{
    InputBox* input = [[InputBox new]autorelease];
    [input showInputMessageWithTitle:@"Enter entity URL" andPlaceholder:@"Full URL"];
    return input.inputMsg;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _tableView.accessibilityLabel = @"tableView";
    
    _tableView.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = @"Tests";
    //removing the previous authentication view controller
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_testList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    cell.textLabel.text = [_testList objectAtIndex:indexPath.row];
    cell.textLabel.accessibilityLabel = [_testList objectAtIndex:indexPath.row];
    cell.textLabel.isAccessibilityElement = YES;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController* controller = nil;

    switch(indexPath.row){
        case 0:
            // create a test view controller
            controller = [[TestGetEntityViewController alloc ] initWithNibName:@"TestGetEntityViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        
        case 1:
            controller = [[TestCreateEntityViewController alloc] initWithNibName:@"TestCreateEntityViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            break;

        case 2:
            controller = [[TestCreateCommentViewController alloc] initWithNibName:@"TestCreateCommentViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            break;

        case 3:
            controller = [[TestFetchCommentsViewController alloc] initWithNibName:@"TestFetchCommentsViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            break;

        case 4:
            controller = [[TestLikeViewController alloc] initWithNibName:@"TestLikeViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            break;

        case 5:
            controller = [[LikeListViewController alloc] initWithNibName:@"LikeListViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            break;
            
        case 6:
            controller = [[TestViewCreationViewController alloc] initWithNibName:@"TestViewCreationViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            break;
            
        case 7:
        {
            NSString* url = [self getEntityKey];
            if(url)
                [self presentModalViewController:[SocializePostCommentViewController  createNavigationControllerWithPostViewControllerOnRootWithEntityUrl:url andImageForNavBar:[UIImage imageNamed:@"socialize-navbar-bg.png"]] animated:YES];
            break;
        }
        case 8:
            controller = [[TestShowSmallUserInfo alloc]initWithNibName:@"TestShowSmallUserInfo" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        case 9:
        {
            UIViewController *profile = [SocializeProfileViewController currentUserProfileWithDelegate:self];
#ifdef RUN_KIF_TESTS
            UINavigationController *nav = (UINavigationController*)profile;
            SocializeProfileViewController *pvc = (SocializeProfileViewController*)[[nav viewControllers] objectAtIndex:0];
            SocializeProfileEditViewController *edit = [[[SocializeProfileEditViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
            id editMock = [OCMockObject partialMockForObject:edit];
            //- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
            
            UIImage *profileImage = [UIImage imageNamed:@"Smiley.png"];
            [[[editMock expect] andDo:^(NSInvocation* blah){
                NSDictionary *info = [NSDictionary dictionaryWithObject:profileImage forKey:UIImagePickerControllerEditedImage];
                [edit imagePickerController:nil didFinishPickingMediaWithInfo:info];
            }] showActionSheet];
            
            pvc.profileEditViewController = editMock;
#endif
            [self.navigationController presentModalViewController:profile animated:YES];
            break;
        }
        case 10:
        {
            NSString* url = [self getEntityKey];
            if(url)
            {
                controller = [[TestSocializeActionBar alloc] initWithEntityUrl:url];
                [self.navigationController pushViewController:controller animated:YES];
            }
            break;
        }
    }    
    [controller release];
}

#pragma mark - Service delegete

- (void)profileViewControllerDidCancel:(SocializeProfileViewController*)profileViewController {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
- (void)profileViewControllerDidSave:(SocializeProfileViewController*)profileViewController {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end