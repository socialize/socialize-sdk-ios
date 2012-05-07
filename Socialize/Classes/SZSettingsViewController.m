//
//  SZSettingsViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/1/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SZSettingsViewController.h"
#import "SocializeProfileEditTableViewImageCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SocializeProfileEditTableViewCell.h"
#import "UIButton+Socialize.h"
#import "SocializeProfileEditValueViewController.h"
#import "SocializePrivateDefinitions.h"
#import "UINavigationController+Socialize.h"
#import "UIImage+Resize.h"
#import "UIAlertView+BlocksKit.h"
#import "SocializeTwitterAuthenticator.h"
#import "SocializeFacebookAuthenticator.h"
#import "SocializeTwitterAuthenticator.h"
#import "SocializeThirdPartyTwitter.h"
#import "SocializeThirdPartyFacebook.h"
#import "SZUserUtils.h"

@interface SZSettingsViewController ()

// Latch the status for these, so we can perform row animations
@property (nonatomic, assign) BOOL showFacebookLogout;
@property (nonatomic, assign) BOOL showTwitterLogout;

- (void)updateInterfaceToReflectFacebookSessionStatus ;
- (void)updateInterfaceToReflectSessionStatuses;
- (void)updateInterfaceToReflectTwitterSessionStatus;
- (NSIndexPath*)indexPathForTwitterLogoutRow;
- (NSIndexPath*)indexPathForFacebookLogoutRow;
- (NSIndexPath*)indexPathForFacebookLogoutRow;
- (void)authenticateViaFacebook;
- (void)authenticateViaTwitter;

@end

typedef struct {
    NSString *displayName;
    NSString *editName;
    NSString *storageKeyPath;
} SZSettingsViewControllerPropertiesInfo;

static SZSettingsViewControllerPropertiesInfo SZSettingsViewControllerPropertiesInfoItems[] = {
    { @"first name", @"First name", @"fullUser.firstName" },
    { @"last name", @"Last name", @"fullUser.lastName" },
    { @"bio", @"Bio", @"fullUser.description" },
};


@implementation SZSettingsViewController
@synthesize fullUser = fullUser_;
@synthesize profileImageCell = profileImageCell_;
@synthesize profileImage = profileImage_;
@synthesize cellBackgroundColors = cellBackgroundColors_;
@synthesize profileTextCell = profileTextCell;
@synthesize delegate = delegate_;
@synthesize imagePicker = imagePicker_;
@synthesize uploadPicActionSheet = uploadPicActionSheet_;
@synthesize editValueController = editValueController_;
@synthesize facebookSwitch = facebookSwitch_;
@synthesize twitterSwitch = twitterSwitch_;
@synthesize bundle = bundle_;
@synthesize userDefaults = userDefaults_;
@synthesize editOccured = editOccured_;
SYNTH_BLUE_SOCIALIZE_BAR_BUTTON(saveButton, @"Save")
@synthesize facebookCells = facebookCells_;
@synthesize showFacebookLogout = showFacebookLogout_;
@synthesize showTwitterLogout = showTwitterLogout_;
@synthesize popover = popover_;

+ (UINavigationController*)profileEditViewControllerInNavigationController {
    SZSettingsViewController *profileEditViewController = [self profileEditViewController];
    UINavigationController *navigationController = [UINavigationController socializeNavigationControllerWithRootViewController:profileEditViewController];
    return navigationController;
}

+ (SZSettingsViewController*)profileEditViewController {
    return [self settingsViewController];
}

+ (SZSettingsViewController*)settingsViewController {
    return [[[[self class] alloc] init] autorelease];
}

- (void)dealloc {
    self.fullUser = nil;
    self.profileImageCell = nil;
    self.profileImage = nil;
    self.cellBackgroundColors = nil;
    self.profileTextCell = nil;
    self.imagePicker = nil;
    self.uploadPicActionSheet = nil;
    self.editValueController = nil;
    self.facebookSwitch = nil;
    self.twitterSwitch = nil;
    self.bundle = nil;
    self.userDefaults = nil;
    self.saveButton = nil;
    self.facebookCells = nil;
    self.popover = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super initWithNibName:@"SZSettingsViewController" bundle:nil];
    if (self) {
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    self.tableView.accessibilityLabel = @"edit profile";
    self.navigationItem.leftBarButtonItem = self.cancelButton;	
    self.navigationItem.rightBarButtonItem = self.saveButton;
    [self changeTitleOnCustomBarButton:self.saveButton toText:@"Done"];

    self.showTwitterLogout = [SocializeThirdPartyTwitter isLinkedToSocialize];
    self.showFacebookLogout = [SocializeThirdPartyFacebook isLinkedToSocialize];
    
    // Remove default gray background (iPad / http://stackoverflow.com/questions/2688007/uitableview-backgroundcolor-always-gray-on-ipad)
    [self.tableView setBackgroundView:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.saveButton = nil;
    self.profileImageCell = nil;
}

- (void)reloadImageCell {
	NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];    
}

