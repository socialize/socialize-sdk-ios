//
//  _SZUserProfileViewControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/5/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "_SZUserProfileViewControllerTests.h"
#import "Socialize.h"
#import "SocializeFullUser.h"
#import <OCMock/OCMock.h>
#import "SocializeProfileEditTableViewCell.h"
#import "ImagesCache.h"
#import "UINavigationBarBackground.h"

NSString * const USER_NAME = @"userName";
NSString * const FIRST_NAME = @"firstName";
NSString * const LAST_NAME = @"lastName";
NSString * const DISPLAY_NAME_FULL = @"firstName lastName";
NSString * const SMALL_IMAGE_URL = @"smallImageURL";

@interface _SZUserProfileViewController ()
- (void)editButtonPressed:(UIBarButtonItem*)button;
- (void)showEditController;
- (UIImage*)defaultProfileImage;
- (void)configureViews;
- (void)configureEditButton;
- (void)hideEditController;
- (void)addActivityControllerToView;
@end

@implementation _SZUserProfileViewControllerTests
@synthesize profileViewController = profileViewController_;
@synthesize mockImagesCache = mockImagesCache_;
@synthesize mockProfileImageView = mockProfileImageView_;
@synthesize mockProfileImageBackgroundView = mockProfileImageBackgroundView_;
@synthesize mockDefaultProfileImage = mockDefaultProfileImage_;
@synthesize mockDefaultProfileBackgroundImage = mockDefaultProfileBackgroundImage_;
@synthesize mockProfileImageActivityIndicator = mockProfileImageActivityIndicator_;
@synthesize mockUserNameLabel = mockUserNameLabel_;
@synthesize mockUserDescriptionLabel = mockUserDescriptionLabel_;
@synthesize mockActivityViewController = mockActivityViewController_;

- (BOOL)shouldRunOnMainThread {
    return YES;
}

+ (SocializeBaseViewController*)createController {
    return [[[_SZUserProfileViewController alloc] init] autorelease];
}

-(void) setUp
{
    [super setUp];
    
    self.profileViewController = (_SZUserProfileViewController*)self.viewController;

    self.mockProfileImageView = [OCMockObject mockForClass:[UIImageView class]];
    self.profileViewController.profileImageView = self.mockProfileImageView;
    
    self.mockProfileImageBackgroundView = [OCMockObject mockForClass:[UIImageView class]];
    self.profileViewController.profileImageBackgroundView = self.mockProfileImageBackgroundView;
    
    self.mockImagesCache = [OCMockObject mockForClass:[ImagesCache class]];
    self.profileViewController.imagesCache = self.mockImagesCache;
    
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
    [self.mockDefaultProfileBackgroundImage verify];
    [self.mockProfileImageActivityIndicator verify];
    [self.mockUserNameLabel verify];
    [self.mockUserDescriptionLabel verify];
    [self.mockActivityViewController verify];

    self.profileViewController = nil;
    self.mockProfileImageView = nil;
    self.mockImagesCache = nil;
    self.mockDefaultProfileImage = nil;
    self.mockDefaultProfileBackgroundImage = nil;
    self.mockProfileImageActivityIndicator = nil;
    self.mockUserNameLabel = nil;
    self.mockUserDescriptionLabel = nil;    
    self.mockActivityViewController = nil;
    
    [super tearDown];
}

