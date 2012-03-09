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
#import "UIImage+Resize.h"
#import "SocializeBaseViewControllerDelegate.h"
#import "UIAlertView+BlocksKit.h"
#import "SocializeFacebookAuthenticator.h"
#import "SocializeThirdPartyTwitter.h"
#import "SocializeThirdPartyFacebook.h"
#import "NSObject+ClassMock.h"
#import "SocializeTwitterAuthenticator.h"

@interface SocializeProfileEditViewController ()
- (void)cancelButtonPressed:(UIButton*)button;
- (void)saveButtonPressed:(UIButton*)button;
- (void)facebookSwitchChanged:(UISwitch*)facebookSwitch;
- (BOOL)haveCamera;
- (void)configureProfileImageCell;
- (void)configureViewsForUser;
- (void)twitterSwitchChanged:(UISwitch*)twitterSwitch;
@end

@implementation SocializeProfileEditViewControllerTest
@synthesize profileEditViewController = profileEditViewController_;
@synthesize mockDelegate = mockDelegate_;
@synthesize mockTableView = mockTableView_;
@synthesize mockBundle = mockBundle_;
@synthesize mockNavigationItem = mockNavigationItem_;
@synthesize mockFacebookSwitch = mockFacebookSwitch_;
@synthesize mockUserDefaults = mockUserDefaults_;
@synthesize mockActionSheet = mockActionSheet_;
@synthesize mockSaveButton = mockSaveButton_;
@synthesize mockTwitterSwitch = mocKTwitterSwitch_;
@synthesize isAuthenticatedWithTwitter = isAuthenticatedWithTwitter_;
@synthesize twitterAvailable = twitterAvailable_;
@synthesize isAuthenticatedWithFacebook = isAuthenticatedWithFacebook_;
@synthesize facebookAvailable = facebookAvailable_;

- (BOOL)shouldRunOnMainThread {
    return YES;
}

+ (SocializeBaseViewController*)createController {
    return [[[SocializeProfileEditViewController alloc] init] autorelease];
}

- (void)setUp {
    [super setUp];
    
    self.profileEditViewController = (SocializeProfileEditViewController*)self.viewController;
    self.mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeProfileEditViewControllerDelegate)];
    self.profileEditViewController.delegate = self.mockDelegate;
    self.mockTableView = [OCMockObject mockForClass:[UITableView class]];
    [[[(id)self.profileEditViewController stub] andReturn:self.mockTableView] view];
    [[[(id)self.profileEditViewController stub] andReturn:self.mockTableView] tableView];
    self.mockBundle = [OCMockObject mockForClass:[NSBundle class]];
    self.profileEditViewController.bundle = self.mockBundle;
    
    // OCMock can not match primitives =(
    // Iterate and forward all sections calls
    for (int section = 0; section < SocializeProfileEditViewControllerNumSections; section++) {
        [[[self.mockTableView stub] andDo:^(NSInvocation *inv) {
            NSInteger rows = [self.profileEditViewController tableView:self.mockTableView numberOfRowsInSection:section];
            [inv setReturnValue:&rows];
        }] numberOfRowsInSection:section];
    }
    
    self.mockFacebookSwitch = [OCMockObject mockForClass:[UISwitch class]];
    self.profileEditViewController.facebookSwitch = self.mockFacebookSwitch;
    
    self.mockTwitterSwitch = [OCMockObject mockForClass:[UISwitch class]];
    self.profileEditViewController.twitterSwitch = self.mockTwitterSwitch;

    self.mockUserDefaults = [OCMockObject mockForClass:[NSUserDefaults class]];
    self.profileEditViewController.userDefaults = self.mockUserDefaults;
    
    self.mockActionSheet = [OCMockObject mockForClass:[UIActionSheet class]];
    self.profileEditViewController.uploadPicActionSheet = self.mockActionSheet;
    
    self.mockSaveButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.profileEditViewController.saveButton = self.mockSaveButton;
    
    self.facebookAvailable = YES;
    self.twitterAvailable = YES;
    [self loadView];
    
    [SocializeThirdPartyTwitter startMockingClass];
    [SocializeThirdPartyFacebook startMockingClass];
    [SocializeFacebookAuthenticator startMockingClass];
    [SocializeTwitterAuthenticator startMockingClass];
    
    [[[SocializeThirdPartyTwitter stub] andReturnBoolFromBlock:^{ return self.isAuthenticatedWithTwitter; } ] isLinkedToSocialize];
    [[[SocializeThirdPartyTwitter stub] andReturnBoolFromBlock:^{ return self.twitterAvailable; } ] available];
    [[[SocializeThirdPartyFacebook stub] andReturnBoolFromBlock:^{ return self.isAuthenticatedWithFacebook; } ] isLinkedToSocialize];
    [[[SocializeThirdPartyFacebook stub] andReturnBoolFromBlock:^{ return self.facebookAvailable; } ] available];

}

