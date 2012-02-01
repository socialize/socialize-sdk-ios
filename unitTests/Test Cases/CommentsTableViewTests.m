//
//  CommentsTableViewTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 9/13/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "CommentsTableViewTests.h"
#import "SocializeCommentsTableViewController.h"
#import "CommentsTableViewCell.h"
#import <OCMock/OCMock.h>
#import "SocializeTableBGInfoView.h"
#import "SocializeCommentsService.h"
#import "SocializeProfileViewController.h"
#import "SocializeSubscriptionService.h"
#import "SocializeActivityDetailsViewController.h"
#import "SocializeBubbleView.h"
#import "SocializeNotificationToggleBubbleContentView.h"
#import "CommentsTableFooterView.h"

@interface SocializeCommentsTableViewController(public)
-(IBAction)viewProfileButtonTouched:(UIButton*)sender;
-(UIViewController *)getProfileViewControllerForUser:(id<SocializeUser>)user;
-(SocializeActivityDetailsViewController *)createActivityDetailsViewController:(id<SocializeComment>) entryComment;
@end
    
@implementation CommentsTableViewTests
@synthesize commentsTableViewController = commentsTableViewController_;
@synthesize mockView = mockView_;
@synthesize mockSubscribedButton = mockSubscribedButton_;
@synthesize mockBubbleView = mockBubbleView_;
@synthesize mockBubbleContentView = mockBubbleContentView_;
@synthesize mockFooterView = mockFooterView_;

#define TEST_URL @"test_entity_url"

+ (SocializeBaseViewController*)createController {
    return [[[SocializeCommentsTableViewController alloc] initWithNibName:@"SocializeCommentsTableViewController" bundle:nil entryUrlString: TEST_URL] autorelease];
}

-(void)setUp {
    [super setUp];
    // super setUp creates self.viewController
    self.commentsTableViewController = (SocializeCommentsTableViewController*)self.viewController;
    self.mockView = self.mockTableView;
    
    self.mockFooterView = [OCMockObject mockForClass:[CommentsTableFooterView class]];
    self.commentsTableViewController.footerView = self.mockFooterView;
    
    self.mockSubscribedButton = [OCMockObject mockForClass:[UIButton class]];
    [[[self.mockFooterView stub] andReturn:self.mockSubscribedButton] subscribedButton];
        
    self.mockBubbleView = [OCMockObject mockForClass:[SocializeBubbleView class]];
    self.commentsTableViewController.bubbleView = self.mockBubbleView;

    self.mockBubbleContentView = [OCMockObject mockForClass:[SocializeNotificationToggleBubbleContentView class]];
    self.commentsTableViewController.bubbleContentView = self.mockBubbleContentView;
}

-(void)tearDown {
    [super tearDown];
    
    [self.mockFooterView verify];
    [self.mockSubscribedButton verify];
    self.commentsTableViewController = nil;
    self.mockFooterView = nil;
    self.mockSubscribedButton = nil;
}

-(void)testAfterLoginActionInitializesContentAndGetsSubscriptions {
    [[(id)self.commentsTableViewController expect] initializeContent];
    [[self.mockSocialize expect] getSubscriptionsForEntityKey:TEST_URL first:nil last:nil];

    [self.commentsTableViewController afterLoginAction:YES]; 
}

-(void)testServiceSuccess {
    id mockService = [OCMockObject mockForClass:[SocializeCommentsService class]];
    [mockService stubIsKindOfClass:[SocializeCommentsService class]];

    id mockContent = [OCMockObject mockForClass:[NSArray class]];
    [[(id)self.commentsTableViewController expect] receiveNewContent:mockContent];
    [self.commentsTableViewController service:mockService didFetchElements:mockContent];
}

-(void)testDidFail {
    id mockService = [OCMockObject mockForClass:[SocializeCommentsService class]];
    [mockService stubIsKindOfClass:[SocializeCommentsService class]];
    id mockError = [OCMockObject mockForClass:[NSError class]];
    
    [[[mockError stub] andReturn:@"Entity does not exist."] localizedDescription];
    [[(id)self.commentsTableViewController expect] receiveNewContent:nil];
    [self.commentsTableViewController service:mockService didFail:mockError];
}

- (void)makeTableViewNice {
    self.mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
    self.commentsTableViewController.tableView = self.mockTableView;
}

