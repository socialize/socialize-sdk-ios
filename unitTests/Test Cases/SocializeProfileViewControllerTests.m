//
//  SocializeProfileViewControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/5/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeProfileViewControllerTests.h"
#import "Socialize.h"
#import "SocializeFullUser.h"
#import <OCMock/OCMock.h>
#import "SocializeProfileEditTableViewCell.h"
#import "ImagesCache.h"

@interface SocializeProfileViewController ()
- (void)editButtonPressed:(UIBarButtonItem*)button;
- (void)showEditController;
- (UIImage*)defaultProfileImage;
- (void)configureViews;
- (void)configureEditButton;
- (void)hideEditController;
@end

@interface SocializeProfileViewControllerForTest : SocializeProfileViewController
@end

@implementation SocializeProfileViewControllerForTest
- (void)startLoading {}
- (id)view { return nil; }
@end

@implementation SocializeProfileViewControllerTests
@synthesize profileViewController = profileViewController_;
@synthesize origProfileViewController = origProfileViewController_;
@synthesize mockDelegate = mockDelegate_;
@synthesize mockSocialize = mockSocialize_;
@synthesize mockProfileEditViewController = mockProfileEditViewController_;
@synthesize mockNavigationController = mockNavigationController_;
@synthesize mockNavigationItem = mockNavigationItem_;
@synthesize mockNavigationBar = mockNavigationBar_;
@synthesize mockImagesCache = mockImagesCache_;
@synthesize mockProfileImageView = mockProfileImageView_;
@synthesize mockDefaultProfileImage = mockDefaultProfileImage_;
@synthesize mockProfileImageActivityIndicator = mockProfileImageActivityIndicator_;
@synthesize mockUserNameLabel = mockUserNameLabel_;
@synthesize mockUserDescriptionLabel = mockUserDescriptionLabel_;

-(void) setUp
{
    [super setUp];
    
    self.origProfileViewController = [[[SocializeProfileViewControllerForTest alloc] init] autorelease];
    self.profileViewController = [OCMockObject partialMockForObject:self.origProfileViewController];
    
    self.mockProfileEditViewController = [OCMockObject mockForClass:[SocializeProfileEditViewController class]];
    self.profileViewController.profileEditViewController = self.mockProfileEditViewController;
    
    self.mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeProfileViewControllerDelegate)];
    self.profileViewController.delegate = self.mockDelegate;
    
    self.mockNavigationController = [OCMockObject mockForClass:[UINavigationController class]];
    [[[(id)self.profileViewController stub] andReturn:self.mockNavigationController] navigationController];

    self.mockNavigationBar = [OCMockObject mockForClass:[UINavigationBar class]];
    [[[self.mockNavigationController stub] andReturn:self.mockNavigationBar] navigationBar];
    
    self.mockNavigationItem = [OCMockObject mockForClass:[UINavigationItem class]];
    [[[(id)self.profileViewController stub] andReturn:self.mockNavigationItem] navigationItem];

    self.mockProfileImageView = [OCMockObject mockForClass:[UIImageView class]];
    [[[(id)self.profileViewController stub] andReturn:self.mockProfileImageView] profileImageView];
    
    self.mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    [[[self.mockSocialize stub] andReturn:self.profileViewController] delegate];
    self.profileViewController.socialize = self.mockSocialize;
    
    self.mockImagesCache = [OCMockObject mockForClass:[ImagesCache class]];
    self.profileViewController.imagesCache = self.mockImagesCache;
    
    self.mockDefaultProfileImage = [OCMockObject mockForClass:[UIImage class]];
    self.profileViewController.defaultProfileImage = self.mockDefaultProfileImage;
    
    self.mockProfileImageActivityIndicator = [OCMockObject mockForClass:[UIActivityIndicatorView class]];
    self.profileViewController.profileImageActivityIndicator = self.mockProfileImageActivityIndicator;
    
    self.mockUserNameLabel = [OCMockObject mockForClass:[UILabel class]];
    self.profileViewController.userNameLabel = self.mockUserNameLabel;
    
    self.mockUserDescriptionLabel = [OCMockObject mockForClass:[UILabel class]];
    self.profileViewController.userDescriptionLabel = self.mockUserDescriptionLabel;
}