- (void)setProfileImageFromImage:(UIImage*)image {
    if (image == nil) {
        self.profileImage = [UIImage imageNamed:@"socialize-profileimage-large-default.png"];
    } else {
        UIImage *resized = [image imageWithSameAspectRatioAndWidth:300.f];
        self.profileImage = resized;
    }
    
    [self reloadImageCell];
}

- (void)setProfileImageFromURL:(NSString*)imageURL {
    if (imageURL == nil) {
        [self setProfileImageFromImage:nil];
    } else {
        [self loadImageAtURL:imageURL
                startLoading:^{
                    [self.profileImageCell.spinner startAnimating];
                } stopLoading:^{
                    [self.profileImageCell.spinner stopAnimating];                    
                } completion:^(UIImage *image) {
                    [self setProfileImageFromImage:image];
                }];
    }
}

- (void)configureViewsForUser {
    if (self.profileImage == nil) {
        NSString *imageURL = self.fullUser.smallImageUrl;
        [self setProfileImageFromURL:imageURL];
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.fullUser == nil) {
        self.saveButton.enabled = NO;
        [self getCurrentUser];
    } else {
        self.saveButton.enabled = YES;
        [self configureViewsForUser];
    }
}

- (void)dismissSelfAfterSave {
    if ([self.delegate respondsToSelector:@selector(profileEditViewController:didUpdateProfileWithUser:)]) {
        [self.delegate profileEditViewController:self didUpdateProfileWithUser:self.fullUser];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)didGetCurrentUser:(id<SocializeFullUser>)fullUser {
    self.fullUser = fullUser;
    self.saveButton.enabled = YES;
    [self configureViewsForUser];
}

- (void)saveButtonPressed:(UIButton*)saveButton {
    if (self.editOccured) {
        [self startLoading];
        self.saveButton.enabled = NO;
        
        SocializeFullUser *newUser = [[(SocializeFullUser*)self.fullUser copy] autorelease];
        [SZUserUtils saveUserSettings:newUser profileImage:self.profileImage
                                  success:^(id<SocializeFullUser> fullUser) {
                                      self.fullUser = fullUser;
                                      [self stopLoading];
                                      [self dismissSelfAfterSave];
                                  } failure:^(NSError *error) {
                                      [self stopLoading];
                                      self.saveButton.enabled = YES;
                                      [self updateInterfaceToReflectSessionStatuses];
                                      [self failWithError:error];
                                  }];
    } else {
        [self dismissSelfAfterSave];
    }
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

- (NSInteger)twitterSection {
    if (![SocializeThirdPartyTwitter available]) {
        return NSNotFound;
    }
    if ([SocializeThirdPartyFacebook available]) {
        return 3;
    }
    
    return 2;
}

- (NSInteger)imageSection {
    return 0;
}

- (NSInteger)propertiesSection {
    return 1;
}

- (NSInteger)facebookSection {
    if (![SocializeThirdPartyFacebook available]) {
        return NSNotFound;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numSections = 2;
    
    if ([SocializeThirdPartyFacebook available]) {
        numSections++;
    }
    
    if ([SocializeThirdPartyTwitter available]) {
        numSections++;
    }
    
    return numSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self imageSection]) {
        return SocializeProfileEditTableViewImageCellHeight;
    }
	
	return SocializeProfileEditTableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numRows = 0;
    if (section == [self imageSection]) {
        numRows = 1;
    } else if (section == [self propertiesSection]) {
        numRows = sizeof(SZSettingsViewControllerPropertiesInfoItems) / sizeof(SZSettingsViewControllerPropertiesInfo);
    } else if (section == [self facebookSection]) {
        if (self.showFacebookLogout) {
            numRows = 2;
        } else {
            numRows = 1;
        }
    } else if (section == [self twitterSection]) {
        if (self.showTwitterLogout) {
            numRows = 2;
        } else {
            numRows = 1;
        }
    }
    
    return numRows;
}

- (void)configureProfileImageCell {
    if (self.profileImage) {
		[self.profileImageCell.spinner stopAnimating];
		self.profileImageCell.imageView.image = self.profileImage;
	}
	else {
		self.profileImageCell.spinner.hidesWhenStopped = YES;
		[self.profileImageCell.spinner startAnimating];
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

-(SocializeProfileEditTableViewCell *)getProfileEditCell
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

-(UITableViewCell*)getNormalCellWithStyle:(UITableViewCellStyle)style {
	NSString *CellIdentifier = [NSString stringWithFormat:@"NormalCell__%d", style];

	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc ] initWithStyle:style reuseIdentifier:CellIdentifier] autorelease];
    }
	
	return cell;
}


