//
//  SocializeTableViewTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/23/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeTableViewTests.h"
#import "SocializeTableViewController.h"
#import "SocializeTableBGInfoView.h"

@interface SocializeTableViewController ()
@property (nonatomic, assign, getter=isInitialized) BOOL initialized;
- (void)startLoadingContent;
- (void)contentChanged;
@end

@implementation SocializeTableViewTests
@synthesize tableViewController = tableViewController_;
@synthesize partialTableViewController = partialTableViewController_;
@synthesize mockTableView = mockTableView_;
@synthesize mockInformationView = mockInformationView_;
@synthesize mockTableBackgroundView = mockTableBackgroundView_;
@synthesize mockContent = mockContent_;
@synthesize mockActivityLoadingActivityIndicatorView = mockActivityLoadingActivityIndicatorView_;
@synthesize mockTableFooterView = mockTableFooterView_;

+ (SocializeBaseViewController*)createController {
    return [[[SocializeTableViewController alloc] init] autorelease];
}

- (void)setUp {
    [super setUp];
    
    // super setUp creates self.viewController
    self.tableViewController = (SocializeTableViewController*)self.viewController;
    
    self.mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
    [[self.mockTableView stub] setDelegate:nil];
    [[self.mockTableView stub] setDataSource:nil];
    self.tableViewController.tableView = self.mockTableView;
    
    // Forward some messages
    [[[self.mockTableView stub] andDo:^(NSInvocation *inv) {
        NSInteger rows = [self.tableViewController tableView:self.mockTableView numberOfRowsInSection:0];
        [inv setReturnValue:&rows];
    }] numberOfRowsInSection:0];

    self.mockInformationView = [OCMockObject mockForClass:[SocializeTableBGInfoView class]];
    self.tableViewController.informationView = self.mockInformationView;

    self.mockTableBackgroundView = [OCMockObject mockForClass:[UIView class]];
    self.tableViewController.tableBackgroundView = self.mockTableBackgroundView;
    
    self.mockContent = [OCMockObject mockForClass:[NSMutableArray class]];
    self.tableViewController.content = self.mockContent;

    self.mockActivityLoadingActivityIndicatorView = [OCMockObject mockForClass:[UIActivityIndicatorView class]];
    self.tableViewController.activityLoadingActivityIndicatorView = self.mockActivityLoadingActivityIndicatorView;
    
    self.mockTableFooterView = [OCMockObject mockForClass:[UIView class]];
    self.tableViewController.tableFooterView = self.mockTableFooterView;
}

- (void)tearDown {
    [self.mockTableView verify];
    [self.mockInformationView verify];
    [self.mockTableBackgroundView verify];
    [self.mockContent verify];
    [self.mockActivityLoadingActivityIndicatorView verify];
    
    self.tableViewController = nil;
    self.partialTableViewController = nil;
    self.mockTableView = nil;
    self.mockInformationView = nil;
    self.mockTableBackgroundView = nil;
    self.mockContent = nil;
    self.mockActivityLoadingActivityIndicatorView = nil;
    
    [super tearDown];
}

// By default NO, but if you have a UI test or test dependent on running on the main thread return YES
- (BOOL)shouldRunOnMainThread {
    return YES;
}

- (void)expectViewDidLoad {
    [[self.mockTableView expect] setBackgroundView:self.mockTableBackgroundView];
    [[self.mockTableView expect] addSubview:self.mockInformationView];
}

- (void)testViewDidLoadSetsUpViews {
    [self expectViewDidLoad];
    [self.tableViewController viewDidLoad];
}

- (void)testDefaultInformationViewIsHidden {
    self.tableViewController.informationView = nil;
    [[self.mockTableView stub] frame];
    GHAssertTrue(self.tableViewController.informationView.hidden, @"not hidden");
}

- (void)testClearingContentResetsArray {
    self.tableViewController.content = nil;
    GHAssertTrue([self.tableViewController.content isKindOfClass:[NSMutableArray class]], @"not array");
    GHAssertTrue([self.tableViewController.content count] == 0, @"not empty");
}

- (void)testScrollingToBottomCausesContentLoad {
    
    // Content is 1060px high
    CGSize contentSize = CGSizeMake(320, 1060);
    [[[self.mockTableView stub] andReturnValue:OCMOCK_VALUE(contentSize)] contentSize];
    
    // Offset in scrollView is 600px
    CGPoint contentOffset = CGPointMake(0, 600);
    [[[self.mockTableView stub] andReturnValue:OCMOCK_VALUE(contentOffset)] contentOffset];

    // Tableview is 460px high
    CGRect bounds = CGRectMake(0, 0, 320, 460);
    [[[self.mockTableView stub] andReturnValue:OCMOCK_VALUE(bounds)] bounds];
    
    // 50 items
    [[[self.mockContent stub] andReturnUInteger:50] count];
    
    // Expect subclass content load from 50 onward
    [[(id)self.tableViewController expect] loadContentForNextPageAtOffset:50];

    // Expect scroll view starts animating
    [[self.mockActivityLoadingActivityIndicatorView expect] startAnimating];

    // Simulate scroll event
    [self.tableViewController scrollViewDidScroll:self.mockTableView];
    
//    GHAssertTrue(self.tableViewController.waitingForContent, @"Should be waiting for content");
}

- (void)testNumberOfRowsMatchesContent {
    // 500 items
    [[[self.mockContent stub] andReturnUInteger:500] count];
    
    NSInteger numRows = [self.tableViewController tableView:self.mockTableView numberOfRowsInSection:0];
    GHAssertEquals(numRows, 500, @"Bad count");
}

- (void)testOnlyOneSection {
    NSInteger numSections = [self.tableViewController numberOfSectionsInTableView:self.mockTableView];
    GHAssertEquals(numSections, 1, @"Bad count");
}

- (void)testScrollToTopDoesNothingIfNoContent {
    // 0 items
    [[[self.mockContent stub] andReturnUInteger:0] count];
    
    [self.tableViewController scrollToTop];
}

- (void)testScrollToTopScrollsToTopIfContent {
    // 500 items
    [[[self.mockContent stub] andReturnUInteger:500] count];
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [[self.mockTableView expect] scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableViewController scrollToTop];
}

- (void)testThatInitializingDoesNothingWhenAlreadyInitialized {
    self.tableViewController.initialized = YES;
    [self.tableViewController initializeContent];
}

- (void)testThatInitializingMakesFooterVisibleAndStartsLoading {
    [[self.mockTableView expect] setTableFooterView:self.mockTableFooterView];
    [[(id)self.tableViewController expect] startLoadingContent];
    [self.tableViewController initializeContent];
}

- (void)testThatReceivingNewContentSetsInitialized {
    
    // Don't care about these here
    self.tableViewController.content = nil;
    self.tableViewController.activityLoadingActivityIndicatorView = nil;
    self.tableViewController.tableView = nil;
    self.tableViewController.informationView = nil;
    
    GHAssertFalse(self.tableViewController.isInitialized, @"Should not be initialized");

    [self.tableViewController receiveNewContent:nil];
    
    GHAssertTrue(self.tableViewController.isInitialized, @"Should be initialized");
}

- (void)testThatInsertingContentUpdatesInformationView {
    id mockComment = [OCMockObject mockForProtocol:@protocol(SocializeComment)];

    self.tableViewController.content = [OCMockObject niceMockForClass:[NSMutableArray class]];

    [[(id)self.tableViewController expect] contentChanged];
    [self.tableViewController insertContentAtHead:[NSArray arrayWithObject:mockComment]];
}

@end