- (void)tearDown {
    [super tearDown];
    
    [SocializeThirdPartyTwitter stopMockingClassAndVerify];
    [SocializeThirdPartyFacebook stopMockingClassAndVerify];
    [SocializeFacebookAuthenticator stopMockingClassAndVerify];
    [SocializeTwitterAuthenticator stopMockingClassAndVerify];

    [self.mockDelegate verify];
    [self.mockTableView verify];
    [self.mockBundle verify];
    [self.mockNavigationItem verify];
    [self.mockFacebookSwitch verify];
    [self.mockTwitterSwitch verify];
    [self.mockUserDefaults verify];
    [self.mockActionSheet verify];

    self.profileEditViewController = nil;
    self.mockDelegate = nil;
    self.mockNavigationItem = nil;
    self.mockFacebookSwitch = nil;
    self.mockTwitterSwitch = nil;
    self.mockUserDefaults = nil;
    self.mockActionSheet = nil;
    self.mockSocialize = nil;
}

- (void)loadView {
    [self.mockSaveButton makeNice];
    [self.mockNavigationItem makeNice];
    [self.mockTableView makeNice];
    
    [self.profileEditViewController viewDidLoad];
}

SYNTH_BUTTON_TEST(profileEditViewController, saveButton)

- (void)testSavingAfterEditUpdatesSocialize {
    self.profileEditViewController.editOccured = YES;
    
    // Expect user is copied, this mock returns a new mock when copied
    id mockOrigUser = [OCMockObject mockForClass:[SocializeFullUser class]];
    id mockCopyUser = [OCMockObject mockForClass:[SocializeFullUser class]];
    [mockCopyUser retain];
    [[[mockOrigUser expect] andReturn:mockCopyUser] copy];
    
    self.profileEditViewController.fullUser = mockOrigUser;
    
    // This image should be sent to the server
    id mockImage = [OCMockObject mockForClass:[UIImage class]];
    self.profileEditViewController.profileImage = mockImage;

    // Start loading
    [[(id)self.profileEditViewController expect] startLoading];

    // Save Button turns off
    [[self.mockSaveButton expect] setEnabled:NO];

    [[self.mockSocialize expect] updateUserProfile:mockCopyUser profileImage:mockImage];
    [self.profileEditViewController saveButtonPressed:nil];
}

