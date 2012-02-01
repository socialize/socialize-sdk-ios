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
#import "UINavigationBarBackground.h"

@interface SocializeProfileViewController ()
- (void)editButtonPressed:(UIBarButtonItem*)button;
- (void)showEditController;
- (UIImage*)defaultProfileImage;
- (void)configureViews;
- (void)configureEditButton;
- (void)hideEditController;
- (void)addActivityControllerToView;
@end

@implementation SocializeProfileViewControllerTests
@synthesize profileViewController = profileViewController_;
@synthesize mockImagesCache = mockImagesCache_;
@synthesize mockProfileImageView = mockProfileImageView_;
@synthesize mockDefaultProfileImage = mockDefaultProfileImage_;
@synthesize mockProfileImageActivityIndicator = mockProfileImageActivityIndicator_;
@synthesize mockUserNameLabel = mockUserNameLabel_;
@synthesize mockUserDescriptionLabel = mockUserDescriptionLabel_;
@synthesize mockActivityViewController = mockActivityViewController_;

- (BOOL)shouldRunOnMainThread {
    return YES;
}

+ (SocializeBaseViewController*)createController {
    return [[[SocializeProfileViewController alloc] init] autorelease];
}

-(void) setUp
{
    [super setUp];
    
    self.profileViewController = (SocializeProfileViewController*)self.viewController;

    self.mockProfileImageView = [OCMockObject mockForClass:[UIImageView class]];
    self.profileViewController.profileImageView = self.mockProfileImageView;
//    [[[(id)self.profileViewController stub] andReturn:self.mockProfileImageView] profileImageView];
    
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
    
    self.mockActivityViewController = [OCMockObject mockForClass:[SocializeActivityViewController class]];
    [[self.mockActivityViewController stub] setDelegate:nil];
    self.profileViewController.activityViewController = self.mockActivityViewController;
}

-(void) tearDown
{
    [(id)self.profileViewController verify];
    [self.mockProfileImageView verify];
    [self.mockImagesCache verify];
    [self.mockDefaultProfileImage verify];
    [self.mockProfileImageActivityIndicator verify];
    [self.mockUserNameLabel verify];
    [self.mockUserDescriptionLabel verify];
    [self.mockActivityViewController verify];

    self.profileViewController = nil;
    self.mockProfileImageView = nil;
    self.mockImagesCache = nil;
    self.mockDefaultProfileImage = nil;
    self.mockProfileImageActivityIndicator = nil;
    self.mockUserNameLabel = nil;
    self.mockUserDescriptionLabel = nil;    
    self.mockActivityViewController = nil;
    
    [super tearDown];
}

-(void)testHideEditController {
    [[(id)self.profileViewController expect] dismissModalViewControllerAnimated:YES];
    [[(id)self.profileViewController expect] stopLoading];
    [self.profileViewController hideEditController];
}

- (void)testBasicViewDidLoad {
//    [[self.mockNavigationBar expect] setBackgroundImage:[UIImage imageNamed:@"socialize-navbar-bg.png"]];
    [[[self.mockNavigationItem stub] andReturn:nil] leftBarButtonItem];
    [[self.mockNavigationItem expect] setLeftBarButtonItem:self.profileViewController.doneButton];
    [[(id)self.profileViewController expect] addActivityControllerToView];
    [[(id)self.profileViewController expect] setProfileImageFromImage:self.profileViewController.defaultProfileImage];
    [self.profileViewController viewDidLoad];
}

- (void)testAfterLoginWithNoUserGetsCurrentUser {
    
    // Expect we get full user for current user from server
    [[(id)self.profileViewController expect] startLoading];
    [[self.mockSocialize expect] getCurrentUser];
    
    [self.profileViewController afterLoginAction:YES];
}

- (void)testAfterLoginWithPartialUser {
    // Set up a mock partial user
    NSInteger userID = 123;
    id mockUser = [OCMockObject mockForProtocol:@protocol(SocializeUser)];
    [[[mockUser expect] andReturnValue:OCMOCK_VALUE(userID)] objectID];
    self.profileViewController.user = mockUser;
    
    [[(id)self.profileViewController expect] startLoading];
    [[self.mockSocialize expect] getUserWithId:userID];
    [self.profileViewController afterLoginAction:YES];
}

- (void)testAfterLoginWithFullUser {
    // Set up a mock full
    id mockFullUser = [OCMockObject mockForProtocol:@protocol(SocializeFullUser)];
    
    self.profileViewController.fullUser = mockFullUser;

    [[(id)self.profileViewController expect] configureViews];
    [self.profileViewController afterLoginAction:YES];
}

- (void)testViewDidUnload {
    [[(id)self.profileViewController expect] setDoneButton:nil];
    [[(id)self.profileViewController expect] setUserNameLabel:nil];
    [[(id)self.profileViewController expect] setUserDescriptionLabel:nil];
    [[(id)self.profileViewController expect] setUserLocationLabel:nil];
    [[(id)self.profileViewController expect] setProfileImageView:nil];
    [[(id)self.profileViewController expect] setDefaultProfileImage:nil];
    [self.profileViewController viewDidUnload];
}