- (NSString*)keyPathForPropertiesRow:(SZSettingsViewControllerPropertiesRow)row {
    return SZSettingsViewControllerPropertiesInfoItems[row].storageKeyPath;
}

- (NSUserDefaults*)userDefaults {
    if (userDefaults_ == nil) {
        userDefaults_ = [[NSUserDefaults standardUserDefaults] retain];
    }
    
    return userDefaults_;
}

- (UISwitch*)facebookSwitch {
    if (facebookSwitch_ == nil) {
        facebookSwitch_ = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        if ([SocializeThirdPartyFacebook isLinkedToSocialize]) {
            facebookSwitch_.on = ![[self.userDefaults objectForKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY] boolValue];
        } else {
            facebookSwitch_.on = NO;
        }
        [facebookSwitch_ addTarget:self action:@selector(facebookSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return facebookSwitch_;
}

- (void)facebookSwitchChanged:(UISwitch*)facebookSwitch {
    NSNumber *dontPostToFacebook = [NSNumber numberWithBool:!facebookSwitch.on];
    [self.userDefaults setObject:dontPostToFacebook forKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY];
    [self.userDefaults synchronize];
    
    if ([facebookSwitch isOn] && ![SocializeThirdPartyFacebook isLinkedToSocialize]) {
        [self authenticateViaFacebook];
    }

}

- (UISwitch*)twitterSwitch {
    if (twitterSwitch_ == nil) {
        twitterSwitch_ = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        if ([SocializeThirdPartyTwitter isLinkedToSocialize]) {
            twitterSwitch_.on = ![[self.userDefaults objectForKey:kSOCIALIZE_DONT_POST_TO_TWITTER_KEY] boolValue];
        } else {
            twitterSwitch_.on = NO;
        }
        
        [twitterSwitch_ addTarget:self action:@selector(twitterSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return twitterSwitch_;
}

- (void)twitterSwitchChanged:(UISwitch*)twitterSwitch {
    NSNumber *dontPostToTwitter = [NSNumber numberWithBool:!twitterSwitch.isOn];
    [self.userDefaults setObject:dontPostToTwitter forKey:kSOCIALIZE_DONT_POST_TO_TWITTER_KEY];
    [self.userDefaults synchronize];
    
    if ([twitterSwitch isOn] && ![SocializeThirdPartyTwitter isLinkedToSocialize]) {
        [self authenticateViaTwitter];
    }
}

- (UIColor*)cellFontColor {
    return [UIColor colorWithRed:116.f/255.f green:137.f/255.f blue:156.f/255.f alpha:1.f];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == [self imageSection]) {
        cell = self.profileImageCell;
        [self configureProfileImageCell];
    } else if (indexPath.section == [self propertiesSection]) {
        cell = [self getProfileEditCell];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        NSString *keyText = SZSettingsViewControllerPropertiesInfoItems[indexPath.row].displayName;
        NSString *valueText = [self valueForKeyPath:[self keyPathForPropertiesRow:indexPath.row]];
        [[(SocializeProfileEditTableViewCell*)cell keyLabel] setText:keyText];
        [[(SocializeProfileEditTableViewCell*)cell valueLabel] setText:valueText];
        [[(SocializeProfileEditTableViewCell*)cell arrowImageView] setHidden:NO];
    } else if (indexPath.section == [self facebookSection]) {        
        cell = [self getNormalCellWithStyle:UITableViewCellStyleDefault];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.f];
        cell.textLabel.textColor = [self cellFontColor];
        switch (indexPath.row) {
            case SZSettingsViewControllerFacebookRowPost:
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textAlignment = UITextAlignmentLeft;
                cell.textLabel.text = @"Autopost to Facebook";
                cell.accessoryView = self.facebookSwitch;
                break;
            case SZSettingsViewControllerFacebookRowLogout:
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                cell.textLabel.text = @"Sign out of Facebook";
                cell.accessoryView = nil;
                break;
            default:
                NSAssert(NO, @"unhandled");
        }
    } else if (indexPath.section == [self twitterSection]) {
        cell = [self getNormalCellWithStyle:UITableViewCellStyleDefault];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.f];
        cell.textLabel.textColor = [self cellFontColor];
        
        switch (indexPath.row) {
            case SZSettingsViewControllerTwitterRowPost:
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textAlignment = UITextAlignmentLeft;
                cell.textLabel.text = @"Autopost to Twitter";
                cell.accessoryView = self.twitterSwitch;
                
                break;
            case SZSettingsViewControllerTwitterRowLogout:
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                cell.textLabel.text = @"Sign out of Twitter";
                cell.accessoryView = nil;
                
                break;
            default:
                NSAssert(NO, @"unhandled");
        }
    } else {
        NSAssert(NO, @"unhandled section");
    }
    
    cell.backgroundColor = [self cellBackgroundColorForIndexPath:indexPath];
    
    return cell;
}

- (BOOL)haveCamera {
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
}

- (UIActionSheet*)uploadPicActionSheet {
    if (uploadPicActionSheet_ == nil) {
        if ([self haveCamera]) {
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
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];

	if( buttonIndex == actionSheet.cancelButtonIndex ) {
		return;
	}	
	if (buttonIndex == 1) {
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	} else if (buttonIndex == 0) {
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.popover = [[[UIPopoverController alloc] initWithContentViewController:self.imagePicker] autorelease];
        self.popover.delegate = self;
        CGRect rect = self.profileImageCell.frame;
        [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentModalViewController:self.imagePicker animated:YES];
    }
}

- (void)configureForAfterEdit {
    self.editOccured = YES;
    [self changeTitleOnCustomBarButton:self.saveButton toText:@"Save"];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.popover dismissPopoverAnimated:YES];
    } else {
        [picker dismissModalViewControllerAnimated:YES];
    }
	
    [self configureForAfterEdit];
    [self setProfileImageFromImage:image];
}

#pragma mark - Table view delegate

- (SocializeProfileEditValueViewController*)editValueController {
    if (editValueController_ == nil) {
        editValueController_ = [[SocializeProfileEditValueViewController alloc] init];
        editValueController_.delegate = self;
    }
    return editValueController_;
}

- (void)baseViewControllerDidFinish:(SocializeBaseViewController *)baseViewController {
    if (baseViewController == self.editValueController) {
        [self.navigationController popViewControllerAnimated:YES];
        [self configureForAfterEdit];
        
        NSIndexPath * indexPath = self.editValueController.indexPath;
        
        NSString *keyPath = [self keyPathForPropertiesRow:indexPath.row];
        [self setValue:self.editValueController.editValueField.text forKeyPath:keyPath];
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)baseViewControllerDidCancel:(SocializeBaseViewController *)baseViewController {
    if (baseViewController == self.editValueController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)twitterLogout {
    [SocializeThirdPartyTwitter removeLocalCredentials];
    [self updateInterfaceToReflectTwitterSessionStatus];
}

- (void)facebookLogout {
    [SocializeThirdPartyFacebook removeLocalCredentials];
    [self updateInterfaceToReflectFacebookSessionStatus];
}

- (NSIndexPath*)indexPathForTwitterLogoutRow {
    return [NSIndexPath indexPathForRow:SZSettingsViewControllerTwitterRowLogout inSection:[self twitterSection]];
}

- (NSIndexPath*)indexPathForFacebookLogoutRow {
    return [NSIndexPath indexPathForRow:SZSettingsViewControllerFacebookRowLogout inSection:[self facebookSection]];
}

- (void)showConfirmLogoutDialogForService:(NSString*)service handler:(void(^)())handler {
    NSString *message = [NSString stringWithFormat:@"%@ functionality will be disabled until you log in again", service];
    UIAlertView *alertView = [UIAlertView alertWithTitle:@"Are You Sure?" message:message];
    [alertView setCancelButtonWithTitle:@"Cancel" handler:^{}];
    [alertView addButtonWithTitle:@"Log Out" handler:handler];
    [alertView show];
}

- (void)scrollToTwitterLogoutRow {
    [self.tableView scrollToRowAtIndexPath:[self indexPathForTwitterLogoutRow] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)twitterAuthenticatorDidSucceed:(SocializeTwitterAuthenticator *)twitterAuthenticator {
    
    // Add the twitter logout row
    [self updateInterfaceToReflectSessionStatuses];
}

- (void)twitterAuthenticator:(SocializeTwitterAuthenticator *)twitterAuthenticator didFailWithError:(NSError *)error {
    [self updateInterfaceToReflectSessionStatuses];
}

- (void)authenticateViaTwitter {
    SocializeTwitterAuthOptions *options = [SocializeTwitterAuthOptions options];
    options.doNotShowProfile = YES;
    options.doNotPromptForPermission = YES;

    [SocializeTwitterAuthenticator authenticateViaTwitterWithOptions:options
                                              display:self
                                              success:^{
                                                  [self updateInterfaceToReflectSessionStatuses];
                                              } failure:^(NSError *error) {
                                                  [self updateInterfaceToReflectSessionStatuses];
                                              }];
}

- (void)authenticateViaFacebook {
    SocializeFacebookAuthOptions *options = [SocializeFacebookAuthOptions options];
    options.doNotShowProfile = YES;

    [SocializeFacebookAuthenticator authenticateViaFacebookWithOptions:options
                                                                display:self
                                                                success:^{
                                                                    [self updateInterfaceToReflectSessionStatuses];
                                                                } failure:^(NSError *error) {
                                                                    [self updateInterfaceToReflectSessionStatuses];
                                                                }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block __typeof__(self) weakSelf = self;
    
	if (indexPath.section == [self imageSection]) 
	{
		[self showActionSheet];
		return;
	} else if (indexPath.section == [self propertiesSection]) {
        NSString *editName = SZSettingsViewControllerPropertiesInfoItems[indexPath.row].editName;
        self.editValueController.title = editName;
        self.editValueController.valueToEdit = [self valueForKeyPath:[self keyPathForPropertiesRow:indexPath.row]];
        self.editValueController.indexPath = indexPath;
        [self.navigationController pushViewController:self.editValueController animated:YES];
    } else if (indexPath.section == [self twitterSection]) {
        if (indexPath.row == SZSettingsViewControllerTwitterRowLogout) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self showConfirmLogoutDialogForService:@"Twitter" handler:^{ [weakSelf twitterLogout]; }];
        }
    } else if (indexPath.section == [self facebookSection]) {
        if (indexPath.row == SZSettingsViewControllerFacebookRowLogout) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self showConfirmLogoutDialogForService:@"Facebook" handler:^{ [weakSelf facebookLogout]; }];
        }
    }
}

- (void)updateInterfaceToReflectFacebookSessionStatus {
    if ([self facebookSection] == NSNotFound) {
        return;
    }
    
    if ([SocializeThirdPartyFacebook isLinkedToSocialize] && !self.showFacebookLogout) {

        // Logout button should be shown but isn't. Animate it into view
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:SZSettingsViewControllerFacebookRowLogout inSection:[self facebookSection]];        
        [self.tableView beginUpdates];
        self.showFacebookLogout = YES;
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    } else if (![SocializeThirdPartyFacebook isLinkedToSocialize] && self.showFacebookLogout) {
        
        // Logout button shown but shouldn't be. Animate it out of view
        [self.tableView beginUpdates];
        self.showFacebookLogout = NO;
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self indexPathForFacebookLogoutRow]] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];

    }
    
    if (![SocializeThirdPartyFacebook isLinkedToSocialize]) {
        // Force switch to off
        if ([self.facebookSwitch isOn]) {
            [self.facebookSwitch setOn:NO animated:YES];
        } 
    }
}

