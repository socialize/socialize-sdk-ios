//
//  SocializeActivityViewControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/23/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeActivityViewControllerTests.h"
#import "SocializeActivityViewController.h"
#import "SocializeActivityTableViewCell.h"
#import "SocializeTableBGInfoView.h"
#import <objc/runtime.h>
#import "SocializeActivityService.h"

@interface SocializeActivityViewController ()
- (void)setCurrentUser_:(NSInteger)currentUser;
@end

@implementation SocializeActivityViewControllerTests
@synthesize activityViewController = activityViewController_;
@synthesize mockActivityViewControllerDelegate = mockActivityViewControllerDelegate_;

+ (SocializeBaseViewController*)createController {
    return [[[SocializeActivityViewController alloc] init] autorelease];
}

- (void)setUp {
    [super setUp];
    
    // super setUp creates self.viewController
    self.activityViewController = (SocializeActivityViewController*)self.viewController;
    
    self.mockActivityViewControllerDelegate = [OCMockObject mockForProtocol:@protocol(SocializeActivityViewControllerDelegate)];
    self.activityViewController.delegate = self.mockActivityViewControllerDelegate;
}

- (void)tearDown { 
    [self.mockActivityViewControllerDelegate verify];
    
    self.activityViewController = nil;
    self.mockActivityViewControllerDelegate = nil;
    
    [super tearDown];
}

// By default NO, but if you have a UI test or test dependent on running on the main thread return YES
- (BOOL)shouldRunOnMainThread {
    return YES;
}

- (void)testViewDidLoadConfiguresInformationView {
    [super expectViewDidLoad];
    
    id mockLabel = [OCMockObject mockForClass:[UILabel class]];
    [[[self.mockInformationView stub] andReturn:mockLabel] errorLabel];
    [[mockLabel expect] setText:OCMOCK_ANY];
    [self.activityViewController viewDidLoad];
}