-(void)testViewDidLoad {
    [Socialize setEntityLoaderBlock:nil];
    
//    [self makeTableViewNice];
    [super expectViewDidLoad];

    // Should configure custom label for information
    id mockErrorLabel = [OCMockObject mockForClass:[UILabel class]];
    [[[self.mockInformationView stub] andReturn:mockErrorLabel] errorLabel];
    [[mockErrorLabel expect] setText:OCMOCK_ANY];
    
    [[self.mockNavigationItem expect] setLeftBarButtonItem:self.commentsTableViewController.brandingButton];
    [[self.mockNavigationItem expect] setRightBarButtonItem:self.commentsTableViewController.closeButton];
    
    [[self.mockTableView expect] setScrollsToTop:YES];
    [[self.mockTableView expect] setAutoresizesSubviews:YES];
    [[self.mockTableView expect] setAccessibilityLabel:@"Comments Table View"];
    [[self.mockView expect] setClipsToBounds:YES];
    
    [[self.mockSubscribedButton expect] setEnabled:NO];

    // Notifications are disabled
    [[[self.mockSocialize stub] andReturnBool:NO] notificationsAreConfigured];
    [[self.mockFooterView expect] hideSubscribedButton];
    
    [self.commentsTableViewController viewDidLoad]; 
}

-(void)tesNumberOfSectionsInTableView{

    id mockTable = [OCMockObject niceMockForClass:[UITableView class]];
    int numberOfSections = [self.commentsTableViewController numberOfSectionsInTableView:mockTable]; 
    GHAssertEquals(numberOfSections, 1, @"number of sections");

}

-(void)testdidSelectRowAtIndexPath{
    [self makeTableViewNice];
    self.commentsTableViewController.content = [NSArray arrayWithObject:[NSNumber numberWithInt:45]];
    
    NSIndexPath *indexSet = [NSIndexPath indexPathForRow:0 inSection:0];//[NSIndexPath indexPathWithIndexes:indexArr length:4];
    
    [[self.mockTableView expect] deselectRowAtIndexPath:OCMOCK_ANY animated:YES];
    [[self.mockNavigationController expect] pushViewController:OCMOCK_ANY animated:YES];
    
    //create a mock activity vc to make sure thats what is passed back and configured correct
    id mockActitivtyDetailsController = [OCMockObject niceMockForClass:[SocializeActivityDetailsViewController class]];
    [[[(id)self.commentsTableViewController expect] andReturn:mockActitivtyDetailsController] createActivityDetailsViewController:OCMOCK_ANY];
    
    //lets make sure that the title was set correctly for this viewcontroller
    [[mockActitivtyDetailsController expect] setTitle:@"1 of 1"];
     
    [self.commentsTableViewController tableView:self.mockTableView didSelectRowAtIndexPath:indexSet];
}

-(void)testViewProfileButtonTouched {
    //set the tag so we can look it up in the comments array later
    id mockButton = [OCMockObject mockForClass:[UIButton class]];
    [[[mockButton expect] andReturnValue:[NSNumber numberWithInt:0]] tag];
    
    //create mock user and assign it to the comment
    id mockUser = [OCMockObject niceMockForProtocol:@protocol(SocializeUser)];
    id mockComment = [OCMockObject mockForProtocol:@protocol(SocializeComment)];
    [[[mockComment expect] andReturn:mockUser] user];
    self.commentsTableViewController.content = [NSArray arrayWithObject:mockComment];
    
    //mock out creation of profile controller and present
    id mockProfileViewController = [OCMockObject mockForClass:[SocializeProfileViewController class]];
    [[[(id)self.commentsTableViewController expect] andReturn:mockProfileViewController] getProfileViewControllerForUser:mockUser];
    [[(id)self.commentsTableViewController expect] presentModalViewController:mockProfileViewController animated:YES];
    

    [self.commentsTableViewController viewProfileButtonTouched:mockButton];
    
}
-(void)testTableViewcellForRowAtIndexPath{
    id mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
    id mockCell = [OCMockObject niceMockForClass:[CommentsTableViewCell class]];
    id mockComment = [OCMockObject niceMockForProtocol:@protocol(SocializeComment)]; 
    self.commentsTableViewController.content = [NSArray arrayWithObject:mockComment];

    [[[mockTableView expect] andReturn:mockCell] dequeueReusableCellWithIdentifier:OCMOCK_ANY];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.commentsTableViewController tableView:mockTableView cellForRowAtIndexPath:indexPath];
    
    [mockTableView verify];
    [mockCell verify];
}
/*-(void)testDidSelectIndexAtRowPath{
    
    id navigationControllerMock = [OCMockObject niceMockForClass:[UINavigationController class]];
    
    NSIndexPath* path = [[[NSIndexPath alloc] init] autorelease];
    [listView tableView:OCMOCK_ANY didSelectRowAtIndexPath:path];
    
}
*/


/*
-(void)testAnimationDidStop{

    id mockView = [OCMockObject niceMockForClass:[UIView class]];
    
    listView.view = mockView;
    [[mockView expect] layer];
    [listView animationDidStop:OCMOCK_ANY finished:YES];
    
    [mockView verify]; 
}
*/