- (void)testUpdatingTextCausesEdit {
    NSString *testValue = @"testValue";
    
    NSIndexPath *firstNameIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    id mockEditValueViewController = [OCMockObject mockForClass:[SocializeProfileEditValueViewController class]];
    self.profileEditViewController.editValueController = mockEditValueViewController;
    id mockTextField = [OCMockObject mockForClass:[UITextField class]];
    [[[mockTextField stub] andReturn:testValue] text];
    [[[mockEditValueViewController stub] andReturn:mockTextField] editValueField];
    [[[mockEditValueViewController stub] andReturn:firstNameIndexPath] indexPath];
    [[self.mockNavigationController expect] popViewControllerAnimated:YES];
    [[self.mockTableView expect] reloadRowsAtIndexPaths:[NSArray arrayWithObject:firstNameIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self expectChangeTitleOnCustomBarButton:self.mockSaveButton toText:@"Save"];

    GHAssertFalse(self.profileEditViewController.editOccured, @"Edit should not have occured yet");
    [self.profileEditViewController baseViewControllerDidFinish:mockEditValueViewController];
    GHAssertTrue(self.profileEditViewController.editOccured, @"Edit should have occured");
}

- (void)testSavingWithoutEditCallsDelegate {
    [[self.mockDelegate expect] profileEditViewController:(SocializeProfileEditViewController*)self.origViewController didUpdateProfileWithUser:OCMOCK_ANY];
    [self.profileEditViewController saveButtonPressed:nil];
}

/*
- (void)testFinishingSaveCalls {
    [[self.mockDelegate expect] profileEditViewController:self.profileEditViewController didUpdateProfileWithUser:mockCopyUser];
    [self.profileEditViewController saveButtonPressed:nil];
}
 */

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
    id mockUser = [OCMockObject mockForClass:[SocializeFullUser class]];
    [[[mockUser stub]  andReturn:@"Mister"] valueForKeyPath:@"firstName"];
    [[[mockUser stub] andReturn:@"Mister"] firstName];
    self.profileEditViewController.fullUser = mockUser;
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
    [[mockCell expect] setSelectionStyle:UITableViewCellSelectionStyleBlue];
    UITableViewCell *cell = [self.profileEditViewController tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:SocializeProfileEditViewControllerPropertiesRowFirstName inSection:SocializeProfileEditViewControllerSectionProperties]];
    GHAssertEquals(cell, mockCell, @"Bad cell");
}

- (void)testNumberOfSections {
    GHAssertEquals([self.profileEditViewController numberOfSectionsInTableView:nil], 4, @"Wrong section count");
}

- (void)testKeyPaths {
    NSString *path = [self.profileEditViewController keyPathForPropertiesRow:SocializeProfileEditViewControllerPropertiesRowFirstName];
    GHAssertEqualObjects(path, @"fullUser.firstName", @"Bad path");
}

- (void)testFacebookSwitchStartState {
    
    // Already authed with facebook
    self.isAuthenticatedWithFacebook = YES;
    
    // Reset to default
    self.profileEditViewController.facebookSwitch = nil;
    
    // Enforce defaults
    [[[self.mockUserDefaults expect] andReturn:[NSNumber numberWithBool:YES]] objectForKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY];

    UISwitch *sw = self.profileEditViewController.facebookSwitch;
    
    // Check target
    NSString *targetString = [[sw actionsForTarget:self.origViewController forControlEvent:UIControlEventValueChanged] objectAtIndex:0];
    GHAssertEquals(NSSelectorFromString(targetString), @selector(facebookSwitchChanged:), @"Bad target");
    
    // Check on
    GHAssertTrue(!sw.on, @"Switch should be off");
}

// Switch is inverted -- called "Post to facebook", the user default is kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY
- (void)testFacebookSwitchChangedOnToOff {
    // Return off (new state)
    [[[self.mockFacebookSwitch stub] andReturnBool:NO] isOn];
    
    // Expect defaults updated
    // Expect defaults go to not posting (ie, switch off)
    [[self.mockUserDefaults expect] setObject:[NSNumber numberWithBool:YES] forKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY];
    [[self.mockUserDefaults expect] synchronize];
    
    
    [self.profileEditViewController facebookSwitchChanged:self.mockFacebookSwitch];
}

