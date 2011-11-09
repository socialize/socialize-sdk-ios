//
//  SocializeProfileEditViewControllerTest.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/3/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeProfileEditViewControllerTest.h"
#import "SocializeProfileEditViewController.h"
#import "SocializeProfileEditTableViewImageCell.h"
#import "SocializeProfileEditTableViewCell.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SocializePrivateDefinitions.h"

@interface SocializeProfileEditViewController ()
- (void)cancelButtonPressed:(UIButton*)button;
- (void)saveButtonPressed:(UIButton*)button;
- (void)facebookSwitchChanged:(UISwitch*)facebookSwitch;
- (BOOL)haveCamera;
- (void)configureProfileImageCell;
@end

@implementation SocializeProfileEditViewControllerTest
@synthesize origProfileEditViewController = origProfileEditViewController_;
@synthesize profileEditViewController = profileEditViewController_;
@synthesize mockDelegate = mockDelegate_;
@synthesize mockTableView = mockTableView_;
@synthesize mockBundle = mockBundle_;
- (void)setUp {
    self.origProfileEditViewController = [[[SocializeProfileEditViewController alloc] init] autorelease];
    self.profileEditViewController = [OCMockObject partialMockForObject:self.origProfileEditViewController];
    self.mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeProfileEditViewControllerDelegate)];
    self.profileEditViewController.delegate = self.mockDelegate;
    self.mockTableView = [OCMockObject mockForClass:[UITableView class]];
    [[[(id)self.profileEditViewController stub] andReturn:self.mockTableView] view];
    [[[(id)self.profileEditViewController stub] andReturn:self.mockTableView] tableView];
    self.mockBundle = [OCMockObject mockForClass:[NSBundle class]];
    self.profileEditViewController.bundle = self.mockBundle;
    
    // OCMock can not match primitives =(
    for (int section = 0; section < SocializeProfileEditViewControllerNumSections; section++) {
        [[[self.mockTableView stub] andDo:^(NSInvocation *inv) {
            NSInteger rows = [self.profileEditViewController tableView:self.mockTableView numberOfRowsInSection:section];
            [inv setReturnValue:&rows];
        }] numberOfRowsInSection:section];
    }
}

- (void)tearDown {
    self.profileEditViewController = nil;
    self.origProfileEditViewController = nil;
    self.mockDelegate = nil;
    [self.mockDelegate verify];
    [self.mockTableView verify];
    [self.mockBundle verify];
}

- (void)testCancelCallsSelector {
    UIButton *cancelButton = (UIButton*)self.profileEditViewController.cancelButton.customView;
    NSArray *actions = [cancelButton actionsForTarget:self.origProfileEditViewController forControlEvent:UIControlEventTouchUpInside];
    SEL s = NSSelectorFromString([actions objectAtIndex:0]);
    GHAssertEquals(@selector(cancelButtonPressed:), s, @"Selector incorrect");
}

- (void)testCancellingCallsDelegate {
    [[self.mockDelegate expect] profileEditViewControllerDidCancel:self.origProfileEditViewController];
    [self.profileEditViewController cancelButtonPressed:nil];
}

- (void)testSaveCallsSelector {
    UIButton *saveButton = (UIButton*)self.profileEditViewController.saveButton.customView;
    NSArray *actions = [saveButton actionsForTarget:self.origProfileEditViewController forControlEvent:UIControlEventTouchUpInside];
    SEL s = NSSelectorFromString([actions objectAtIndex:0]);
    GHAssertEquals(@selector(saveButtonPressed:), s, @"Selector incorrect");
}

- (void)testSavingCallsDelegate {
    [[self.mockDelegate expect] profileEditViewControllerDidSave:self.origProfileEditViewController];
    [self.profileEditViewController saveButtonPressed:nil];
}