-(void)testAddCommentButton{
    [self makeTableViewNice];
    
    [[(id)self.commentsTableViewController expect] presentModalViewController:OCMOCK_ANY animated:YES];
    
    [self.commentsTableViewController addCommentButtonPressed:OCMOCK_ANY];
}

- (void)testCommentCellLayout {
    CommentsTableViewCell *cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setComment:@"Some Comment"];
    UILabel *testSummary = [[[UILabel alloc] initWithFrame:CGRectMake(58, 32, 254, 21)] autorelease];
    cell.summaryLabel = testSummary;
    [cell layoutSubviews];
    GHAssertTrue(CGRectEqualToRect(cell.frame, CGRectMake(0, 0, 320, 65)), @"Bad frame");
    
    [cell release];
}

- (void)testPostingCommentInsertsOnTopAndUpdatesSubscribedButton {
    id mockComment = [OCMockObject mockForProtocol:@protocol(SocializeComment)];
    [[(id)self.commentsTableViewController expect] insertContentAtHead:[NSArray arrayWithObject:mockComment]];
    
    // Stub a post comment where the user chose not to subscribe to the discussion
    id mockPostCommentViewController = [OCMockObject mockForClass:[SocializePostCommentViewController class]];
    [[[mockPostCommentViewController stub] andReturnBool:YES] dontSubscribeToDiscussion];
    
    // Subscribed button should turn off
    [[self.mockSubscribedButton expect] setSelected:NO];
    
    [self.commentsTableViewController postCommentViewController:mockPostCommentViewController didCreateComment:mockComment];
}

- (void)expectBubbleConfigurationForEnabled:(BOOL)enabled {
    [[self.mockBubbleView expect] removeFromSuperview];
    [[(id)self.commentsTableViewController expect] setBubbleView:nil];
    
    // Code will compute the rect to show from, stub in some test values
    CGRect testFrame = CGRectMake(10, 10, 20, 20);
    CGRect testRect = CGRectMake(10, 400, 20, 20);
    [[[self.mockSubscribedButton expect] andReturnValue:OCMOCK_VALUE(testFrame)] frame];
    [[[self.mockSubscribedButton expect] andReturnValue:OCMOCK_VALUE(testRect)] convertRect:testFrame toView:self.mockView];
    
    // View should configure for notification
    [[self.mockBubbleContentView expect] configureForNotificationsEnabled:enabled];
    
//    [[self.mockBubbleView expect] showFromRect:testRect inView:self.mockView animated:YES];
    [[self.mockBubbleView expect] showFromRect:testRect inView:self.mockView offset:CGPointMake(0, -15) animated:YES];
    [[self.mockBubbleView expect] performSelector:@selector(animateOutAndRemoveFromSuperview) withObject:nil afterDelay:2];
}

- (void)testThatPressingEnabledSubscribedButtonCancelsSubscription {
    [[[self.mockSubscribedButton expect] andReturnBool:YES] isSelected];
    [[self.mockSubscribedButton expect] setSelected:NO];
    [[[self.mockSubscribedButton stub] andReturnBool:NO] isSelected];
    [[self.mockSocialize expect] unsubscribeFromCommentsForEntityKey:TEST_URL];
    
    [self expectBubbleConfigurationForEnabled:NO];
    
    [self.commentsTableViewController subscribedButtonPressed:self.mockSubscribedButton];
}

- (void)testThatPressingDisabledSubscribedButtonCreatesSubscription {
    [[[self.mockSubscribedButton expect] andReturnBool:NO] isSelected];
    [[self.mockSubscribedButton expect] setSelected:YES];
    [[[self.mockSubscribedButton stub] andReturnBool:YES] isSelected];

    [[self.mockSocialize expect] subscribeToCommentsForEntityKey:TEST_URL];
    
    [self expectBubbleConfigurationForEnabled:YES];

    [self.commentsTableViewController subscribedButtonPressed:self.mockSubscribedButton];
}

- (void)testFinishingGetSubscriptionsUpdatesButton {
    
    // Array contains an active subscription
    id mockSubscription = [OCMockObject mockForProtocol:@protocol(SocializeSubscription)];
    [[[mockSubscription stub]  andReturnBool:YES] subscribed];
    NSArray *elements = [NSArray arrayWithObject:mockSubscription];

    // Subscription service
    id mockService = [OCMockObject mockForClass:[SocializeSubscriptionService class]];
    [mockService stubIsKindOfClass:[SocializeSubscriptionService class]];

    // Button should enable and become selected
    [[self.mockSubscribedButton expect] setEnabled:YES];
    [[self.mockSubscribedButton expect] setSelected:YES];
    
    [self.commentsTableViewController service:mockService didFetchElements:elements];
}

@end
