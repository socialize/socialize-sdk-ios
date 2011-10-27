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

static NSInteger TestUserObjectID=555;

@interface SocializeForTest : Socialize
@end

@implementation SocializeForTest

- (void)getUserWithId:(int)userId {
    SocializeFullUser *fullUser = [[[SocializeFullUser alloc] init] autorelease];
    fullUser.objectID = userId;
    fullUser.userName = @"other_user";
    fullUser.objectID = TestUserObjectID;
    NSArray *elements = [NSArray arrayWithObject:fullUser];
    [self.delegate service:nil didFetchElements:elements];
}

- (void)getCurrentUser {
    SocializeFullUser *fullUser = [[[SocializeFullUser alloc] init] autorelease];
    fullUser.userName = @"current_user";
    fullUser.objectID = TestUserObjectID;
    fullUser.smallImageUrl = @"http://someimage.jpeg";
    fullUser.lastName = @"whatever";
    fullUser.description = @"my description";
    NSArray *elements = [NSArray arrayWithObject:fullUser];
    [self.delegate service:nil didFetchElements:elements];
}

- (id<SocializeUser>)authenticatedUser {
    SocializeUser *user = [self createObjectForProtocol:@protocol(SocializeUser)];
    user.objectID = TestUserObjectID;
    return user;
}

- (void)updateUserProfile:(id<SocializeFullUser>)user profileImage:(UIImage *)profileImage {
    [self.delegate service:nil didUpdate:user];
}

@end

@interface SocializeProfileViewController ()
- (void)editButtonPressed:(UIBarButtonItem*)button;
@end

@interface SocializeProfileViewControllerForTest : SocializeProfileViewController
@end

@implementation SocializeProfileViewControllerForTest
- (void)startLoading {}
- (id)view { return nil; }
@end

@implementation SocializeProfileViewControllerTests
@synthesize profileViewController = profileViewController_;
@synthesize socialize = socialize_;

- (void)reset {
    self.profileViewController = [[[SocializeProfileViewControllerForTest alloc] init] autorelease];

    self.socialize = [[[SocializeForTest alloc] initWithDelegate:self.profileViewController] autorelease];
    self.profileViewController.socialize = self.socialize;
    
    id mockImagesCache = [OCMockObject mockForClass:[ImagesCache class]];
    [[[mockImagesCache stub] andReturn:[OCMockObject mockForClass:[UIImage class]]] imageFromCache:OCMOCK_ANY];
    self.profileViewController.imagesCache = mockImagesCache;
}

-(void) setUpClass
{
    [self reset];
}

-(void) tearDownClass
{
    self.profileViewController = nil;
    self.socialize = nil;
}

-(void) testInitialLoad {
    [self reset];
    [self.profileViewController viewDidLoad];

    GHAssertEquals(self.profileViewController.fullUser.objectID, TestUserObjectID, @"user.objectID incorrect");
}

- (void)testUpdateProfile {
    [self reset];
    [self.profileViewController viewDidLoad];
    self.profileViewController.navigationControllerForEdit = nil;
    [self.profileViewController editButtonPressed:nil];

    [self.profileViewController.profileEditViewController viewDidLoad];
    [self.profileViewController.profileEditViewController.keyValueDictionary setObject:@"Some" forKey:@"first name"];
    [self.profileViewController.profileEditViewController.keyValueDictionary setObject:@"Guy" forKey:@"last name"];

    [self.profileViewController editVCSave:nil];
    
    GHAssertEqualObjects(@"Some", [self.profileViewController.fullUser firstName], @"first name incorrect");
    GHAssertEqualObjects(@"Guy", [self.profileViewController.fullUser lastName], @"last name incorrect");
}

- (void)testFullUserIsPopulated {
    [self reset];
    
    SocializeUser *partialUser = [self.socialize createObjectForProtocol:@protocol(SocializeUser)];
    partialUser.objectID = 222;
    self.profileViewController.user = partialUser;
    [self.profileViewController viewDidLoad];

    id<SocializeFullUser> fullUser = self.profileViewController.fullUser;
    GHAssertEqualObjects(@"other_user", fullUser.userName, @"Bad username");
}

- (void)testDoneButton {
    [self.profileViewController doneButtonPressed:nil];
}

- (void)testHelpers {
    SocializeProfileViewController *profile = (SocializeProfileViewController*)[(UINavigationController*)[SocializeProfileViewController currentUserProfileWithDelegate:self] topViewController];
    GHAssertTrue(profile.delegate == self, @"Bad delegate");
}

- (void)profileViewControllerDidSave:(SocializeProfileViewController *)profileViewController {
    
}

- (void)profileViewControllerDidCancel:(SocializeProfileViewController *)profileViewController {
    
}

@end