- (void)testImageCellProperties {
    id mockCell = [OCMockObject mockForClass:[SocializeProfileEditTableViewImageCell class]];
    [[[self.mockBundle expect] andDo:^(NSInvocation* inv) {
        self.profileEditViewController.profileImageCell = mockCell;
    }] loadNibNamed:@"SocializeProfileEditTableViewImageCell" owner:OCMOCK_ANY options:nil];
    
    id mockSpinner = [OCMockObject mockForClass:[UIActivityIndicatorView class]];
    id mockImageView = [OCMockObject mockForClass:[UIImageView class]];
    id mockLayer = [OCMockObject mockForClass:[CALayer class]];
    [[[mockCell stub] andReturn:mockSpinner] spinner];
    [[[mockCell stub] andReturn:mockImageView] imageView];
    [[[mockImageView stub] andReturn:mockLayer] layer];
    [[mockLayer expect] setCornerRadius:4];
    [[mockLayer expect] setMasksToBounds:YES];
//    [[mockImageView expect] setImage:nil];
    [[mockSpinner expect] setHidesWhenStopped:YES];
    [[mockSpinner expect] startAnimating];
    [[mockCell expect] setBackgroundColor:[UIColor colorWithRed:35/255.0f green:43/255.0f blue:50/255.0f alpha:1.0]];
    UITableViewCell *cell = [self.profileEditViewController tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    GHAssertEquals(cell, mockCell, @"Bad cell");
}

- (void)testCellConfigWithImage {
    // Previous tested verified nil image.
    id mockCell = [OCMockObject mockForClass:[SocializeProfileEditTableViewImageCell class]];
    id mockSpinner = [OCMockObject mockForClass:[UIActivityIndicatorView class]];
    id mockImageView = [OCMockObject mockForClass:[UIImageView class]];
    id mockImage = [OCMockObject mockForClass:[UIImage class]];
    [[[mockCell stub] andReturn:mockSpinner] spinner];
    [[[mockCell stub] andReturn:mockImageView] imageView];
    [[mockSpinner expect] stopAnimating];
    [[mockImageView expect] setImage:mockImage];
    self.profileEditViewController.profileImageCell = mockCell;
    self.profileEditViewController.profileImage = mockImage;

    [self.profileEditViewController configureProfileImageCell];
}

- (void)testTextCellProperties {
    self.profileEditViewController.firstName = @"Mister";
    id mockCell = [OCMockObject mockForClass:[SocializeProfileEditTableViewCell class]];
    [[[self.mockBundle expect] andDo:^(NSInvocation* inv) {
        self.profileEditViewController.profileTextCell = mockCell;
    }] loadNibNamed:@"SocializeProfileEditTableViewCell" owner:OCMOCK_ANY options:nil];
    
    [[[self.mockTableView expect] andReturn:nil] dequeueReusableCellWithIdentifier:OCMOCK_ANY];
    id mockKeyLabel = [OCMockObject mockForClass:[UILabel class]];
    id mockValueLabel = [OCMockObject mockForClass:[UILabel class]];
    id mockArrowImageView = [OCMockObject mockForClass:[UIImageView class]];
    [[[mockCell expect] andReturn:mockKeyLabel] keyLabel];
    [[[mockCell expect] andReturn:mockValueLabel] valueLabel];
    [[[mockCell expect] andReturn:mockArrowImageView] arrowImageView];
    [[mockKeyLabel expect] setText:@"first name"];
    [[mockValueLabel expect] setText:@"Mister"];
    [[mockArrowImageView expect] setHidden:NO];
    [[mockCell expect] setBackgroundColor:[UIColor colorWithRed:44/255.0f green:54/255.0f blue:63/255.0f alpha:1.0]];
    UITableViewCell *cell = [self.profileEditViewController tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:SocializeProfileEditViewControllerPropertiesRowFirstName inSection:SocializeProfileEditViewControllerSectionProperties]];
    GHAssertEquals(cell, mockCell, @"Bad cell");
}

- (void)testNumberOfSections {
    GHAssertEquals([self.profileEditViewController numberOfSectionsInTableView:nil], SocializeProfileEditViewControllerNumSections, @"Wrong section count");
}

- (void)testKeyPaths {
    NSString *path = [self.profileEditViewController keyPathForPropertiesRow:SocializeProfileEditViewControllerPropertiesRowFirstName];
    GHAssertEqualObjects(path, @"firstName", @"Bad path");
}