- (void)testCellHeight {
    CGFloat height = [self.activityViewController tableView:self.mockTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    GHAssertEquals(height, SocializeActivityTableViewCellHeight, @"bad height");
}

- (void)testSetCurrentUserClearsContentAndLoadsNewContent {
    [[(id)self.activityViewController expect] clearContent];
    [[(id)self.activityViewController expect] startLoadingContent];
    [self.activityViewController setCurrentUser:55];
    
    GHAssertEquals(self.activityViewController.currentUser, 55, @"Bad id");
}

- (void)testLoadContentCallLoadsAllActivityFromSocialize {
    NSInteger testUserID = 10;

    [self.activityViewController setCurrentUser_:testUserID];
    self.activityViewController.pageSize = 15;
    
    // Start loading
    [[self.mockActivityLoadingActivityIndicatorView stub] startAnimating];
    
    // Expect to load 15 activity items for user with objectID 10, any type
    [[self.mockSocialize expect] getActivityOfUserId:testUserID
                                               first:[NSNumber numberWithInteger:30]
                                                last:[NSNumber numberWithInteger:45]
                                            activity:SocializeAllActivity];

    [self.activityViewController loadContentForNextPageAtOffset:30];
}

- (void)testFinishingGetActivityCallsReceiveNewContent {
    id mockActivityService = [OCMockObject mockForClass:[SocializeActivityService class]];
    [mockActivityService stubIsKindOfClass:[SocializeActivityService class]];

    id mockElements = [OCMockObject mockForClass:[NSArray class]];
    
    [[(id)self.activityViewController expect] receiveNewContent:mockElements];
    [self.activityViewController service:mockActivityService didFetchElements:mockElements];
}

- (void)testFailingGetActivityStopsLoadingContent {
    id mockActivityService = [OCMockObject mockForClass:[SocializeActivityService class]];
    [mockActivityService stubIsKindOfClass:[SocializeActivityService class]];
    
    [[(id)self.activityViewController expect] stopLoadingContent];
    [super expectServiceFailureWithError:nil];
    [self.activityViewController service:mockActivityService didFail:nil];
}

- (void)testCellLoadsFromBundleWhenNotAvailable {
    id mockComment = [OCMockObject niceMockForClass:[SocializeComment class]];
    [mockComment stubIsMemberOfClass:[SocializeComment class]];
    
    [[[self.mockContent stub] andReturn:mockComment] objectAtIndex:0];

    id mockCell = [OCMockObject niceMockForClass:[SocializeActivityTableViewCell class]];
    [[[self.mockBundle stub] andDo:^(NSInvocation *inv) {
        self.activityViewController.activityTableViewCell = mockCell;
    }] loadNibNamed:@"SocializeActivityTableViewCell" owner:self.origViewController options:nil];
    
    [[[self.mockTableView expect] andReturn:nil] dequeueReusableCellWithIdentifier:SocializeActivityTableViewCellReuseIdentifier];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SocializeActivityTableViewCell *cell = (SocializeActivityTableViewCell*)[self.activityViewController tableView:self.mockTableView cellForRowAtIndexPath:indexPath];
    
    GHAssertEquals(cell, mockCell, @"Bad cell");
}

- (void)stubForCellAtIndexPath:(NSIndexPath*)indexPath cell:(id)cell activity:(id)activity {
    // Stub activity as element 0 in content
    [[[self.mockContent stub] andReturn:activity] objectAtIndex:indexPath.row];

    // Return cell as if cached, reusable
    [[[self.mockTableView expect] andReturn:cell] dequeueReusableCellWithIdentifier:SocializeActivityTableViewCellReuseIdentifier];
    
    // In case TableView is reconsulted
    [[[self.mockTableView stub] andReturn:cell] cellForRowAtIndexPath:indexPath];
}

- (void)testCellWithProfileImageNotInCacheAnimatesLoadsAndStopsAnimating {
    NSString *testURL = @"http://www.test.com/image.png";
    
    // Mock activity with user with an image url
    id mockUser = [OCMockObject niceMockForProtocol:@protocol(SocializeUser)];
    [[[mockUser stub] andReturn:testURL] smallImageUrl];
    id mockActivity = [OCMockObject niceMockForClass:[SocializeActivity class]];
    [[[mockActivity stub] andReturn:mockUser] user];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    // Mock cell reusable cell cached/reusable
    id mockCell = [OCMockObject niceMockForClass:[SocializeActivityTableViewCell class]];
    [self stubForCellAtIndexPath:indexPath cell:mockCell activity:mockActivity];
    
    id mockActivityIndicator = [OCMockObject mockForClass:[UIActivityIndicatorView class]];
    [[[mockCell stub] andReturn:mockActivityIndicator] profileImageActivity];
    
    id mockImageView = [OCMockObject mockForClass:[UIImageView class]];
    [[[mockCell stub] andReturn:mockImageView] profileImageView];
    
    // Image loaded from url
    id mockImage = [OCMockObject mockForClass:[UIImage class]];

    [self expectAndSimulateLoadOfImage:mockImage fromURL:testURL];
    
    // Should initially stop animating in case reused cell was already animating
    [[mockActivityIndicator expect] stopAnimating];
    
    // Should go through a full cycle of starting, setting image, and stopping
    [[mockActivityIndicator expect] startAnimating];
    [[mockImageView expect] setImage:mockImage];
    [[mockActivityIndicator expect] stopAnimating];
    
    SocializeActivityTableViewCell *cell = (SocializeActivityTableViewCell*)[self.activityViewController tableView:self.mockTableView cellForRowAtIndexPath:indexPath];
    GHAssertEquals(cell, mockCell, @"Bad cell");
}

- (void)testPressingButtonNotifiesDelegate {
    id mockActivity = [OCMockObject niceMockForClass:[SocializeActivity class]];
    [[[self.mockContent stub] andReturn:mockActivity] objectAtIndex:0];
    id mockUser = [OCMockObject niceMockForProtocol:@protocol(SocializeUser)];
    [[[mockActivity stub] andReturn:mockUser] user];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    // Load a real cell
    [[[self.mockTableView expect] andReturn:nil] dequeueReusableCellWithIdentifier:SocializeActivityTableViewCellReuseIdentifier];
    self.activityViewController.bundle = nil;
    SocializeActivityTableViewCell *cell = (SocializeActivityTableViewCell*)[self.activityViewController tableView:self.mockTableView cellForRowAtIndexPath:indexPath];

    // Expect profileTappedForUser on delegate
    [[self.mockActivityViewControllerDelegate expect] activityViewController:(SocializeActivityViewController*)self.origViewController profileTappedForUser:mockUser];

    // Simulate the button press
    [cell.btnViewProfile simulateControlEvent:UIControlEventTouchUpInside];
}

- (void)testSelectingRowNotifiesDelegate {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    id mockActivity = [OCMockObject niceMockForClass:[SocializeActivity class]];
    [[[self.mockContent stub] andReturn:mockActivity] objectAtIndex:0];
    
    [[self.mockTableView stub] deselectRowAtIndexPath:OCMOCK_ANY animated:YES];
    // Expect profileTappedForUser on delegate
    [[self.mockActivityViewControllerDelegate expect] activityViewController:(SocializeActivityViewController*)self.origViewController activityTapped:mockActivity];

    [self.activityViewController tableView:self.mockTableView didSelectRowAtIndexPath:indexPath];
}

@end