- (void)testFacebookCellConfiguration {
    id mockCell = [OCMockObject niceMockForClass:[SocializeProfileEditTableViewCell class]];
//    [[[self.mockBundle expect] andDo:^(NSInvocation* inv) {
//        self.profileEditViewController.profileTextCell = mockCell;
//    }] loadNibNamed:@"SocializeProfileEditTableViewCell" owner:OCMOCK_ANY options:nil];

    id mockKeyLabel = [OCMockObject niceMockForClass:[UILabel class]];
    id mockValueLabel = [OCMockObject niceMockForClass:[UILabel class]];
    id mockArrowImageView = [OCMockObject niceMockForClass:[UIImageView class]];
    [[[mockCell expect] andReturn:mockKeyLabel] keyLabel];
    [[[mockCell expect] andReturn:mockValueLabel] valueLabel];
    [[[mockCell expect] andReturn:mockArrowImageView] arrowImageView];

    [[mockCell expect] setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[mockCell expect] setAccessoryView:self.mockFacebookSwitch];
    [[[self.mockTableView expect] andReturn:mockCell] dequeueReusableCellWithIdentifier:OCMOCK_ANY];

    [self.profileEditViewController tableView:self.mockTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:SocializeProfileEditViewControllerFacebookRowPost inSection:SocializeProfileEditViewControllerSectionFacebook]];

}


- (void)testTwitterCellConfiguration {
    id mockCell = [OCMockObject niceMockForClass:[SocializeProfileEditTableViewCell class]];

    id mockKeyLabel = [OCMockObject niceMockForClass:[UILabel class]];
    id mockValueLabel = [OCMockObject niceMockForClass:[UILabel class]];
    id mockArrowImageView = [OCMockObject niceMockForClass:[UIImageView class]];
    [[[mockCell expect] andReturn:mockKeyLabel] keyLabel];
    [[[mockCell expect] andReturn:mockValueLabel] valueLabel];
    [[[mockCell expect] andReturn:mockArrowImageView] arrowImageView];
    
    [[mockCell expect] setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[mockCell expect] setAccessoryView:self.mockTwitterSwitch];
    [[[self.mockTableView expect] andReturn:mockCell] dequeueReusableCellWithIdentifier:OCMOCK_ANY];
    
    [self.profileEditViewController tableView:self.mockTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:SocializeProfileEditViewControllerTwitterRowPost inSection:SocializeProfileEditViewControllerSectionTwitter]];
    
}

- (void)testActionSheetNoCamera {
    BOOL haveCamera = NO;
    [[[(id)self.profileEditViewController stub] andReturnValue:OCMOCK_VALUE(haveCamera)] haveCamera];
    
    // reset to obtain default
    self.profileEditViewController.uploadPicActionSheet = nil;
    UIActionSheet *sheet = self.profileEditViewController.uploadPicActionSheet;
    GHAssertEquals([sheet numberOfButtons], 2, @"bad button count");
}

- (void)testActionSheetCamera {
    BOOL haveCamera = YES;
    [[[(id)self.profileEditViewController stub] andReturnValue:OCMOCK_VALUE(haveCamera)] haveCamera];
    
    // reset to obtain default
    self.profileEditViewController.uploadPicActionSheet = nil;
    UIActionSheet *sheet = self.profileEditViewController.uploadPicActionSheet;
    GHAssertEquals([sheet numberOfButtons], 3, @"bad button count");
}

- (void)testActionSheetShown {
    NSIndexPath *imagePath = [NSIndexPath indexPathForRow:SocializeProfileEditViewControllerImageRowProfileImage inSection:SocializeProfileEditViewControllerSectionImage];
    [[self.mockActionSheet expect] showInView:self.mockWindow];
    [self.profileEditViewController tableView:self.mockTableView didSelectRowAtIndexPath:imagePath];
}

- (void)testImagePickerCreation {
    UIImagePickerController *picker = self.profileEditViewController.imagePicker;
    GHAssertEquals(picker.delegate, self.origViewController, @"Bad delegate");
    GHAssertEquals(picker.allowsEditing, YES, @"Should allow editing");
}