- (void)testFacebookSwitchTarget {
    UISwitch *sw = self.profileEditViewController.facebookSwitch;
    NSString *targetString = [[sw actionsForTarget:self.origProfileEditViewController forControlEvent:UIControlEventValueChanged] objectAtIndex:0];
    GHAssertEquals(NSSelectorFromString(targetString), @selector(facebookSwitchChanged:), @"Bad target");
}

- (void)testFacebookSwitchStartState {
    id mockDefaults = [OCMockObject mockForClass:[NSUserDefaults class]];
    [[[mockDefaults expect] andReturn:[NSNumber numberWithBool:NO]] objectForKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY];
    GHAssertTrue(self.profileEditViewController.facebookSwitch.on, @"Switch should be on");
}

- (void)testFacebookSwitchChanged {
    id mockFacebookSwitch = [OCMockObject mockForClass:[UISwitch class]];
    
    // Expect kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY checked from defaults (return NO)
    id mockDefaults = [OCMockObject mockForClass:[NSUserDefaults class]];
    self.profileEditViewController.userDefaults = mockDefaults;
    [[[(id)self.profileEditViewController stub] andReturn:mockFacebookSwitch] facebookSwitch];
    [[[mockDefaults expect] andReturn:[NSNumber numberWithBool:NO]] objectForKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY];
    
    // Expect toggle on state
    BOOL isOn = YES;
    [[[mockFacebookSwitch expect] andReturnValue:OCMOCK_VALUE(isOn)] isOn];
    [[mockFacebookSwitch expect] setOn:NO];
    [[mockDefaults expect] setObject:[NSNumber numberWithBool:YES] forKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY];

    // Expect save button enabled
    id mockNavigationItem = [OCMockObject mockForClass:[UINavigationItem class]];
    id mockSaveButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [[[mockNavigationItem expect] andReturn:mockSaveButton] rightBarButtonItem];
    [[[(id)self.profileEditViewController expect] andReturn:mockNavigationItem] navigationItem];
    [[mockSaveButton expect] setEnabled:YES];

    [self.profileEditViewController facebookSwitchChanged:mockFacebookSwitch];
}

- (void)testFacebookCellConfiguration {
    id mockCell = [OCMockObject mockForClass:[SocializeProfileEditTableViewCell class]];
    [[[self.mockBundle expect] andDo:^(NSInvocation* inv) {
        self.profileEditViewController.profileTextCell = mockCell;
    }] loadNibNamed:@"SocializeProfileEditTableViewCell" owner:OCMOCK_ANY options:nil];

    id mockKeyLabel = [OCMockObject mockForClass:[UILabel class]];
    id mockValueLabel = [OCMockObject mockForClass:[UILabel class]];
    id mockArrowImageView = [OCMockObject mockForClass:[UIImageView class]];
    [[[mockCell expect] andReturn:mockKeyLabel] keyLabel];
    [[[mockCell expect] andReturn:mockValueLabel] valueLabel];
    [[[mockCell expect] andReturn:mockArrowImageView] arrowImageView];
    [[mockKeyLabel expect] setText:@"Post to Facebook"];
    [[mockValueLabel expect] setText:nil];
    [[mockArrowImageView expect] setHidden:YES];

    [[mockCell expect] setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[mockCell expect] setAccessoryView:self.profileEditViewController.facebookSwitch];
    [[mockCell expect] setBackgroundColor:[UIColor colorWithRed:35/255.0f green:43/255.0f blue:50/255.0f alpha:1.0]];
    [[[self.mockTableView expect] andReturn:nil] dequeueReusableCellWithIdentifier:OCMOCK_ANY];

    [self.profileEditViewController tableView:self.mockTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:SocializeProfileEditViewControllerPermissionsRowFacebook inSection:SocializeProfileEditViewControllerSectionPermissions]];

}

- (void)testActionSheetNoCamera {
    BOOL haveCamera = NO;
    [[[(id)self.profileEditViewController stub] andReturnValue:OCMOCK_VALUE(haveCamera)] haveCamera];
    UIActionSheet *sheet = self.profileEditViewController.uploadPicActionSheet;
    GHAssertEquals([sheet numberOfButtons], 2, @"bad button count");
}