- (void)testDefaultProfileImage {
    self.profileViewController.defaultProfileImage = nil;
    UIImage *defaultProfile = self.profileViewController.defaultProfileImage;
    GHAssertEqualObjects(defaultProfile, [UIImage imageNamed:@"socialize-profileimage-large-default.png"], @"bad profile");
}

- (void)testSettingsButtonShowsSettings {
    [[(id)self.profileViewController expect] showEditController];
    [self.profileViewController settingsButtonPressed:nil];
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
    NSInteger testUserID = 1234;
    [[[mockFullUser stub] andReturn:userName] userName];
    [[[mockFullUser stub] andReturn:firstName] firstName];
    [[[mockFullUser stub] andReturn:lastName] lastName];
    [[[mockFullUser stub] andReturn:smallImageUrl] smallImageUrl];
    [[[mockFullUser stub] andReturnInteger:testUserID] objectID];
    self.profileViewController.fullUser = mockFullUser;
    
    // Labels should be configured
    [[self.mockUserDescriptionLabel expect] setText:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
    [[self.mockUserNameLabel expect] setText:userName];
    
    // Image should be loaded
    [[(id)self.profileViewController expect] setProfileImageFromURL:smallImageUrl];
    
    // Edit button config
    [[(id)self.profileViewController expect] configureEditButton];
    
    // Activity subcontroller should be configured for this user
    [[self.mockActivityViewController expect] setCurrentUser:testUserID];
    
    // Activity content should be initialized
    [[self.mockActivityViewController expect] initializeContent];
    
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
    
    id mockSettingsButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.profileViewController.settingsButton = mockSettingsButton;
    [[self.mockNavigationItem expect] setRightBarButtonItem:mockSettingsButton];
    
    [self.profileViewController configureEditButton];
}

- (void)testProfileEditViewController {
    self.profileViewController.profileEditViewController = nil;
    SocializeProfileEditViewController *defaultProfileEdit = self.profileViewController.profileEditViewController;
    GHAssertEquals(defaultProfileEdit.delegate, self.origViewController, @"delegate not configured");
}

/*
- (void)testNavigationControllerForEdit {
    @autoreleasepool {
    self.profileViewController.navigationControllerForEdit = nil;
    
    // Temporarily a nice mock because it needs to pass through UIKit's UINavigationController init
    self.profileViewController.profileEditViewController = [OCMockObject niceMockForClass:[SocializeProfileEditViewController class]];
    
    UINavigationController *defaultNavigationControllerForEdit = self.profileViewController.navigationControllerForEdit;
    GHAssertEquals(defaultNavigationControllerForEdit.delegate, self.origViewController, @"delegate not configured");
    GHAssertNotNil([UIImage imageNamed:@"socialize-navbar-bg.png"], @"image not found");
    GHAssertEquals([defaultNavigationControllerForEdit.navigationBar backgroundImage], [UIImage imageNamed:@"socialize-navbar-bg.png"], @"bad image");
    }
}
 */

- (void)testShowEditProfile {
    id mockImage = [OCMockObject mockForClass:[UIImage class]];
    [[[self.mockProfileImageView stub] andReturn:mockImage] image];
    
    id mockUser = [OCMockObject mockForClass:[SocializeFullUser class]];
    [[[mockUser expect] andReturn:@"joe"] firstName];
    [[[mockUser expect] andReturn:@"toe"] lastName];
    [[[mockUser expect] andReturn:@"big toed joe"] description];
    self.profileViewController.fullUser = mockUser;

    [[self.mockProfileEditViewController expect] setProfileImage:mockImage];
    [[self.mockProfileEditViewController expect] setFullUser:mockUser];
    
    id mockNavigationControllerForEdit = [OCMockObject mockForClass:[UINavigationController class]];
    [[[(id)self.profileViewController stub] andReturn:mockNavigationControllerForEdit] navigationControllerForEdit];
    
    [[(id)self.profileViewController expect] presentModalViewController:mockNavigationControllerForEdit animated:YES];
    [self.profileViewController showEditController];
}

- (void)testUpdateProfileComplete {
    id mockUser = [OCMockObject mockForProtocol:@protocol(SocializeFullUser)];
    id mockImage = [OCMockObject mockForClass:[UIImage class]];
    [[[self.mockProfileEditViewController stub] andReturn:mockImage] profileImage];
    [[[self.mockProfileEditViewController stub] andReturn:mockUser] fullUser];
    [[(id)self.profileViewController expect] configureViews];
    [[(id)self.profileViewController expect] hideEditController];
    [[self.mockActivityViewController expect] fullUserChanged:mockUser];
    [self.profileViewController profileEditViewController:self.mockProfileEditViewController didUpdateProfileWithUser:mockUser];
    
}

- (void)testEntityLoaderIsCalledWhenActivityTapped {
    id mockActivity = [OCMockObject mockForProtocol:@protocol(SocializeActivity)];
    id mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    [[[mockActivity stub] andReturn:mockEntity] entity];
    
    [Socialize setEntityLoaderBlock:^(UINavigationController *navigationController, id<SocializeEntity>entity) {
        GHAssertEquals(navigationController, self.mockNavigationController, @"Bad nav");
        GHAssertEquals(entity, mockEntity, @"Bad ent");
        [self notify:kGHUnitWaitStatusSuccess];
    }];

    [self prepare];
    [self.profileViewController activityViewController:nil activityTapped:mockActivity];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

@end
