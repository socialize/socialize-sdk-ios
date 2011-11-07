//
//  SocializeProfileEditViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/1/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeProfileEditViewController.h"
#import "SocializeProfileEditTableViewImageCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SocializeProfileEditTableViewCell.h"
#import "UIButton+Socialize.h"
#import "SocializeProfileEditValueController.h"
#import "SocializePrivateDefinitions.h"


typedef struct {
    NSString *displayName;
    NSString *editName;
    NSString *storageKeyPath;
} SocializeProfileEditViewControllerPropertiesInfo;

static SocializeProfileEditViewControllerPropertiesInfo SocializeProfileEditViewControllerPropertiesInfoItems[] = {
    { @"first name", @"First name", @"firstName" },
    { @"last name", @"Last name", @"lastName" },
    { @"bio", @"Bio", @"bio" },
};


typedef struct {
    NSInteger rowCount;
} SocializeProfileEditViewControllerSectionInfo;

static SocializeProfileEditViewControllerSectionInfo SocializeProfileEditViewControllerSectionInfoItems[] = {
    { SocializeProfileEditViewControllerNumImageRows },
    { SocializeProfileEditViewControllerNumPropertiesRows },
    { SocializeProfileEditViewControllerNumPermissionsRows },
};

@implementation SocializeProfileEditViewController
@synthesize firstName = firstName_;
@synthesize lastName = lastName_;
@synthesize bio = bio_;
@synthesize profileImageCell = profileImageCell_;
@synthesize profileImage = profileImage_;
@synthesize cellBackgroundColors = cellBackgroundColors_;
@synthesize profileTextCell = profileTextCell;
@synthesize cancelButton = cancelButton_;
@synthesize saveButton = saveButton_;
@synthesize delegate = delegate_;
@synthesize imagePicker = imagePicker_;
@synthesize uploadPicActionSheet = uploadPicActionSheet_;
@synthesize editValueController = editValueController_;
@synthesize facebookSwitch = facebookSwitch_;
@synthesize bundle = bundle_;

- (void)dealloc {
    self.firstName = nil;
    self.lastName = nil;
    self.bio = nil;
    self.profileImageCell = nil;
    self.profileImage = nil;
    self.cellBackgroundColors = nil;
    self.profileTextCell = nil;
    self.cancelButton = nil;
    self.saveButton = nil;
    self.imagePicker = nil;
    self.uploadPicActionSheet = nil;
    self.editValueController = nil;
    self.facebookSwitch = nil;
    self.bundle = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super initWithNibName:@"SocializeProfileEditViewController" bundle:nil];
    if (self) {
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.cancelButton;	
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.cancelButton = nil;
    self.saveButton = nil;
}

