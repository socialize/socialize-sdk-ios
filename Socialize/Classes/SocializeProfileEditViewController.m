//
//  ProfileEditViewController.m
//  appbuildr
//
//  Created by William Johnson on 1/10/11.
//  Copyright 2011 pointabout. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SocializeProfileEditViewController.h"
#import "SocializeProfileEditTableViewCell.h"
#import "SocializeProfileEditValueController.h"
#import "UIImage+Resize.h"
#import "UIButton+Socialize.h"


@implementation SocializeProfileEditViewController

@synthesize delegate;
@synthesize profileEditViewCell;
@synthesize keysToEdit;
@synthesize keyValueDictionary;
@synthesize profileImage;
@synthesize editValueViewController = _editValueViewController;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithStyle:(UITableViewStyle)style 
{
    if ( (self = [super initWithStyle:UITableViewStyleGrouped]) ) 
	{
		imagePicker = [[UIImagePickerController alloc]init];
		imagePicker.delegate = self;
		imagePicker.allowsEditing = YES;
    }
    return self;
}


- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.title = @"Edit Profile";
	self.tableView.separatorColor = [UIColor blackColor];
	self.tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.accessibilityLabel = @"edit profile";
    UIColor *tableBackgroundColor = [UIColor colorWithRed:50/255.0f green:58/255.0f blue:67/255.0f alpha:1.0];
    self.tableView.backgroundColor = tableBackgroundColor;

	self.navigationItem.rightBarButtonItem.enabled = NO;
		
	self.editValueViewController = [[[SocializeProfileEditValueController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
	
    UIButton * cancelButton = [UIButton redSocializeNavBarButtonWithTitle:@"Cancel"];
    [cancelButton addTarget:self action:@selector(editValueCancel:) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem  * editLeftItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	self.editValueViewController.navigationItem.leftBarButtonItem = editLeftItem;	
	[editLeftItem release];

    UIButton * saveButton = [UIButton blueSocializeNavBarButtonWithTitle:@"Save"];
    [saveButton addTarget:self action:@selector(editValueSave:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem  * editRightItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.editValueViewController.navigationItem.rightBarButtonItem = editRightItem;	
    [editRightItem release];
	
    if (keyValueDictionary == nil) 
	{
		NSMutableDictionary * valueDictionary = [[NSMutableDictionary alloc]initWithCapacity:20];
		self.keyValueDictionary = valueDictionary;
		[valueDictionary release];
	}
	
	
	UIColor *oddBackgroundColor  = [UIColor colorWithRed:44/255.0f green:54/255.0f blue:63/255.0f alpha:1.0];
    
	UIColor *evenBackgroundColor = [UIColor colorWithRed:35/255.0f green:43/255.0f blue:50/255.0f alpha:1.0];
	cellBackgroundColors = [[NSArray arrayWithObjects:evenBackgroundColor, oddBackgroundColor, nil]retain];
}


-(void)editValueSave:(id)button
{
	[self.navigationController popViewControllerAnimated:YES];
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	NSIndexPath * indexPath = self.editValueViewController.indexPath;
	
	[self.keyValueDictionary setObject:self.editValueViewController.editValueField.text 
								 forKey:[keysToEdit objectAtIndex:indexPath.row]];
	
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)editValueCancel:(id)button
{
	[self.navigationController popViewControllerAnimated:YES];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	switch (section) 
	{
		case 0:
			return 1;

		case 1:
		default:
			return [keysToEdit count];
	}
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0) 
	  return 65;
	
	return 50;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//  return @"Hello";	
//	
//}

-(void)setProfileImage:(UIImage *) theImage
{
		
	@synchronized(self) 
	{
		[profileImage release];
		profileImage = [theImage retain];
		
	}
	
	NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(SocializeProfileEditTableViewCell *)getProfileImageCell
{
	
	static NSString *profileCellIdentifier = @"profile_Image_cell";
    
	SocializeProfileEditTableViewCell *cell =(SocializeProfileEditTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:profileCellIdentifier];
    
	if (cell == nil) 
	{
		[[NSBundle mainBundle] loadNibNamed:@"SocializeProfileEditTableViewImageCell" owner:self options:nil];
		cell = profileEditViewCell;
		self.profileEditViewCell = nil;
		
	}
	cell.spinner.hidesWhenStopped = YES;	
	if (self.profileImage) 
	{
		
		[cell.spinner stopAnimating];
		cell.theImageView.image = self.profileImage;
		
	}
	else 
	{		
		cell.spinner.hidesWhenStopped = YES;
		[cell.spinner startAnimating];
		
	}

	[cell.theImageView.layer setCornerRadius:4];
	[cell.theImageView.layer setMasksToBounds:YES];
	
    // Temporarily disable selection until profile is editable on server [See #19262347]
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
	
	
}


-(SocializeProfileEditTableViewCell *)getNormalCell
{
	
	static NSString *CellIdentifier = @"profile_edit_cell";
	
	SocializeProfileEditTableViewCell *cell =(SocializeProfileEditTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
		[[NSBundle mainBundle] loadNibNamed:@"SocializeProfileEditTableViewCell" owner:self options:nil];
		cell = profileEditViewCell;
		self.profileEditViewCell = nil;
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}
	
	return cell;	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   	
	SocializeProfileEditTableViewCell *cell = nil;
	
	switch (indexPath.section) 
	{
		case 0:
						
			cell = [self getProfileImageCell];
			cell.backgroundColor = [cellBackgroundColors objectAtIndex:0];
			break;
			
		case 1:
		default:
			cell = [self getNormalCell];
			cell.keyLabel.text = (NSString *)[self.keysToEdit objectAtIndex:indexPath.row];
			cell.valueLabel.text = (NSString *)[self.keyValueDictionary objectForKey:cell.keyLabel.text];
			cell.backgroundColor = [cellBackgroundColors objectAtIndex:(indexPath.row+1)%2];
			break;

	}
	
	// Configure the cell...
	//UIColor * cellBackgroundColor = [cellBackgroundColors objectAtIndex:indexPath.row%2];
	//cell.backgroundColor = cellBackgroundColor;
    
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
-(void) showActionSheet
{

	UIActionSheet *uploadPicActionSheet = nil;
	
	if( [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] ) 
	{
		uploadPicActionSheet =[[UIActionSheet alloc] initWithTitle:nil
														  delegate:self 
												 cancelButtonTitle:@"Cancel"
											destructiveButtonTitle:nil
												 otherButtonTitles:@"Choose From Album",@"Take Picture", nil];
		
		
	}
	else 
	{
		uploadPicActionSheet =[[UIActionSheet alloc] initWithTitle:nil
														  delegate:self 
												 cancelButtonTitle:@"Cancel"
											destructiveButtonTitle:nil
												 otherButtonTitles:@"Choose From Album",nil];	
	}
	
	
    [uploadPicActionSheet showInView:self.view.window];
    [uploadPicActionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	DebugLog(@"getting callback from actions sheet. index is %i and cancel button index is:%i", buttonIndex, actionSheet.cancelButtonIndex);
	if( buttonIndex == actionSheet.cancelButtonIndex ) {
		return;
	}	
	if (buttonIndex == 1 ) {
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	} else if (buttonIndex == 0 ) {
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	[actionSheet release];
	
	[self presentModalViewController:imagePicker animated:YES];
}

-(UIImage *) resizeImage:(UIImage *)imageToResize
{
	UIImage * newImage = nil;
	if (imageToResize != nil) 
	{
		
		CGSize biggestSize = CGSizeMake(800,800);
		
		
		if( imageToResize.size.height > biggestSize.height || imageToResize.size.width > biggestSize.width )
		{
			
		    newImage = [imageToResize resizedImageWithContentMode:UIViewContentModeScaleAspectFill
														   bounds:biggestSize
											 interpolationQuality:1.0];
			NSData * newData = UIImageJPEGRepresentation(newImage, .75);
			if(!newData) 
			{
				newImage = [UIImage imageWithData:newData];
			}
			
		}
		
	}
	
	if (newImage == nil) 
	{
		newImage = imageToResize;
	}
	
	return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	DebugLog(@"image was picked!!!");
	
	self.navigationItem.rightBarButtonItem.enabled = YES;
    //[self.view setNeedsDisplay];
	[picker dismissModalViewControllerAnimated:YES];
	
	[self setProfileImage:[self resizeImage:image]];

	NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Navigation logic may go here. Create and push another view controller.
    
	SocializeProfileEditTableViewCell *cell =(SocializeProfileEditTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
	cell.selected = NO;
	if (indexPath.section ==0) 
	{
// Temporarily disabled [#19262347]
//		[self showActionSheet];
		return;
	}
	
	NSMutableString * titleText =(NSMutableString *) [(NSString *)[self.keysToEdit objectAtIndex:indexPath.row] mutableCopyWithZone:NULL];
	NSString * upperCaseCharacter = [[titleText substringToIndex:1]uppercaseString];
	[titleText deleteCharactersInRange:NSMakeRange(0, 1)];
	[titleText insertString:upperCaseCharacter atIndex:0];
	
	self.editValueViewController.title = titleText;
    [titleText release];
	self.editValueViewController.indexPath = indexPath;
	
	 //editValueViewController.editValueField.text = cell.valueLabel.text;
	self.editValueViewController.navigationItem.rightBarButtonItem.enabled = NO;
	self.editValueViewController.didEdit = NO;
	self.editValueViewController.valueToEdit = cell.valueLabel.text;
	// ..
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:self.editValueViewController animated:YES];
    
}

-(void)updateDidFailWithError:(NSError *)error
{

	UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Update Error" 
										message:@"Unable to update your profile at this time." 
										delegate:nil 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil]autorelease]; 
	
	[alert show];
	
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


- (void)dealloc 
{

	[_editValueViewController release]; _editValueViewController = nil;
    [profileEditViewCell release]; profileEditViewCell = nil;
    [cellBackgroundColors release]; cellBackgroundColors = nil;
	[keyValueDictionary release]; keyValueDictionary = nil;
	[keysToEdit release]; keysToEdit = nil;
	[profileImage release]; profileImage = nil;
	[imagePicker release]; imagePicker = nil;
    [super dealloc];
}

@end

