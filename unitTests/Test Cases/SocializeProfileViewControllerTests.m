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

static NSInteger TestUserObjectID=555;

@interface SocializeForTest : Socialize
@end

@implementation SocializeForTest

- (void)getCurrentUser {
    SocializeFullUser *fullUser = [[[SocializeFullUser alloc] init] autorelease];
    fullUser.userName = @"profile_test_user";
    fullUser.objectID = TestUserObjectID;
    NSArray *elements = [NSArray arrayWithObject:fullUser];
    [self.delegate service:nil didFetchElements:elements];
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

-(void) setUpClass
{
}

-(void) tearDownClass
{
}

-(void) testInitialLoad {
    SocializeProfileViewControllerForTest *profile = [[[SocializeProfileViewControllerForTest alloc] init] autorelease];
    SocializeForTest *socialize = [[[SocializeForTest alloc] initWithDelegate:profile] autorelease];
    profile.socialize = socialize;
    [profile viewDidLoad];
    
    GHAssertEquals(profile.user.objectID, TestUserObjectID, @"user.objectID incorrect");
}

- (void)testUpdateProfile {
    SocializeProfileViewControllerForTest *profile = [[[SocializeProfileViewControllerForTest alloc] init] autorelease];
    SocializeForTest *socialize = [[[SocializeForTest alloc] initWithDelegate:profile] autorelease];
    profile.socialize = socialize;
    [profile viewDidLoad];
    [profile.profileEditViewController viewDidLoad];
    [profile.profileEditViewController.keyValueDictionary setObject:@"Some" forKey:@"first name"];
    [profile.profileEditViewController.keyValueDictionary setObject:@"Guy" forKey:@"last name"];

//    FIXME Calling button directly causes a CALayer error
//    UIButton *saveButton = (UIButton*)profile.profileEditViewController.navigationItem.rightBarButtonItem.customView;
//    [saveButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [profile editVCSave:nil];
    
    GHAssertEqualObjects(@"Some", [profile.user firstName], @"first name incorrect");
    GHAssertEqualObjects(@"Guy", [profile.user lastName], @"last name incorrect");
}

@end
