//
//  ProfileEditValueController.m
//  appbuildr
//
//  Created by William Johnson on 1/11/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "SocializeProfileEditValueController.h"
#import "UIButton+Socialize.h"


@implementation SocializeProfileEditValueController
@synthesize editValueCell;
@synthesize editValueField;
@synthesize indexPath;
@synthesize valueToEdit;
@synthesize didEdit;
@synthesize cancelButton = cancelButton_;
@synthesize saveButton = saveButton_;
@synthesize delegate = delegate_;

#pragma mark -
#pragma mark View lifecycle

- (void)dealloc {
    self.cancelButton = nil;
    self.saveButton = nil;
    
    [super dealloc];
}

- (UIBarButtonItem*)cancelButton {
    if (cancelButton_ == nil) {
        UIButton * actualButton = [UIButton redSocializeNavBarButtonWithTitle:@"Cancel"];
        [actualButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton_ = [[UIBarButtonItem alloc] initWithCustomView:actualButton];
    }
    return cancelButton_;
}

- (UIBarButtonItem*)saveButton {
    if (saveButton_ == nil) {
        UIButton * actualButton = [UIButton blueSocializeNavBarButtonWithTitle:@"Save"];
        [actualButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        saveButton_ = [[UIBarButtonItem alloc] initWithCustomView:actualButton];
    }
    return saveButton_;
}

- (void)saveButtonPressed:(UIButton*)saveButton {
    [self.delegate profileEditValueControllerDidSave:self];
}

- (void)cancelButtonPressed:(UIButton*)cancelButton {
    [self.delegate profileEditValueControllerDidCancel:self];
}

- (void)viewDidLoad {

    [super viewDidLoad];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.separatorColor = [UIColor darkGrayColor];
	
	
	CGRect tableHeaderFrame = CGRectMake(0, 0, self.view.frame.size.width, 30);
	
	UIView * headerView = [[UIView alloc] initWithFrame:tableHeaderFrame];
	self.tableView.tableHeaderView = headerView;
	[headerView release];

	self.navigationItem.rightBarButtonItem.enabled = NO;
    self.didEdit = NO;

    UIColor *tableBackgroundColor = [UIColor colorWithRed:50/255.0f green:58/255.0f blue:67/255.0f alpha:1.0];
    self.tableView.backgroundColor = tableBackgroundColor;
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
}


- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	[self.tableView reloadData];
	
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	
	self.didEdit = YES;
	self.navigationItem.rightBarButtonItem.enabled = self.didEdit;
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	self.didEdit = YES;
	self.navigationItem.rightBarButtonItem.enabled = self.didEdit;
	return YES;	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        [[NSBundle mainBundle] loadNibNamed:@"SocializeEditValueTableViewCell" owner:self options:nil];
		cell = editValueCell;
		self.editValueCell = nil;
    }
    
	self.editValueField.placeholder = self.title;
    self.editValueField.accessibilityLabel = self.title;
	self.editValueField.text = self.valueToEdit;
	[self.editValueField becomeFirstResponder];
	
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}



@end