-(void) tearDown
{
    [super tearDown];
    
    [(id)self.profileViewController verify];
    [self.mockProfileEditViewController verify];
    [self.mockDelegate verify];
    [self.mockNavigationController verify];
    [self.mockNavigationBar verify];
    [self.mockNavigationItem verify];
    [self.mockProfileImageView verify];
    [self.mockSocialize verify];
    [self.mockImagesCache verify];
    [self.mockDefaultProfileImage verify];
    [self.mockProfileImageActivityIndicator verify];
    [self.mockUserNameLabel verify];
    [self.mockUserDescriptionLabel verify];
    
    self.origProfileViewController = nil;
    self.profileViewController = nil;
    self.mockDelegate = nil;
    self.mockNavigationController = nil;
    self.mockNavigationBar = nil;
    self.mockNavigationItem = nil;
    self.mockProfileImageView = nil;
    self.mockSocialize = nil;
    self.mockImagesCache = nil;
    self.mockDefaultProfileImage = nil;
    self.mockProfileImageActivityIndicator = nil;
    self.mockUserNameLabel = nil;
    self.mockUserDescriptionLabel = nil;
}

- (void)basicViewDidLoad {
    [[self.mockNavigationBar expect] setBackgroundImage:[UIImage imageNamed:@"socialize-navbar-bg.png"]];
    [[self.mockNavigationItem expect] setLeftBarButtonItem:self.profileViewController.doneButton];
    [[self.mockProfileImageView expect] setImage:self.profileViewController.defaultProfileImage];    
}

- (void)testViewDidLoadWithNoUser {
    [self basicViewDidLoad];
    [[(id)self.profileViewController expect] startLoading];
    [[self.mockSocialize expect] getCurrentUser];
    [self.profileViewController viewDidLoad];
}

- (void)testViewDidLoadWithPartialUser {
    [self basicViewDidLoad];

    // Set up a mock partial user
    NSInteger userID = 123;
    id mockUser = [OCMockObject mockForProtocol:@protocol(SocializeUser)];
    [[[mockUser expect] andReturnValue:OCMOCK_VALUE(userID)] objectID];
    self.profileViewController.user = mockUser;
    
    [[(id)self.profileViewController expect] startLoading];
    [[self.mockSocialize expect] getUserWithId:userID];
    [self.profileViewController viewDidLoad];
}

- (void)testViewDidLoadWithFullUser {
    [self basicViewDidLoad];
    
    // Set up a mock full
    id mockFullUser = [OCMockObject mockForProtocol:@protocol(SocializeFullUser)];
    self.profileViewController.fullUser = mockFullUser;
    
    [[(id)self.profileViewController expect] configureViews];
    [self.profileViewController viewDidLoad];
}

- (void)testViewDidUnload {
    [[(id)self.profileViewController expect] setDoneButton:nil];
    [[(id)self.profileViewController expect] setEditButton:nil];
    [[(id)self.profileViewController expect] setUserNameLabel:nil];
    [[(id)self.profileViewController expect] setUserDescriptionLabel:nil];
    [[(id)self.profileViewController expect] setUserLocationLabel:nil];
    [[(id)self.profileViewController expect] setProfileImageView:nil];
    [[(id)self.profileViewController expect] setProfileEditViewController:nil];
    [[(id)self.profileViewController expect] setDefaultProfileImage:nil];
    [self.profileViewController viewDidUnload];
}

- (void)testDefaultProfileImage {
    self.profileViewController.defaultProfileImage = nil;
    UIImage *defaultProfile = self.profileViewController.defaultProfileImage;
    GHAssertEqualObjects(defaultProfile, [UIImage imageNamed:@"socialize-profileimage-large-default.png"], @"bad profile");
}

- (void)testEditButtonShowsEdit {
    [[(id)self.profileViewController expect] showEditController];
    [self.profileViewController editButtonPressed:nil];
}

- (void)testDoneWithDelegateCallsDelegate {
    [[self.mockDelegate expect] profileViewControllerDidCancel:self.origProfileViewController];
    [self.profileViewController doneButtonPressed:nil];
}

