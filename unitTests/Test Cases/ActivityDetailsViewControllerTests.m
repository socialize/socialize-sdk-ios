//
//  ActivityDetailsViewControllerTests.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/29/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "ActivityDetailsViewControllerTests.h"
#import "SocializeProfileViewController.h"
#import "URLDownload.h"
#import <OCMock/OCMock.h>

@interface SocializeActivityDetailsViewController()<SocializeProfileViewControllerDelegate>
-(SocializeProfileViewController *)getProfileViewControllerForUser:(id<SocializeUser>)user;
-(void)loadActivityDetailData;
-(void)updateProfileImage;
@end

@implementation ActivityDetailsViewControllerTests

@synthesize activityDetailsViewController = activityDetailsViewController_;
@synthesize partialActivityDetailsViewController = partialActivityDetailsViewController_;
@synthesize mockActivityDetailsView = mockActivityDetailsView_;
@synthesize mockSocializeActivity = mockSocializeActivity_;
@synthesize mockProfileImageDownloader = mockProfileImageDownloader_ ;
@synthesize mockCache = mockCache_;
@synthesize mockActivityViewController = mockActivityViewController_;

-(void)setUp 
{
    self.activityDetailsViewController = [[SocializeActivityDetailsViewController alloc] init];
    self.partialActivityDetailsViewController = [OCMockObject partialMockForObject:self.activityDetailsViewController];
    self.mockActivityDetailsView = [OCMockObject mockForClass:[SocializeActivityDetailsView class]];
    self.mockSocializeActivity = [OCMockObject mockForClass:[SocializeActivityDetailsView class]]; 
    self.mockProfileImageDownloader = [OCMockObject mockForClass:[URLDownload class]];
    
    self.mockCache = [OCMockObject mockForClass:[ImagesCache class]];
    self.mockActivityViewController = [OCMockObject mockForClass:[SocializeActivityDetailsView class]];
    [super setUp];
}

-(void)tearDown
{

    [self.partialActivityDetailsViewController verify];
    [self.mockActivityDetailsView verify];
    [self.mockSocializeActivity verify];
    [self.mockProfileImageDownloader verify];
    [self.mockCache verify];
    [self.mockActivityViewController verify];

    self.activityDetailsViewController = nil;
    self.partialActivityDetailsViewController = nil;
    self.mockActivityDetailsView = nil;
    self.mockSocializeActivity = nil;
    self.mockProfileImageDownloader = nil;
    self.mockCache = nil;
    self.mockActivityViewController = nil;
    [super tearDown];
}

-(void)testFetchActivityForType {
    id mockActivityId = [OCMockObject mockForClass:[NSNumber class]];
    [[[mockActivityId expect] andReturnInteger:0] intValue];
    //make sure that this method makes the call to get a comment
    [[self.mockSocialize expect] getCommentById:0];   
    //there is current restrictions on activity type so we'll pass in ocmock any.  we should add constraints
    [self.activityDetailsViewController fetchActivityForType:OCMOCK_ANY activityID:mockActivityId];       
}
-(void) testProfileButtonTapped {
    /*
    [[[self.partialMockCommentDetailsViewController expect] andReturn:self.mockProfileNavigationController] getProfileViewControllerForUser:OCMOCK_ANY];
    [[[self.partialMockCommentDetailsViewController expect] andReturn:OCMOCK_ANY] createLeftNavigationButtonWithCaption:OCMOCK_ANY];
    
    //setup mock navigation controller
    [[[self.partialMockCommentDetailsViewController expect] andReturn:self.mockNavigationController] navigationController];
    [[self.mockNavigationController expect] pushViewController:self.mockProfileNavigationController animated:YES];
    
    id mockSender = [OCMockObject mockForClass:[UIButton class]];
    [commentDetails profileButtonTapped:mockSender];
     */
}


@end