- (void)updateInterfaceToReflectTwitterSessionStatus {
    if ([self twitterSection] == NSNotFound) {
        return;
    }

    if ([SocializeThirdPartyTwitter isLinkedToSocialize] && !self.showTwitterLogout) {

        // Logout button should be shown but isn't. Animate it into view
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:SZSettingsViewControllerTwitterRowLogout inSection:[self twitterSection]];
        [self.tableView beginUpdates];
        self.showTwitterLogout = YES;
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
        
        // Since twitter logout is currently the last row, it feels awkward if we don't scroll
        [self scrollToTwitterLogoutRow];

    } else if (![SocializeThirdPartyTwitter isLinkedToSocialize] && self.showTwitterLogout) {
        
        // Logout button shown but shouldn't be. Animate it out of view
        [self.tableView beginUpdates];
        self.showTwitterLogout = NO;
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self indexPathForTwitterLogoutRow]] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];

    }
    
    if (![SocializeThirdPartyTwitter isLinkedToSocialize]) {
        // Force switch to off
        if ([self.twitterSwitch isOn]) {
            [self.twitterSwitch setOn:NO animated:YES];
        }
    }
}

- (void)updateInterfaceToReflectSessionStatuses {
    [self updateInterfaceToReflectFacebookSessionStatus];
    [self updateInterfaceToReflectTwitterSessionStatus];
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object
{
    self.fullUser = (id<SocializeFullUser>)object;
    [self stopLoading];
    
    [self dismissSelfAfterSave];
}

- (void)didAuthenticate:(id<SocializeUser>)user {
    [self stopLoading];
    [self updateInterfaceToReflectSessionStatuses];
}

@end