- (void)testDoneWithoutDelegateDismissesSelf {
    [[(id)self.profileViewController expect] dismissModalViewControllerAnimated:YES];
    self.profileViewController.delegate = nil;
    [self.profileViewController doneButtonPressed:nil];
}

- (void)testSetProfileImageWithNilImage {
    [[self.mockProfileImageView expect] setImage:self.mockDefaultProfileImage];
    [self.profileViewController setProfileImageFromImage:nil];
}

- (void)testSetProfileImageWithImage {
    id mockImage = [OCMockObject mockForClass:[UIImage class]];
    [[self.mockProfileImageView expect] setImage:mockImage];
    [self.profileViewController setProfileImageFromImage:mockImage];
}

- (void)testDefaultImagesCache {
    self.profileViewController.imagesCache = nil;
    ImagesCache *cache = self.profileViewController.imagesCache;
    GHAssertEquals(cache, [ImagesCache sharedImagesCache], @"bad cache");
}

- (void)testSetProfileImageFromNilURL {
    [[self.mockProfileImageView expect] setImage:self.mockDefaultProfileImage];
    [self.profileViewController setProfileImageFromURL:nil];
}

- (void)testSetProfileImageFromURLAlreadyCached {
    id mockImage = [OCMockObject mockForClass:[UIImage class]];
    NSString *testURL = @"testurl";
    [[[self.mockImagesCache expect] andReturn:mockImage] imageFromCache:testURL];
    [[(id)self.profileViewController expect] setProfileImageFromImage:OCMOCK_ANY];
    [self.profileViewController setProfileImageFromURL:testURL];
}

- (void)testSetProfileImageFromURLNotAlreadyCached {
    // The image that will eventually be loaded
    id mockImage = [OCMockObject mockForClass:[UIImage class]];
    
    // Test url
    NSString *testURL = @"testurl";
    
    // First, return nil
    [[[self.mockImagesCache expect] andReturn:nil] imageFromCache:testURL];
    
    // Mock out server, call completion
    [[[self.mockImagesCache expect] andDo:^(NSInvocation *inv) {
        void (^blockAction)(ImagesCache *cache);
        [inv getArgument:&blockAction atIndex:3];
        [[[self.mockImagesCache expect] andReturn:mockImage] imageFromCache:testURL];
        blockAction(self.mockImagesCache);
        
    }] loadImageFromUrl:testURL completeAction:OCMOCK_ANY];
    
    // Should start and stop animation
    [[self.mockProfileImageActivityIndicator expect] startAnimating];
    [[self.mockProfileImageActivityIndicator expect] stopAnimating];
    
    // Finally, the image should be set
    [[(id)self.profileViewController expect] setProfileImageFromImage:mockImage];

    [self.profileViewController setProfileImageFromURL:testURL];
}