- (void)testActionSheetCamera {
    BOOL haveCamera = YES;
    [[[(id)self.profileEditViewController stub] andReturnValue:OCMOCK_VALUE(haveCamera)] haveCamera];
    UIActionSheet *sheet = self.profileEditViewController.uploadPicActionSheet;
    GHAssertEquals([sheet numberOfButtons], 3, @"bad button count");
}

- (void)testActionSheetShown {
    id mockSheet = [OCMockObject mockForClass:[UIActionSheet class]];
    self.profileEditViewController.uploadPicActionSheet = mockSheet;
    NSIndexPath *imagePath = [NSIndexPath indexPathForRow:SocializeProfileEditViewControllerImageRowProfileImage inSection:SocializeProfileEditViewControllerSectionImage];
    id mockWindow = [OCMockObject mockForClass:[UIWindow class]];
    [[[self.mockTableView expect] andReturn:mockWindow] window];
    [[mockSheet expect] showInView:mockWindow];
    [self.profileEditViewController tableView:self.mockTableView didSelectRowAtIndexPath:imagePath];
}

- (void)testImagePickerCreation {
    UIImagePickerController *picker = self.profileEditViewController.imagePicker;
    GHAssertEquals(picker.delegate, self.origProfileEditViewController, @"Bad delegate");
    GHAssertEquals(picker.allowsEditing, YES, @"Should allow editing");
}

- (void)testPickFromCamera {
    id mockPicker = [OCMockObject niceMockForClass:[UIImagePickerController class]];
    self.profileEditViewController.imagePicker = mockPicker;
    [[mockPicker expect] setSourceType:UIImagePickerControllerSourceTypeCamera];
    [[(id)self.profileEditViewController expect] presentModalViewController:mockPicker animated:YES];
    [self.profileEditViewController actionSheet:self.profileEditViewController.uploadPicActionSheet clickedButtonAtIndex:1];
}