- (UIBarButtonItem*)cancelButton {
    if (cancelButton_ == nil) {
        UIButton * actualButton = [UIButton redSocializeNavBarButtonWithTitle:@"Cancel"];
        [actualButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton_ = [[UIBarButtonItem alloc] initWithCustomView:actualButton];
    }
    return cancelButton_;
}

- (void)cancelButtonPressed:(UIButton*)cancelButton {
    [self.delegate profileEditViewControllerDidCancel:self];
}

- (void)saveButtonPressed:(UIButton*)saveButton {
    [self.delegate profileEditViewControllerDidSave:self];
}

- (UIBarButtonItem*)saveButton {
    if (saveButton_ == nil) {
        UIButton * actualButton = [UIButton blueSocializeNavBarButtonWithTitle:@"Save"];
        [actualButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        saveButton_ = [[UIBarButtonItem alloc] initWithCustomView:actualButton];
    }
    return saveButton_;
}

- (NSArray*)cellBackgroundColors {
    if (cellBackgroundColors_ == nil) {
        cellBackgroundColors_ = [[NSArray arrayWithObjects:
                                  [UIColor colorWithRed:35/255.0f green:43/255.0f blue:50/255.0f alpha:1.0],
                                  [UIColor colorWithRed:44/255.0f green:54/255.0f blue:63/255.0f alpha:1.0],
                                  nil] retain];
    }
    
    return cellBackgroundColors_;
}

- (NSInteger)offsetForIndexPath:(NSIndexPath*)indexPath {
    NSInteger offset = 0;
    for (int i = 0; i < indexPath.section; i++) {
        offset += [self.tableView numberOfRowsInSection:i];
    }
    offset += indexPath.row;
    return offset;
}

- (UIColor*)cellBackgroundColorForIndexPath:(NSIndexPath*)indexPath {
    NSInteger offset = [self offsetForIndexPath:indexPath];
    return [self.cellBackgroundColors objectAtIndex:offset % 2];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SocializeProfileEditViewControllerNumSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SocializeProfileEditViewControllerSectionImage) {
        return SocializeProfileEditTableViewImageCellHeight;
    }
	
	return SocializeProfileEditTableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SocializeProfileEditViewControllerSectionInfoItems[section].rowCount;
}

- (void)configureProfileImageCell {
    if (self.profileImage) {
		[profileImageCell_.spinner stopAnimating];
		profileImageCell_.imageView.image = self.profileImage;
	}
	else {
		profileImageCell_.spinner.hidesWhenStopped = YES;
		[profileImageCell_.spinner startAnimating];
	}
}

- (NSBundle*)bundle {
    if (bundle_ == nil) {
        bundle_ = [[NSBundle mainBundle] retain];
    }
    return bundle_;
}

- (SocializeProfileEditTableViewImageCell *)profileImageCell
{
	if (profileImageCell_ == nil) {
		[self.bundle loadNibNamed:@"SocializeProfileEditTableViewImageCell" owner:self options:nil];
        [profileImageCell_.imageView.layer setCornerRadius:4];
        [profileImageCell_.imageView.layer setMasksToBounds:YES];
	}
    
	return profileImageCell_;
}

-(SocializeProfileEditTableViewCell *)getNormalCell
{
	
	static NSString *CellIdentifier = @"profile_edit_cell";
	
	SocializeProfileEditTableViewCell *cell =(SocializeProfileEditTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		[self.bundle loadNibNamed:@"SocializeProfileEditTableViewCell" owner:self options:nil];
		cell = self.profileTextCell;
		self.profileTextCell = nil;
	}
	
	return cell;	
}

- (NSString*)keyPathForPropertiesRow:(SocializeProfileEditViewControllerPropertiesRow)row {
    return SocializeProfileEditViewControllerPropertiesInfoItems[row].storageKeyPath;
}

- (UISwitch*)facebookSwitch {
    if (facebookSwitch_ == nil) {
        facebookSwitch_ = [[UISwitch alloc] initWithFrame:CGRectZero];
        facebookSwitch_.on = ![[[NSUserDefaults standardUserDefaults] valueForKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY] boolValue];
        [facebookSwitch_ addTarget:self action:@selector(facebookSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return facebookSwitch_;
}

- (void)facebookSwitchChanged:(UISwitch*)facebookSwitch {
    NSNumber *dontPostToFacebook = [NSNumber numberWithBool:!facebookSwitch.on];
    [[NSUserDefaults standardUserDefaults] setObject:dontPostToFacebook forKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case SocializeProfileEditViewControllerSectionImage:
            cell = self.profileImageCell;
            [self configureProfileImageCell];
            break;
            
        case SocializeProfileEditViewControllerSectionProperties:
            cell = [self getNormalCell];
            NSString *keyText = SocializeProfileEditViewControllerPropertiesInfoItems[indexPath.row].displayName;
            NSString *valueText = [self valueForKeyPath:[self keyPathForPropertiesRow:indexPath.row]];
            [[(SocializeProfileEditTableViewCell*)cell keyLabel] setText:keyText];
            [[(SocializeProfileEditTableViewCell*)cell valueLabel] setText:valueText];
            [[(SocializeProfileEditTableViewCell*)cell arrowImageView] setHidden:NO];
            break;
            
        case SocializeProfileEditViewControllerSectionPermissions:
            cell = [self getNormalCell];
            switch (indexPath.row) {
                case SocializeProfileEditViewControllerPermissionsRowFacebook:
                    [[(SocializeProfileEditTableViewCell*)cell keyLabel] setText:@"Post to Facebook"];
                    [[(SocializeProfileEditTableViewCell*)cell valueLabel] setText:nil];
                    [[(SocializeProfileEditTableViewCell*)cell arrowImageView] setHidden:YES];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryView = self.facebookSwitch;
                    break;
                default:
                    NSAssert(NO, @"unhandled");
            }
            break;
        default:
            NSAssert(NO, @"unhandled");


    }
    cell.backgroundColor = [self cellBackgroundColorForIndexPath:indexPath];
    
    return cell;
}

- (UIActionSheet*)uploadPicActionSheet {
    if (uploadPicActionSheet_ == nil) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            uploadPicActionSheet_ = [[UIActionSheet alloc] initWithTitle:nil
                                                                delegate:self 
                                                       cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"Choose From Album",@"Take Picture", nil];
            
            
        } else 	{
            uploadPicActionSheet_ = [[UIActionSheet alloc] initWithTitle:nil
                                                                delegate:self 
                                                       cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"Choose From Album",nil];	
        }
    }
    return uploadPicActionSheet_;
}

-(void) showActionSheet
{
    [self.uploadPicActionSheet showInView:self.view.window];
}

- (UIImagePickerController*)imagePicker {
    if (imagePicker_ == nil) {
        imagePicker_ = [[UIImagePickerController alloc] init];
        imagePicker_.delegate = self;
        imagePicker_.allowsEditing = YES;
    }
    
    return imagePicker_;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	DebugLog(@"getting callback from actions sheet. index is %i and cancel button index is:%i", buttonIndex, actionSheet.cancelButtonIndex);
	if( buttonIndex == actionSheet.cancelButtonIndex ) {
		return;
	}	
	if (buttonIndex == 1) {
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	} else if (buttonIndex == 0) {
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	
	[self presentModalViewController:self.imagePicker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    DebugLog(@"image was picked!!!");
	
	self.navigationItem.rightBarButtonItem.enabled = YES;
    //[self.view setNeedsDisplay];
	[picker dismissModalViewControllerAnimated:YES];
	
	[self setProfileImage:image];
    
	NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Table view delegate

- (SocializeProfileEditValueController*)editValueController {
    if (editValueController_ == nil) {
        editValueController_ = [[SocializeProfileEditValueController alloc] initWithStyle:UITableViewStyleGrouped];
        editValueController_.delegate = self;
    }
    return editValueController_;
}

- (void)profileEditValueControllerDidSave:(SocializeProfileEditValueController *)profileEditValueController
{
	[self.navigationController popViewControllerAnimated:YES];
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	NSIndexPath * indexPath = self.editValueController.indexPath;
	
    NSString *keyPath = [self keyPathForPropertiesRow:indexPath.row];
    [self setValue:self.editValueController.editValueField.text forKeyPath:keyPath];
	
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)profileEditValueControllerDidCancel:(SocializeProfileEditValueController *)profileEditValueController
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == SocializeProfileEditViewControllerSectionImage) 
	{
		[self showActionSheet];
		return;
	}
    
    NSString *editName = SocializeProfileEditViewControllerPropertiesInfoItems[indexPath.row].editName;
    self.editValueController.title = editName;
    self.editValueController.valueToEdit = [self valueForKeyPath:[self keyPathForPropertiesRow:indexPath.row]];
    self.editValueController.indexPath = indexPath;
    [self.navigationController pushViewController:self.editValueController animated:YES];
}

@end