- (void)testBasicViewDidLoad {
    [self.mockNavigationItem makeNice];
    [[(id)self.profileViewController expect] addActivityControllerToView];
    [[(id)self.profileViewController expect] setProfileImageFromImage:self.profileViewController.defaultProfileImage];
    [self.profileViewController viewDidLoad];
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

//viewDidUnload is deprecated as of iOS 6.0
//- (void)testViewDidUnload {
//    [[(id)self.profileViewController expect] setDoneButton:nil];
//    [[(id)self.profileViewController expect] setUserNameLabel:nil];
//    [[(id)self.profileViewController expect] setUserDescriptionLabel:nil];
//    [[(id)self.profileViewController expect] setUserLocationLabel:nil];
//    [[(id)self.profileViewController expect] setProfileImageView:nil];
//}

- (void)testDefaultProfileImage {
    UIImage *defaultProfile = self.profileViewController.defaultProfileImage;
    //for iOS 7, this should be nil
    GHAssertNil(defaultProfile, @"");
//    GHAssertEqualObjects(defaultProfile, [UIImage imageNamed:@"socialize-profileimage-large-default.png"], @"bad profile");
}

- (void)testSetProfileImageWithNilImage {
    //for iOS 7, this should set to default background image
    [[self.mockProfileImageView expect] setImage:nil];
    [[self.mockProfileImageBackgroundView expect] setImage:[self.profileViewController defaultProfileBackgroundImage]];
    [self.profileViewController setProfileImageFromImage:nil];
}

- (void)testSetProfileImageWithImage {
    //for iOS 7, the background view is the image view (part of flatter L&F)
    id mockImage = [OCMockObject mockForClass:[UIImage class]];
    [[self.mockProfileImageView expect] setImage:nil];
    [[self.mockProfileImageBackgroundView expect] setImage:mockImage];
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

//configure views will all different displayName permutations
- (void)testConfigureViews {
    [self configureViewsWithDisplayName:DISPLAY_NAME_FULL andID:1234];
    [self configureViewsWithDisplayName:FIRST_NAME andID:1235];
    [self configureViewsWithDisplayName:LAST_NAME andID:1236];
    [self configureViewsWithDisplayName:USER_NAME andID:1237];
}

- (void)configureViewsWithDisplayName:(NSString *)displayName andID:(NSInteger)testUserID {
    id mockFullUser = nil;
    if([displayName isEqualToString:DISPLAY_NAME_FULL]) {
        mockFullUser = [self mockFullUserWithFullNameAndID:testUserID];
    }
    else if([displayName isEqualToString:FIRST_NAME]) {
        mockFullUser = [self mockFullUserWithFirstOnlyAndID:testUserID];
    }
    else if([displayName isEqualToString:LAST_NAME]) {
        mockFullUser = [self mockFullUserWithLastOnlyAndID:testUserID];
    }
    else if([displayName isEqualToString:USER_NAME]) {
        mockFullUser = [self mockFullUserWithNoneAndID:testUserID];
    }
    
    // protocol's 'description' collides with an nsobject method
    [self.mockUserDescriptionLabel makeNice];
    
    self.profileViewController.fullUser = mockFullUser;
    
    // Labels should be configured
    [[self.mockUserNameLabel expect] setText:displayName];
    
    // Image should be loaded
    [[(id)self.profileViewController expect] setProfileImageFromURL:SMALL_IMAGE_URL];
    
    // Edit button config
    [[(id)self.profileViewController expect] configureEditButton];
    
    // Activity subcontroller should be configured for this user
    [[self.mockActivityViewController expect] setCurrentUser:testUserID];
    
    // Activity content should be initialized
    [[self.mockActivityViewController expect] initializeContent];
    
    [self.profileViewController configureViews];
}

- (id)mockFullUserWithFullNameAndID:(NSInteger)testUserID {
    id mockFullUser = [OCMockObject niceMockForProtocol:@protocol(SocializeFullUser)];
    [[[mockFullUser stub] andReturn:USER_NAME] userName];
    [[[mockFullUser stub] andReturn:FIRST_NAME] firstName];
    [[[mockFullUser stub] andReturn:LAST_NAME] lastName];
    [[[mockFullUser stub] andReturn:DISPLAY_NAME_FULL] displayName];
    [[[mockFullUser stub] andReturn:SMALL_IMAGE_URL] smallImageUrl];
    [[[mockFullUser stub] andReturnInteger:testUserID] objectID];
    return mockFullUser;
}

- (id)mockFullUserWithNoneAndID:(NSInteger)testUserID {
    id mockFullUser = [OCMockObject niceMockForProtocol:@protocol(SocializeFullUser)];
    [[[mockFullUser stub] andReturn:USER_NAME] userName];
    [[[mockFullUser stub] andReturn:USER_NAME] displayName];
    [[[mockFullUser stub] andReturn:SMALL_IMAGE_URL] smallImageUrl];
    [[[mockFullUser stub] andReturnInteger:testUserID] objectID];
    return mockFullUser;
}

- (id)mockFullUserWithFirstOnlyAndID:(NSInteger)testUserID {
    id mockFullUser = [OCMockObject niceMockForProtocol:@protocol(SocializeFullUser)];
    [[[mockFullUser stub] andReturn:USER_NAME] userName];
    [[[mockFullUser stub] andReturn:FIRST_NAME] firstName];
    [[[mockFullUser stub] andReturn:FIRST_NAME] displayName];
    [[[mockFullUser stub] andReturn:SMALL_IMAGE_URL] smallImageUrl];
    [[[mockFullUser stub] andReturnInteger:testUserID] objectID];
    return mockFullUser;
}

- (id)mockFullUserWithLastOnlyAndID:(NSInteger)testUserID {
    id mockFullUser = [OCMockObject niceMockForProtocol:@protocol(SocializeFullUser)];
    [[[mockFullUser stub] andReturn:USER_NAME] userName];
    [[[mockFullUser stub] andReturn:LAST_NAME] lastName];
    [[[mockFullUser stub] andReturn:LAST_NAME] displayName];
    [[[mockFullUser stub] andReturn:SMALL_IMAGE_URL] smallImageUrl];
    [[[mockFullUser stub] andReturnInteger:testUserID] objectID];
    return mockFullUser;
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
