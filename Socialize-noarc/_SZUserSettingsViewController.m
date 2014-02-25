//
//  _SZUserSettingsViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/1/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "_SZUserSettingsViewController.h"
#import "SocializeProfileEditTableViewImageCell.h"
#import <QuartzCore/QuartzCore.h>
#import <SZBlocksKit/BlocksKit+UIKit.h>
#import "SocializeProfileEditTableViewCell.h"
#import "UIButton+Socialize.h"
#import "SocializeProfileEditValueViewController.h"
#import "SocializePrivateDefinitions.h"
#import "UINavigationController+Socialize.h"
#import "UIImage+Resize.h"
#import "SocializeThirdPartyTwitter.h"
#import "SocializeThirdPartyFacebook.h"
#import "SZUserUtils.h"
#import "UITableView+Socialize.h"
#import "SZFacebookUtils.h"
#import "SZTwitterUtils.h"
#import "SDKHelpers.h"
#import "socialize_globals.h"
#import "UIDevice+VersionCheck.h"

@interface _SZUserSettingsViewController () {
    BOOL _initialized;
}

// Latch the status for these, so we can perform row animations
@property (nonatomic, assign) BOOL showingFacebookPostRow;
@property (nonatomic, assign) BOOL showingTwitterPostRow;
@property (nonatomic, assign) BOOL profileImageChanged;

@end

typedef struct {
    NSString *displayName;
    NSString *editName;
    NSString *storageKeyPath;
} _SZUserSettingsViewControllerPropertiesInfo;

static _SZUserSettingsViewControllerPropertiesInfo _SZUserSettingsViewControllerPropertiesInfoItems[] = {
    { @"first name", @"First name", @"fullUser.firstName" },
    { @"last name", @"Last name", @"fullUser.lastName" },
    { @"bio", @"Bio", @"fullUser.description" },
};


@implementation _SZUserSettingsViewController
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
@synthesize showingFacebookPostRow = showingFacebookPostRow_;
@synthesize showingTwitterPostRow = showingTwitterPostRow_;
@synthesize popover = popover_;
@synthesize userSettingsCompletionBlock = userSettingsCompletionBlock_;
@synthesize profileImageChanged = _profileImageChanged;
@synthesize hideLogoutButtons = _hideLogoutButtons;

+ (UINavigationController*)profileEditViewControllerInNavigationController {
    _SZUserSettingsViewController *profileEditViewController = [self profileEditViewController];
    UINavigationController *navigationController = [UINavigationController socializeNavigationControllerWithRootViewController:profileEditViewController];
    return navigationController;
}

+ (_SZUserSettingsViewController*)profileEditViewController {
    return [self settingsViewController];
}

