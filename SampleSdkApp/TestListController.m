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
#import "PostCommentViewController.h"
#import "TestShowSmallUserInfo.h"
#import "UIKeyboardListener.h"
#import "SocializeLocationManager.h"
#import "InputBox.h"

@implementation TestListController

@synthesize user = _user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        
        // Custom initialization
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          @"tests" ofType:@"plist"];

        NSMutableDictionary *myDic = [[NSDictionary alloc] initWithContentsOfFile: path];
        _testList = [[NSMutableArray alloc] initWithArray:[myDic allValues]];

    }
    return self;
}

- (void)dealloc
{
    [_user release];
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
    InputBox* input = [[InputBox alloc] init];
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
    
/*    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    UIViewController* viewControllerToRemove = nil;
    
    for (id object in allViewControllers) {
        if ([object isKindOfClass:[AuthenticateViewController class]])
            viewControllerToRemove = object;
    }
    if (viewControllerToRemove){
        [allViewControllers removeObjectIdenticalTo: viewControllerToRemove];
        self.navigationController.viewControllers = allViewControllers;
    }
 */
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
                [self presentModalViewController:[PostCommentViewController  createNavigationControllerWithPostViewControllerOnRootWithEntityUrl:url andImageForNavBar:[UIImage imageNamed:@"socialize-navbar-bg.png"]] animated:YES];
            break;
        }
        case 8:
            controller = [[TestShowSmallUserInfo alloc]initWithNibName:@"TestShowSmallUserInfo" bundle:nil andUserInfo:self.user];
            [self.navigationController pushViewController:controller animated:YES];
            break;

    }    
}

#pragma mark - Service delegete

@end