- (void)testPickFromLibrary {
    id mockPicker = [OCMockObject niceMockForClass:[UIImagePickerController class]];
    self.profileEditViewController.imagePicker = mockPicker;
    [[mockPicker expect] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [[(id)self.profileEditViewController expect] presentModalViewController:mockPicker animated:YES];
    [self.profileEditViewController actionSheet:self.profileEditViewController.uploadPicActionSheet clickedButtonAtIndex:2];
}

- (void)testViewDidLoad {
    [[self.mockTableView expect] setAccessibilityLabel:@"edit profile"];
    [self.profileEditViewController viewDidLoad];
    GHAssertEquals(self.profileEditViewController.navigationItem.leftBarButtonItem, self.profileEditViewController.cancelButton, @"Bad left button");
    GHAssertEquals(self.profileEditViewController.navigationItem.rightBarButtonItem, self.profileEditViewController.saveButton, @"Bad right button");
    GHAssertFalse(self.profileEditViewController.saveButton.enabled, @"Should not be enabled");
}

- (void)testViewDidUnload {
    [[(id)self.profileEditViewController expect] setCancelButton:nil];
    [[(id)self.profileEditViewController expect] setSaveButton:nil];
    [self.profileEditViewController viewDidUnload];
}

- (void)testImageCellHeight {
    NSIndexPath *imagePath = [NSIndexPath indexPathForRow:SocializeProfileEditViewControllerImageRowProfileImage inSection:SocializeProfileEditViewControllerSectionImage];
    NSInteger imageHeight = [self.profileEditViewController tableView:self.mockTableView heightForRowAtIndexPath:imagePath];
    GHAssertEquals(imageHeight, SocializeProfileEditTableViewImageCellHeight, @"Bad height");
}

- (void)testNormalCellHeight {
    NSIndexPath *propertyPath = [NSIndexPath indexPathForRow:SocializeProfileEditViewControllerPropertiesRowFirstName inSection:SocializeProfileEditViewControllerSectionProperties];
    NSInteger propertyHeight = [self.profileEditViewController tableView:self.mockTableView heightForRowAtIndexPath:propertyPath];
    GHAssertEquals(propertyHeight, SocializeProfileEditTableViewCellHeight, @"Bad height");
}

- (void)testBundle {
    self.profileEditViewController.bundle = nil;
    GHAssertEqualObjects([NSBundle mainBundle], self.profileEditViewController.bundle, @"Bad default");
}

- (void)testUserDefaults {
    GHAssertEqualObjects([NSUserDefaults standardUserDefaults], self.profileEditViewController.userDefaults, @"Bad default");    
}

- (void)testPickMedia {
    
    // Picker should dismiss
    id mockPicker = [OCMockObject mockForClass:[UIImagePickerController class]];
    self.profileEditViewController.imagePicker = mockPicker;
    [[mockPicker expect] dismissModalViewControllerAnimated:YES];

    // Save should enable
    id mockNavigation = [OCMockObject mockForClass:[UINavigationItem class]];
    id mockSaveButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [[[mockNavigation expect] andReturn:mockSaveButton] rightBarButtonItem];
    [[[(id)self.profileEditViewController expect] andReturn:mockNavigation] navigationItem];
    [[mockSaveButton expect] setEnabled:YES];
    
    // Image should be set
    UIImage *mockImage = [OCMockObject mockForClass:[UIImage class]];
    NSDictionary *info = [NSDictionary dictionaryWithObject:mockImage forKey:UIImagePickerControllerEditedImage];
    [[(id)self.profileEditViewController expect] setProfileImage:mockImage];
    
    // Cell should reconfigure
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [[self.mockTableView expect] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

    [self.profileEditViewController imagePickerController:self.profileEditViewController.imagePicker didFinishPickingMediaWithInfo:info];    
}

- (void)testEditValue {
    SocializeProfileEditValueViewController *editValue = self.profileEditViewController.editValueController;
    GHAssertEquals(editValue.delegate, self.origProfileEditViewController, @"Bad delegate");
}

- (void)testEditValueSave {
    // Save button should enable
    id mockNavigationItem = [OCMockObject mockForClass:[UINavigationItem class]];
    id mockSaveButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [[[mockNavigationItem expect] andReturn:mockSaveButton] rightBarButtonItem];
    [[[(id)self.profileEditViewController expect] andReturn:mockNavigationItem] navigationItem];
    [[mockSaveButton expect] setEnabled:YES];

    // Modal should pop
    id mockNavigationController = [OCMockObject mockForClass:[UINavigationController class]];
    [[[(id)self.profileEditViewController expect] andReturn:mockNavigationController] navigationController];
    [[mockNavigationController expect] popViewControllerAnimated:YES];

    // firstName should be set
    NSIndexPath *firstNamePath = [NSIndexPath indexPathForRow:SocializeProfileEditViewControllerPropertiesRowFirstName inSection:SocializeProfileEditViewControllerSectionProperties];
    id mockEditValue = [OCMockObject mockForClass:[SocializeProfileEditValueViewController class]];
    [[[mockEditValue expect] andReturn:firstNamePath] indexPath];
    id mockValueField = [OCMockObject mockForClass:[UITextField class]];
    [[[mockEditValue expect] andReturn:mockValueField] editValueField];
    [[[mockValueField expect] andReturn:@"some value"] text];
    [[(id)self.profileEditViewController expect] setValue:@"some value" forKeyPath:@"firstName"];
    
    [[self.mockTableView expect] reloadRowsAtIndexPaths:[NSArray arrayWithObject:firstNamePath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.profileEditViewController profileEditValueViewControllerDidSave:mockEditValue];
}

- (void)testEditValueCancel {
    // Modal should pop
    id mockNavigationController = [OCMockObject mockForClass:[UINavigationController class]];
    [[[(id)self.profileEditViewController expect] andReturn:mockNavigationController] navigationController];
    [[mockNavigationController expect] popViewControllerAnimated:YES];
    
    [self.profileEditViewController profileEditValueViewControllerDidCancel:nil];
}

@end
