//
//  TestFetchCommentsViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/29/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "TestFetchCommentsViewController.h"
#import <Socialize/Socialize.h>
#import "UIButton+Socialize.h"
//#import "SocializeActivityDetailsViewController.h"
#define SUCCESS @"success"
#define FAIL @"fail"

@implementation TestFetchCommentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _socialize = [[Socialize alloc] initWithDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [_socialize release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Fetch Comment";
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [_fetchButton configureWithoutResizingWithType:AMSOCIALIZE_BUTTON_TYPE_BLACK];
    _tableView.backgroundColor = [UIColor lightGrayColor];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    hiddenButton = [[UIButton alloc] init]; 
    hiddenButton.hidden = YES;
    hiddenButton.accessibilityLabel = @"hiddenButton";
    [self.view addSubview:hiddenButton];

    // Do any additional setup after loading the view from its nib.
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

-(IBAction)getComments{
    if (!hiddenButton){
        hiddenButton = [[UIButton alloc] init]; 
        hiddenButton.hidden = YES;
        hiddenButton.accessibilityLabel = @"hiddenButton";
        [self.view addSubview:hiddenButton];
    }
    
//    SocializeCommentsTableViewController* commentsController = [[[SocializeCommentsTableViewController alloc] initWithNibName:@"SocializeCommentsTableViewController" bundle:nil entryUrlString:_textField.text] autorelease];
    UIViewController *commentsController = [SocializeCommentsTableViewController socializeCommentsTableViewControllerForEntity:_textField.text];
    [self presentModalViewController:commentsController animated:YES];
//    [self.navigationController pushViewController:commentsController animated:YES];
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
    return [_comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[_comments objectAtIndex:indexPath.row] text];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SocializeActivityDetailsViewController* cdView = [[SocializeActivityDetailsViewController alloc] init];
    [self.navigationController pushViewController:cdView animated:YES];
    [cdView release];
}

#pragma Socialize Service callbacks
-(void)service:(SocializeService*)service didFail:(NSError*)error{

    [hiddenButton removeFromSuperview];
    [hiddenButton release];
    hiddenButton = nil;
    
    [_textField resignFirstResponder];
    [_loadingView removeView]; 
    
    UIAlertView *msg;
    msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"cannot get comments" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
    
    resultTextField.text = FAIL;
}

// getting/retrieving comments or likes would invoke this callback
-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{

    [hiddenButton removeFromSuperview];
    [hiddenButton release];
    hiddenButton = nil;

    [_textField resignFirstResponder];
    [_loadingView removeView]; 
    
    // we have to verify the contents are of type SocializeEntity 
    if ([dataArray count]){
        _comments = [dataArray retain];
        [_tableView reloadData];
    }
    resultTextField.text = SUCCESS;
}

@end
