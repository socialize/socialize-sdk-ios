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
@synthesize mockActivityViewController = mockActivityViewController_;
@synthesize mockSocializeUser = mockSocializeUser_;

+ (SocializeBaseViewController*)createController {
    return [[[SocializeActivityDetailsViewController alloc] init] autorelease];
}

-(void)setUp 
{
    [super setUp];
    self.activityDetailsViewController = (SocializeActivityDetailsViewController *)self.origViewController;
    self.partialActivityDetailsViewController = (SocializeActivityDetailsViewController *)self.viewController;

    self.mockActivityDetailsView = [OCMockObject niceMockForClass:[SocializeActivityDetailsView class]];
    self.activityDetailsViewController.activityDetailsView = self.mockActivityDetailsView;

    self.mockSocializeActivity = [OCMockObject niceMockForProtocol:@protocol(SocializeActivity)];
    //we have to stub out the user methods because they get called and set when a new activity is passed in
    self.mockSocializeUser = [OCMockObject niceMockForProtocol:@protocol(SocializeUser)];
    [[[self.mockSocializeActivity stub] andReturn:self.mockSocializeUser] user];
    
    self.activityDetailsViewController.socializeActivity = self.mockSocializeActivity;
    self.mockActivityViewController = [OCMockObject mockForClass:[SocializeActivityViewController class]];
    self.activityDetailsViewController.activityViewController = self.mockActivityViewController;
}

-(void)tearDown
{

    [self.partialActivityDetailsViewController verify];
    [self.mockActivityDetailsView verify];
    [self.mockSocializeActivity verify];
    [self.mockActivityViewController verify];
    [self.mockSocializeUser verify];

    self.activityDetailsViewController = nil;
    self.partialActivityDetailsViewController = nil;
    self.mockActivityDetailsView = nil;
    self.mockSocializeActivity = nil;
    self.mockActivityViewController = nil;
    self.mockSocializeUser = nil;
    [super tearDown];
}

-(void)testFetchActivityForType {
    //setup the ns number that is passed into the method
    id mockActivityId = [OCMockObject mockForClass:[NSNumber class]];
    [[[mockActivityId expect] andReturnInteger:0] intValue];
    //make sure that this method makes the call to get a comment
    [[self.mockSocialize expect] getCommentById:0];     
    //there is current restrictions on activity type so we'll pass in ocmock any.  we should add constraints
    [self.activityDetailsViewController fetchActivityForType:OCMOCK_ANY activityID:mockActivityId];       
}
-(void)testDidFetchElements {
    //make sure that the conforms to protocol is called so that we know it's being tested for
    [[[self.mockSocializeActivity stub] andReturnBool:YES] conformsToProtocol:@protocol(SocializeActivity)];
    
    //this is the array that gets passed back from the server
    NSArray *activities = [NSArray arrayWithObject:self.mockSocializeActivity];
    
    //we need to make that the activity data is loaded when an activity comes back from the server
    [[self.partialActivityDetailsViewController expect] loadActivityDetailData];
    
    //make sure that the configuration has been set after a new socialize activity has been passed
    //so that everything gets the right value when being displayed on screen
    [[self.partialActivityDetailsViewController expect] configureDetailsView];
    
    [self.activityDetailsViewController service:OCMOCK_ANY didFetchElements:activities];
    
    GHAssertTrue(self.activityDetailsViewController.socializeActivity == self.mockSocializeActivity, 
                 @"the socialize activity was not set to the instance variable when it returned from the server");
    
}

-(void)loadActivityDetailDataWithNilActivity {
    //this makes sure that initialize content ISNT called when entering load activity with a nil value for socialize activity.  
    //This should fail if anything is called because nothing is mocked out
    self.activityDetailsViewController.socializeActivity = nil;

    //below we're going to reject the method if it gets called
    [[self.partialActivityDetailsViewController reject] initializeContent];
    
    [self.activityDetailsViewController loadActivityDetailData];
}

-(void)loadActivityDetailDataWithValidActivity {
    //make sure that the labels are setup correctly on the view
    [[self.mockActivityDetailsView expect] updateActivityMessage:OCMOCK_ANY withActivityDate:OCMOCK_ANY];

    //verify the content is loaded correctly onto the view
    [[self.mockActivityViewController expect] initializeContent];
    
    //verify that the profile image is called
    [[self.partialActivityDetailsViewController expect] updateProfileImage];
    
    //verify that we stop the animation
    [[self.partialActivityDetailsViewController expect] stopLoadAnimation];
    
    [self.activityDetailsViewController loadActivityDetailData];
}

-(void)testUpdateProfileImageWithValidUrl {
    //this shouldn't be called because we dont have a nil url, hence the EXPECT
    [[self.partialActivityDetailsViewController expect] loadImageAtURL:OCMOCK_ANY 
                                                          startLoading:OCMOCK_ANY
                                                           stopLoading:OCMOCK_ANY
                                                            completion:OCMOCK_ANY];
    [self.activityDetailsViewController updateProfileImage];
}
-(void)testViewWillAppear {
    //lets make sure that the content is loaded
    [[self.partialActivityDetailsViewController expect] loadActivityDetailData];
    [self.activityDetailsViewController viewWillAppear:YES];
}
-(void)testViewDidLoad {
    [[self.partialActivityDetailsViewController expect] configureDetailsView];
    [[self.partialActivityDetailsViewController expect]  startLoadAnimationForView:self.mockActivityDetailsView];  
    [self.activityDetailsViewController viewDidLoad];
}
@end