- (void)testPickFromCamera {
    // nice mock because it is presented modally
    id mockPicker = [OCMockObject niceMockForClass:[UIImagePickerController class]];
    self.profileEditViewController.imagePicker = mockPicker;
    NSInteger cancelIndex = 2;
    [[[self.mockActionSheet stub] andReturnValue:OCMOCK_VALUE(cancelIndex)] cancelButtonIndex];
    [[mockPicker expect] setSourceType:UIImagePickerControllerSourceTypeCamera];
    [[(id)self.profileEditViewController expect] presentModalViewController:mockPicker animated:YES];
    [self.profileEditViewController actionSheet:self.mockActionSheet clickedButtonAtIndex:1];
    [mockPicker verify];
}

- (void)testPickFromLibrary {
    // nice mock because it is presented modally
    id mockPicker = [OCMockObject niceMockForClass:[UIImagePickerController class]];
    self.profileEditViewController.imagePicker = mockPicker;
    NSInteger cancelIndex = 2;
    [[[self.mockActionSheet stub] andReturnValue:OCMOCK_VALUE(cancelIndex)] cancelButtonIndex];
    [[mockPicker expect] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [[(id)self.profileEditViewController expect] presentModalViewController:mockPicker animated:YES];

    [self.profileEditViewController actionSheet:self.profileEditViewController.uploadPicActionSheet clickedButtonAtIndex:0];
    [mockPicker verify];
}

- (void)expectViewDidLoad {
    [[self.mockTableView expect] setAccessibilityLabel:OCMOCK_ANY];
    [[self.mockNavigationItem expect] setLeftBarButtonItem:self.mockCancelButton];
    [[self.mockNavigationItem expect] setRightBarButtonItem:self.mockSaveButton];
    [self expectChangeTitleOnCustomBarButton:self.mockSaveButton toText:@"Done"];
}

- (void)performViewDidLoad {
    [self expectViewDidLoad];
    [self.profileEditViewController viewDidLoad];    
}

- (void)testViewDidLoad {
    [self performViewDidLoad];
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
    self.profileEditViewController.userDefaults = nil;
    GHAssertEqualObjects([NSUserDefaults standardUserDefaults], self.profileEditViewController.userDefaults, @"Bad default");    
}

- (void)testPickMedia {
    
    // Picker should dismiss
    id mockPicker = [OCMockObject mockForClass:[UIImagePickerController class]];
    self.profileEditViewController.imagePicker = mockPicker;
    [[mockPicker expect] dismissModalViewControllerAnimated:YES];

    // Image should be set
    id mockImage = [OCMockObject mockForClass:[UIImage class]];
    id mockResizedImage = [OCMockObject mockForClass:[UIImage class]];
    [[[mockImage expect] andReturn:mockResizedImage] imageWithSameAspectRatioAndWidth:300.f];
    
    NSDictionary *info = [NSDictionary dictionaryWithObject:mockImage forKey:UIImagePickerControllerEditedImage];
    [[(id)self.profileEditViewController expect] setProfileImage:mockResizedImage];
    
    // Cell should reconfigure
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [[self.mockTableView expect] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

    [self expectChangeTitleOnCustomBarButton:self.mockSaveButton toText:@"Save"];

    GHAssertFalse(self.profileEditViewController.editOccured, @"Edit should not have occured yet");
    [self.profileEditViewController imagePickerController:self.profileEditViewController.imagePicker didFinishPickingMediaWithInfo:info];    
    GHAssertTrue(self.profileEditViewController.editOccured, @"Edit should have occured");
}

- (void)testEditValue {
    SocializeProfileEditValueViewController *editValue = self.profileEditViewController.editValueController;
    GHAssertEquals(editValue.delegate, self.origViewController, @"Bad delegate");
}

- (void)testEditValueSave {
    // Modal should pop
    [[self.mockNavigationController expect] popViewControllerAnimated:YES];

    id mockUser = [OCMockObject mockForProtocol:@protocol(SocializeFullUser)];
    self.profileEditViewController.fullUser = mockUser;
    
    // firstName should be set
    NSIndexPath *firstNamePath = [NSIndexPath indexPathForRow:SocializeProfileEditViewControllerPropertiesRowFirstName inSection:SocializeProfileEditViewControllerSectionProperties];
    id mockEditValue = [OCMockObject mockForClass:[SocializeProfileEditValueViewController class]];
    self.profileEditViewController.editValueController = mockEditValue;
    [[[mockEditValue expect] andReturn:firstNamePath] indexPath];
    id mockValueField = [OCMockObject mockForClass:[UITextField class]];
    [[[mockEditValue expect] andReturn:mockValueField] editValueField];
    [[[mockValueField expect] andReturn:@"some value"] text];
//    [[mockUser expect] setFirstName:@"firstnamevalue"];
    [[(id)self.profileEditViewController expect] setValue:@"some value" forKeyPath:@"fullUser.firstName"];
    
    [[self.mockTableView expect] reloadRowsAtIndexPaths:[NSArray arrayWithObject:firstNamePath] withRowAnimation:UITableViewRowAnimationNone];
    [self expectChangeTitleOnCustomBarButton:self.mockSaveButton toText:@"Save"];
    
    [self.profileEditViewController baseViewControllerDidFinish:mockEditValue];
    
    GHAssertTrue(self.profileEditViewController.editOccured, @"Edit should have occured");
}

- (void)testEditValueCancel {
    // Modal should pop
    [[self.mockNavigationController expect] popViewControllerAnimated:YES];
    id mockEditValue = [OCMockObject mockForClass:[SocializeProfileEditValueViewController class]];
    self.profileEditViewController.editValueController = mockEditValue;

    [[[(id)self.profileEditViewController expect] andForwardToRealObject] baseViewControllerDidCancel:mockEditValue];
    [self.origViewController baseViewControllerDidCancel:mockEditValue];
}
 

/*
- (void)testSaveProfile {
    
    // 
    id mockImage = [OCMockObject mockForClass:[UIImage class]];
    [[[self.mockProfileEditViewController expect] andReturn:@"joe"] firstName];
    [[[self.mockProfileEditViewController expect] andReturn:@"toe"] lastName];
    [[[self.mockProfileEditViewController expect] andReturn:@"big toed joe"] bio];
    [[[self.mockProfileEditViewController expect] andReturn:mockImage] profileImage];
    
    // The existing user should be copied, and updates applied
    id mockOrigUser = [OCMockObject mockForClass:[SocializeFullUser class]];
    id mockCopyUser = [OCMockObject mockForClass:[SocializeFullUser class]];
    [[[mockOrigUser expect] andReturn:mockCopyUser] copy];
    [[mockCopyUser expect] setFirstName:@"joe"];
    [[mockCopyUser expect] setLastName:@"toe"];
    [[mockCopyUser expect] setDescription:@"big toed joe"];
    self.profileViewController.fullUser = mockOrigUser;
    
    [[self.mockSocialize expect] updateUserProfile:mockCopyUser profileImage:mockImage];
    
    // FIXME subconfiguration is hard to test and unnecessary... code should be part of the edit controller, not this one
    
    // Handle configuration of profile edit subcontroller (UINavigationController loading view)
    id mockNavigation = [OCMockObject mockForClass:[UINavigationController class]];
    id mockView = [OCMockObject niceMockForClass:[UIView class]];
    [[[mockNavigation expect] andReturn:mockView] view];
    [[[self.mockProfileEditViewController stub] andReturn:mockNavigation] navigationController];
    
    // Handle configuration of profile edit subcontroller (UINavigationItem Right button enabled)
    id mockButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    id mockSubNavigationItem = [OCMockObject mockForClass:[UINavigationItem class]];
    [[[mockSubNavigationItem stub] andReturn:mockButton] rightBarButtonItem];
    [[mockButton expect] setEnabled:NO];
    [[[self.mockProfileEditViewController stub] andReturn:mockSubNavigationItem] navigationItem];
    
    [self.profileViewController profileEditViewController:self.mockProfileEditViewController didUpdateProfileWithUser:<#(id<SocializeFullUser>)#>
     
     [mockButton verify];
     [mockSubNavigationItem verify];
     [mockNavigation verify];
}
 */

- (void)expectServiceFailure {
    [[self.mockSaveButton expect] setEnabled:YES];
    [super expectServiceFailure];
}

- (void)testServiceFailureTurnsOffFacebookButton {
    
    // Facebook must be available for the interface to be shown
    self.twitterAvailable = NO;
    self.facebookAvailable = YES;

    // Don't care about this mock
    [self.mockTwitterSwitch makeNice];
    
    // Make sure any initial state is set
    [self performViewDidLoad];
    
    // Facebook inactive
    self.isAuthenticatedWithFacebook = NO;
    
    // Switch is on (but shouldn't be anymore)
    [[[self.mockFacebookSwitch stub] andReturnBool:YES] isOn];
    
    // Should turn off
    [[self.mockFacebookSwitch expect] setOn:NO animated:YES];
    
    // Expect common failure
    [self expectServiceFailure];
    
    [self.profileEditViewController service:nil didFail:nil];
}

- (void)testUserUpdateSentToServer {
    id mockFullUser = [OCMockObject mockForProtocol:@protocol(SocializeFullUser)];
    
    [[(id)self.profileEditViewController expect] stopLoading];
    [[self.mockDelegate expect] profileEditViewController:(SocializeProfileEditViewController*)self.origViewController didUpdateProfileWithUser:mockFullUser];
    
    [self.profileEditViewController service:nil didUpdate:mockFullUser];
}

- (void)testViewWillAppearWithUserEnablesSaveButton {
    id mockFullUser = [OCMockObject mockForProtocol:@protocol(SocializeFullUser)];
    self.profileEditViewController.fullUser = mockFullUser;
    
    [[self.mockSaveButton expect] setEnabled:YES];
    [[(id)self.profileEditViewController expect] configureViewsForUser];
    [super expectViewWillAppear];
    [self.profileEditViewController viewWillAppear:YES];
}

- (void)testFinishingGetUserEnablesSaveButton {
    [[(id)self.profileEditViewController expect] configureViewsForUser];
    [[self.mockSaveButton expect] setEnabled:YES];
    [self.profileEditViewController didGetCurrentUser:nil];
}

- (void)ignoreLoadingInterface {
    [[(id)self stub] stopLoading];
}

- (void)succeedFacebookAuth {
    self.isAuthenticatedWithFacebook = YES;
    [self.profileEditViewController didAuthenticate:nil];
}

- (void)testFinishingFacebookAuthAddsFacebookLogoutRow {
    // don't care
    [self.mockTwitterSwitch makeNice];

    // Already authed with fb
    self.isAuthenticatedWithFacebook = NO;
    self.isAuthenticatedWithTwitter = NO;
    [self loadView];
    
    [[self.mockTableView expect] beginUpdates];
    [[self.mockTableView expect] insertRowsAtIndexPaths:OCMOCK_ANY withRowAnimation:UITableViewRowAnimationTop];
    [[self.mockTableView expect] endUpdates];
    
    [self succeedFacebookAuth];
}

- (void)testFinishingTwitterAuthAddsTwitterLogoutRow {
    // don't care
    [self.mockFacebookSwitch makeNice];
    
    // allow other messages
    [self.mockTableView makeNice];
    
    self.isAuthenticatedWithTwitter = YES;
    
    NSIndexPath *expectedPath = [NSIndexPath indexPathForRow:1 inSection:3];
    
    [[self.mockTableView expect] beginUpdates];
    [[self.mockTableView expect] insertRowsAtIndexPaths:[NSArray arrayWithObject:expectedPath] withRowAnimation:UITableViewRowAnimationTop];
    [[self.mockTableView expect] endUpdates];
    
    [self.profileEditViewController didAuthenticate:nil];
}

- (void)testFinishingFacebookAuthDoesNotTryToUpdateTwitterControlsWhenHidden {
    // facebook but not twitter (twitter section hidden)
    self.isAuthenticatedWithFacebook = NO;
    self.isAuthenticatedWithTwitter = NO;
    self.facebookAvailable = YES;
    self.twitterAvailable = NO;
    [self loadView];
    
    // Should just update facebook
    NSIndexPath *expectedPath = [NSIndexPath indexPathForRow:1 inSection:2];
    [[self.mockTableView expect] beginUpdates];
    [[self.mockTableView expect] insertRowsAtIndexPaths:[NSArray arrayWithObject:expectedPath] withRowAnimation:UITableViewRowAnimationTop];
    [[self.mockTableView expect] endUpdates];
    
    [self succeedFacebookAuth];
}

- (void)testSettingTwitterSwitchOffUpdatesDefaults {

    // Should no longer post to twitter
    [[self.mockUserDefaults expect] setObject:[NSNumber numberWithBool:YES] forKey:kSOCIALIZE_DONT_POST_TO_TWITTER_KEY];
    [[self.mockUserDefaults expect] synchronize];

    [[[self.mockTwitterSwitch stub] andReturnBool:NO] isOn];
    
    [self.profileEditViewController twitterSwitchChanged:self.mockTwitterSwitch];
}

- (void)testSettingTwitterSwitchOnAttemptsTwitterLogin {
    [self.mockUserDefaults makeNice];
    
    // Not authed
    self.isAuthenticatedWithTwitter = NO;
    
    // Simulating "was just set to on"
    [[[self.mockTwitterSwitch stub] andReturnBool:YES] isOn];
    
    // Should auth
    [[SocializeTwitterAuthenticator expect] authenticateViaTwitterWithOptions:OCMOCK_ANY
                                                                           display:OCMOCK_ANY
                                                                           success:OCMOCK_ANY
                                                                           failure:OCMOCK_ANY];
    
    [self.profileEditViewController twitterSwitchChanged:self.mockTwitterSwitch];
}

- (void)testSettingFacebookSwitchOnAttemptsFacebookLogin {
    [self.mockUserDefaults makeNice];
    
    self.isAuthenticatedWithFacebook = NO;
    
    [[[self.mockFacebookSwitch stub] andReturnBool:YES] isOn];
    
    [[SocializeFacebookAuthenticator expect] authenticateViaFacebookWithOptions:OCMOCK_ANY
                                                                             display:OCMOCK_ANY
                                                                             success:OCMOCK_ANY
                                                                             failure:OCMOCK_ANY];

    [self.profileEditViewController facebookSwitchChanged:self.mockFacebookSwitch];


}

- (void)testSelectingTwitterLogoutPromptsForLogout {
    self.isAuthenticatedWithTwitter = YES;
    
    [self.mockTableView makeNice];
    
    NSIndexPath *logoutPath = [NSIndexPath indexPathForRow:SocializeProfileEditViewControllerTwitterRowLogout inSection:SocializeProfileEditViewControllerSectionTwitter];
    [self.profileEditViewController tableView:self.mockTableView didSelectRowAtIndexPath:logoutPath];
    
    GHAssertNotNil(self.lastShownAlert, @"Should have alert");
    
    [[SocializeThirdPartyTwitter expect] removeLocalCredentials];

    BKBlock handler = [self.lastShownAlert handlerForButtonAtIndex:1];
    handler();
}

- (void)testSelectingFacebookLogoutPromptsForLogout {
    self.isAuthenticatedWithFacebook = YES;
    
    [self.mockTableView makeNice];
    
    NSIndexPath *logoutPath = [NSIndexPath indexPathForRow:SocializeProfileEditViewControllerFacebookRowLogout inSection:SocializeProfileEditViewControllerSectionFacebook];
    [self.profileEditViewController tableView:self.mockTableView didSelectRowAtIndexPath:logoutPath];
    
    GHAssertNotNil(self.lastShownAlert, @"Should have alert");
    
    [[SocializeThirdPartyFacebook expect] removeLocalCredentials];
    BKBlock handler = [self.lastShownAlert handlerForButtonAtIndex:1];
    handler();
}


@end