- (void)testConfigureViews {
    id mockFullUser = [OCMockObject mockForProtocol:@protocol(SocializeFullUser)];
    NSString *userName = @"userName";
    NSString *firstName = @"firstName";
    NSString *lastName = @"lastName";
    NSString *smallImageUrl = @"smallImageURL";
    [[[mockFullUser stub] andReturn:userName] userName];
    [[[mockFullUser stub] andReturn:firstName] firstName];
    [[[mockFullUser stub] andReturn:lastName] lastName];
    [[[mockFullUser stub] andReturn:smallImageUrl] smallImageUrl];
    self.profileViewController.fullUser = mockFullUser;
    
    // Labels should be configured
    [[self.mockUserDescriptionLabel expect] setText:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
    [[self.mockUserNameLabel expect] setText:userName];
    
    // Image should be loaded
    [[(id)self.profileViewController expect] setProfileImageFromURL:smallImageUrl];
    
    // Edit button config
    [[(id)self.profileViewController expect] configureEditButton];
    
    [self.profileViewController configureViews];
}

- (void)testConfigureEditButtonForAuthenticatedUser {
    id mockFullUser = [OCMockObject mockForProtocol:@protocol(SocializeFullUser)];
    NSInteger objectID = 1234;
    [[[mockFullUser stub] andReturnValue:OCMOCK_VALUE(objectID)] objectID];
    self.profileViewController.fullUser = mockFullUser;
    
    id mockUser = [OCMockObject mockForProtocol:@protocol(SocializeUser)];
    [[[mockUser stub] andReturnValue:OCMOCK_VALUE(objectID)] objectID];
    [[[self.mockSocialize stub] andReturn:mockUser] authenticatedUser];
    
    [[self.mockNavigationItem expect] setRightBarButtonItem:self.profileViewController.editButton];
    
    [self.profileViewController configureEditButton];
}

- (void)testProfileEditViewController {
    self.profileViewController.profileEditViewController = nil;
    SocializeProfileEditViewController *defaultProfileEdit = self.profileViewController.profileEditViewController;
    GHAssertEquals(defaultProfileEdit.delegate, self.origProfileViewController, @"delegate not configured");
}

- (void)testNavigationControllerForEdit {
    self.profileViewController.navigationControllerForEdit = nil;
    
    // Temporarily a nice mock because it needs to pass through UIKit's UINavigationController init
    self.profileViewController.profileEditViewController = [OCMockObject niceMockForClass:[SocializeProfileEditViewController class]];
    
    UINavigationController *defaultNavigationControllerForEdit = self.profileViewController.navigationControllerForEdit;
    GHAssertEquals(defaultNavigationControllerForEdit.delegate, self.origProfileViewController, @"delegate not configured");
}

- (void)testShowEditProfile {
    id mockImage = [OCMockObject mockForClass:[UIImage class]];
    [[[self.mockProfileImageView stub] andReturn:mockImage] image];
    
    id mockUser = [OCMockObject mockForClass:[SocializeFullUser class]];
    [[[mockUser expect] andReturn:@"joe"] firstName];
    [[[mockUser expect] andReturn:@"toe"] lastName];
    [[[mockUser expect] andReturn:@"big toed joe"] description];
    self.profileViewController.fullUser = mockUser;
    
    [[self.mockProfileEditViewController expect] setProfileImage:mockImage];
    [[self.mockProfileEditViewController expect] setFirstName:@"joe"];
    [[self.mockProfileEditViewController expect] setLastName:@"toe"];
    [[self.mockProfileEditViewController expect] setBio:OCMOCK_ANY];
    
    id mockNavigationControllerForEdit = [OCMockObject mockForClass:[UINavigationController class]];
    [[[(id)self.profileViewController stub] andReturn:mockNavigationControllerForEdit] navigationControllerForEdit];
    
    [[(id)self.profileViewController expect] presentModalViewController:mockNavigationControllerForEdit animated:YES];
    [self.profileViewController showEditController];
}

- (void)testSaveProfile {
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
    
    [self.profileViewController profileEditViewControllerDidSave:self.mockProfileEditViewController];
    
    [mockButton verify];
    [mockSubNavigationItem verify];
    [mockNavigation verify];
}

- (void)testServiceFailure {
    [[(id)self.profileViewController expect] stopLoading];
    [[(id)self.profileViewController expect] showAllertWithText:OCMOCK_ANY andTitle:OCMOCK_ANY];
    [self.profileViewController service:nil didFail:nil];
}

- (void)testUserLoadedFromServer {
    id mockFullUser = [OCMockObject mockForProtocol:@protocol(SocializeFullUser)];
    NSArray *elements = [NSArray arrayWithObject:mockFullUser];
    
    [[(id)self.profileViewController expect] stopLoading];
    [[(id)self.profileViewController expect] setFullUser:mockFullUser];
    [[(id)self.profileViewController expect] configureViews];
    
    [self.profileViewController service:nil didFetchElements:elements];
}

- (void)testUserUpdateSentToServer {
    id mockFullUser = [OCMockObject mockForProtocol:@protocol(SocializeFullUser)];
    
    [[(id)self.profileViewController expect] stopLoading];
    [[(id)self.profileViewController expect] setFullUser:mockFullUser];
    [[(id)self.profileViewController expect] configureViews];
    [[(id)self.profileViewController expect] hideEditController];
    
    [self.profileViewController service:nil didUpdate:mockFullUser];
}

@end