+ (_SZUserSettingsViewController*)settingsViewController {
    return [[[[self class] alloc] init] autorelease];
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
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
    self.userSettingsCompletionBlock = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)cancel {
    BLOCK_CALL_2(self.userSettingsCompletionBlock, NO, self.fullUser);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    self.tableView.accessibilityLabel = @"edit profile";
    
    //iOS 7 adjustments
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    WEAK(self) weakSelf = self;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem redSocializeBarButtonWithTitle:@"Cancel" handler:^(id _) {
        [weakSelf cancel];
    }];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    [self changeTitleOnCustomBarButton:self.saveButton toText:@"Done"];

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
        if([[UIDevice currentDevice] systemMajorVersion] < 7) {
            self.profileImage = [UIImage imageNamed:@"socialize-profileimage-large-default.png"];
        }
        else {
            self.profileImage = [UIImage imageNamed:@"socialize-profileimage-large-default-ios7.png"];
        }
    }
    else {
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

- (void)userChanged:(id<SZFullUser>)newUser {
    self.fullUser = newUser;
    self.profileImage = nil;
    [self configureViewsForUser];
}

- (void)configureViewsForUser {
    if (self.profileImage == nil) {
        NSString *imageURL = self.fullUser.smallImageUrl;
        [self setProfileImageFromURL:imageURL];
    }
    [self.tableView reloadData];
}

- (BOOL)shouldShowTwitterPostRow {
    return [SocializeThirdPartyTwitter isLinkedToSocialize];
}

- (BOOL)shouldShowFacebookPostRow {
    return [SocializeThirdPartyFacebook isLinkedToSocialize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_initialized) {
        _initialized = YES;
        
        self.showingTwitterPostRow = [self shouldShowTwitterPostRow];
        self.showingFacebookPostRow = [self shouldShowFacebookPostRow];
    }
    
    if (self.fullUser == nil) {
        self.saveButton.enabled = NO;
        self.fullUser = [SZUserUtils currentUser];
        [self configureViewsForUser];
    } else {
        self.saveButton.enabled = YES;
        [self configureViewsForUser];
    }
    
    if ([self.navigationController.viewControllers count] >= 2) {
        [self.navigationItem.leftBarButtonItem changeTitleOnCustomButtonToText:@"Back"];
    }
}

- (SZUserSettings*)userSettingsForInterfaceState {
    SZUserSettings *userSettings = [[[SZUserSettings alloc] initWithFullUser:self.fullUser] autorelease];
    
    BOOL postToFacebook = [SZFacebookUtils isLinked] && self.facebookSwitch.on;
    userSettings.dontPostToFacebook = [NSNumber numberWithBool:!postToFacebook];

    BOOL postToTwitter = [SZTwitterUtils isLinked] && self.twitterSwitch.on;
    userSettings.dontPostToTwitter = [NSNumber numberWithBool:!postToTwitter];
    
    BOOL autopost = postToTwitter || postToFacebook;
    userSettings.autopostEnabled = [NSNumber numberWithBool:autopost];

    if (self.profileImageChanged) {
        userSettings.profileImage = self.profileImage;
    }
    
    return userSettings;
}

- (void)dismissSelfDidSave:(BOOL)didSave {
    if (self.userSettingsCompletionBlock != nil) {
        self.userSettingsCompletionBlock(didSave, self.fullUser);
    } else if ([self.delegate respondsToSelector:@selector(profileEditViewController:didUpdateProfileWithUser:)]) {
        [self.delegate profileEditViewController:self didUpdateProfileWithUser:self.fullUser];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
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
        
        SZUserSettings *settings = [self userSettingsForInterfaceState];
        [SZUserUtils saveUserSettings:settings
                                  success:^(SZUserSettings *settings, id<SocializeFullUser> fullUser) {
                                      self.fullUser = fullUser;
                                      [self stopLoading];
                                      [self dismissSelfDidSave:YES];
                                  } failure:^(NSError *error) {
                                      [self stopLoading];
                                      self.saveButton.enabled = YES;
                                      [self updateInterfaceToReflectSessionStatuses];
                                      [self failWithError:error];
                                  }];
    } else {
        [self dismissSelfDidSave:NO];
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

- (UIColor*)cellBackgroundColorForIndexPath:(NSIndexPath*)indexPath {
    NSInteger offset = [self.tableView offsetForIndexPath:indexPath];
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
        numRows = sizeof(_SZUserSettingsViewControllerPropertiesInfoItems) / sizeof(_SZUserSettingsViewControllerPropertiesInfo);
    } else if (section == [self facebookSection]) {
        if (self.showingFacebookPostRow) {
            numRows = 2;
        } else {
            numRows = 1;
        }
    } else if (section == [self twitterSection]) {
        if (self.showingTwitterPostRow) {
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
//		[self.profileImageCell.spinner startAnimating];
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


- (NSString*)keyPathForPropertiesRow:(_SZUserSettingsViewControllerPropertiesRow)row {
    return _SZUserSettingsViewControllerPropertiesInfoItems[row].storageKeyPath;
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
            BOOL switchOn = ![[self.userDefaults objectForKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY] boolValue] && [[self.userDefaults objectForKey:kSocializeAutoPostToSocialNetworksKey] boolValue];
            facebookSwitch_.on = switchOn;
        } else {
            facebookSwitch_.on = NO;
        }
        [facebookSwitch_ addTarget:self action:@selector(facebookSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return facebookSwitch_;
}

- (void)facebookSwitchChanged:(UISwitch*)facebookSwitch {
    [self configureForAfterEdit];

    if ([facebookSwitch isOn] && ![SocializeThirdPartyFacebook isLinkedToSocialize]) {
        [self authenticateViaFacebook];
    }

}

- (UISwitch*)twitterSwitch {
    if (twitterSwitch_ == nil) {
        twitterSwitch_ = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        if ([SocializeThirdPartyTwitter isLinkedToSocialize]) {
            BOOL switchOn = ![[self.userDefaults objectForKey:kSOCIALIZE_DONT_POST_TO_TWITTER_KEY] boolValue] && [[self.userDefaults objectForKey:kSocializeAutoPostToSocialNetworksKey] boolValue];
            twitterSwitch_.on = switchOn;
        } else {
            twitterSwitch_.on = NO;
        }
        
        [twitterSwitch_ addTarget:self action:@selector(twitterSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return twitterSwitch_;
}

- (void)twitterSwitchChanged:(UISwitch*)twitterSwitch {
    [self configureForAfterEdit];

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
        NSString *keyText = _SZUserSettingsViewControllerPropertiesInfoItems[indexPath.row].displayName;
        NSString *valueText = [self valueForKeyPath:[self keyPathForPropertiesRow:indexPath.row]];
        [[(SocializeProfileEditTableViewCell*)cell keyLabel] setText:keyText];
        [[(SocializeProfileEditTableViewCell*)cell valueLabel] setText:valueText];
        [[(SocializeProfileEditTableViewCell*)cell arrowImageView] setHidden:NO];
    } else if (indexPath.section == [self facebookSection]) {        
        cell = [self getNormalCellWithStyle:UITableViewCellStyleDefault];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.f];
        cell.textLabel.textColor = [self cellFontColor];
        switch (indexPath.row) {
            case _SZUserSettingsViewControllerFacebookRowPost:
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.textLabel.text = @"Post to Facebook by Default";
                cell.accessoryView = self.facebookSwitch;
                break;
            case _SZUserSettingsViewControllerFacebookRowLoginLogout:
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                
                if ([SZFacebookUtils isLinked]) {
                    if (self.hideLogoutButtons) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.textLabel.text = @"Logged in to Facebook";
                    } else {
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        cell.textLabel.text = @"Sign out of Facebook";                        
                    }
                } else {
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.textLabel.text = @"Sign in to Facebook";
                }
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
            case _SZUserSettingsViewControllerTwitterRowPost:
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.textLabel.text = @"Post to Twitter by Default";
                cell.accessoryView = self.twitterSwitch;
                
                break;
            case _SZUserSettingsViewControllerTwitterRowLoginLogout:
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                
                if ([SZTwitterUtils isLinked]) {
                    
                    if (self.hideLogoutButtons) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.textLabel.text = @"Logged in to Twitter";
                    } else {
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        cell.textLabel.text = @"Sign out of Twitter";
                    }
                    
                } else {
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.textLabel.text = @"Sign in to Twitter";
                }

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
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

- (void)configureForAfterEdit {
    self.saveButton.enabled = YES;
    self.editOccured = YES;
    [self changeTitleOnCustomBarButton:self.saveButton toText:@"Save"];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.profileImageChanged = YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.popover dismissPopoverAnimated:YES];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
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

- (NSIndexPath*)indexPathForTwitterPostRow {
    return [NSIndexPath indexPathForRow:_SZUserSettingsViewControllerTwitterRowPost inSection:[self twitterSection]];
}

- (NSIndexPath*)indexPathForFacebookPostRow {
    return [NSIndexPath indexPathForRow:_SZUserSettingsViewControllerFacebookRowPost inSection:[self facebookSection]];
}

- (NSIndexPath*)indexPathForTwitterLogoutRow {
    return [NSIndexPath indexPathForRow:_SZUserSettingsViewControllerTwitterRowLoginLogout inSection:[self twitterSection]];
}

- (NSIndexPath*)indexPathForFacebookLogoutRow {
    return [NSIndexPath indexPathForRow:_SZUserSettingsViewControllerFacebookRowLoginLogout inSection:[self facebookSection]];
}

- (void)showConfirmLogoutDialogForService:(NSString*)service handler:(void(^)())handler {
    NSString *message = [NSString stringWithFormat:@"%@ functionality will be disabled until you log in again", service];
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"Are You Sure?" message:message];
    [alertView bk_setCancelButtonWithTitle:@"Cancel" handler:^{}];
    [alertView bk_addButtonWithTitle:@"Log Out" handler:handler];
    [alertView show];
}

- (void)scrollToTwitterLogoutRow {
    [self.tableView scrollToRowAtIndexPath:[self indexPathForTwitterLogoutRow] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)authenticateViaTwitter {
    [SZTwitterUtils linkWithViewController:self success:^(id<SZFullUser> user) {
        [self configureForAfterEdit];
        [self updateInterfaceToReflectSessionStatuses];
    } failure:^(NSError *error) {
        [self configureForAfterEdit];
        [self updateInterfaceToReflectSessionStatuses];        
    }];
}

- (void)authenticateViaFacebook {
    SZShowLinkToFacebookAlertView(^{

        [SZFacebookUtils linkWithOptions:nil success:^(id<SZFullUser> user) {
            [self configureForAfterEdit];
            [self updateInterfaceToReflectSessionStatuses];
        } foreground:^{
            [self updateInterfaceToReflectSessionStatuses];            
        } failure:^(NSError *error) {
            [self configureForAfterEdit];
            [self updateInterfaceToReflectSessionStatuses];        
        }];
    }, ^{
        [self updateInterfaceToReflectSessionStatuses];
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAK(self) weakSelf = self;
    
	if (indexPath.section == [self imageSection]) 
	{
		[self showActionSheet];
		return;
	} else if (indexPath.section == [self propertiesSection]) {
        NSString *editName = _SZUserSettingsViewControllerPropertiesInfoItems[indexPath.row].editName;
        self.editValueController.title = editName;
        self.editValueController.valueToEdit = [self valueForKeyPath:[self keyPathForPropertiesRow:indexPath.row]];
        self.editValueController.indexPath = indexPath;
        [self.navigationController pushViewController:self.editValueController animated:YES];
    } else if (indexPath.section == [self twitterSection]) {
        if (indexPath.row == _SZUserSettingsViewControllerTwitterRowLoginLogout) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            if ([SZTwitterUtils isLinked]) {
                
                if (!self.hideLogoutButtons) {
                    [self showConfirmLogoutDialogForService:@"Twitter" handler:^{ [weakSelf twitterLogout]; }];
                }
            } else {
                [self authenticateViaTwitter];
            }
        }
    } else if (indexPath.section == [self facebookSection]) {
        if (indexPath.row == _SZUserSettingsViewControllerFacebookRowLoginLogout) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

            if ([SZFacebookUtils isLinked]) {
                
                if (!self.hideLogoutButtons) {
                    [self showConfirmLogoutDialogForService:@"Facebook" handler:^{ [weakSelf facebookLogout]; }];
                }
                
            } else {
                [self authenticateViaFacebook];
            }
        }
    }
}

- (void)reloadFacebookLoginLogoutRow {
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self indexPathForFacebookLogoutRow]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadTwitterLoginLogoutRow {
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self indexPathForTwitterLogoutRow]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateInterfaceToReflectFacebookSessionStatus {
    if ([self facebookSection] == NSNotFound) {
        return;
    }
    
    if ([self shouldShowFacebookPostRow] && !self.showingFacebookPostRow) {

        // Autopost row should be shown but isn't. Animate it into view
        [self.tableView beginUpdates];
        self.showingFacebookPostRow = YES;
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[self indexPathForFacebookPostRow]] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
        [self reloadFacebookLoginLogoutRow];
    } else if (![self shouldShowFacebookPostRow] && self.showingFacebookPostRow) {
        
        // Autopost shown but shouldn't be. Animate it out of view
        [self.tableView beginUpdates];
        self.showingFacebookPostRow = NO;
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self indexPathForFacebookPostRow]] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
        
        [self reloadFacebookLoginLogoutRow];
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

    if ([self shouldShowTwitterPostRow] && !self.showingTwitterPostRow) {

        // Autpost row should be shown but isn't. Animate it into view
        [self.tableView beginUpdates];
        self.showingTwitterPostRow = YES;
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[self indexPathForTwitterPostRow]] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
        [self reloadTwitterLoginLogoutRow];

        // Since twitter logout is currently the last row, it feels awkward if we don't scroll
        [self scrollToTwitterLogoutRow];

    } else if (![self shouldShowTwitterPostRow] && self.showingTwitterPostRow) {
        
        // Autpost row shown but shouldn't be. Animate it out of view
        [self.tableView beginUpdates];
        self.showingTwitterPostRow = NO;
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self indexPathForTwitterPostRow]] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];

        [self reloadTwitterLoginLogoutRow];

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
    
    [self dismissSelfDidSave:YES];
}

- (void)didAuthenticate:(id<SocializeUser>)user {
    [self stopLoading];
    [self updateInterfaceToReflectSessionStatuses];
}

@end
