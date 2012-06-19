//
//  SocializeProfileEditValueViewControllerTest.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/9/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeProfileEditValueViewControllerTest.h"
#import "OCMock/OCMock.h"
#import "SocializeEditValueTableViewCell.h"

@interface SocializeProfileEditValueViewController ()
- (void)cancelButtonPressed:(UIButton*)button;
- (void)saveButtonPressed:(UIButton*)button;
- (void)editOccured;
@end

@implementation SocializeProfileEditValueViewControllerTest
@synthesize profileEditValueViewController = profileEditValueViewController_;
@synthesize mockTableView = mockTableView_;
@synthesize mockBundle = mockBundle_;
@synthesize mockSaveButton = mockSaveButton_;

+ (SocializeBaseViewController*)createController {
    return [[[SocializeProfileEditValueViewController alloc] init] autorelease];
}

- (BOOL)shouldRunOnMainThread {
    return YES;
}

- (void)setUp {
    [super setUp];
    
    self.profileEditValueViewController = (SocializeProfileEditValueViewController*)self.viewController;
    
    self.mockTableView = [OCMockObject mockForClass:[UITableView class]];
    [[[(id)self.profileEditValueViewController stub] andReturn:self.mockTableView] view];
    [[[(id)self.profileEditValueViewController stub] andReturn:self.mockTableView] tableView];
    CGRect tableFrame = CGRectMake(0, 0, 320, 460);
    [[[self.mockTableView stub] andReturnValue:OCMOCK_VALUE(tableFrame)] frame];
    
    self.mockBundle = [OCMockObject mockForClass:[NSBundle class]];
    self.profileEditValueViewController.bundle = self.mockBundle;
    
    self.mockSaveButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    self.profileEditValueViewController.saveButton = self.mockSaveButton;
}

- (void)tearDown {
    [(id)self.profileEditValueViewController verify];
    [self.mockSaveButton verify];
    
    
    self.profileEditValueViewController = nil;
    self.mockSaveButton = nil;
    
    [super tearDown];
}

- (void)testUnloadingView {
    [[(id)self.profileEditValueViewController expect] setSaveButton:nil];
    [self.profileEditValueViewController viewDidUnload];
}

- (void)testDefaultBundle {
    self.profileEditValueViewController.bundle = nil;
    NSBundle *bundle = self.profileEditValueViewController.bundle;
    GHAssertEquals(bundle, [NSBundle mainBundle], @"bad bundle");
}

- (void)testTableHeaderView {
    CGRect testFrame = CGRectMake(0, 20, 320, 460);
    [[[self.mockView stub] andReturnValue:OCMOCK_VALUE(testFrame)] frame];
    
    CGRect expectFrame = CGRectMake(0, 0, 320, 30);
    GHAssertTrue(CGRectEqualToRect(expectFrame, self.profileEditValueViewController.tableHeaderView.frame), @"Bad frame");
}

- (void)testViewDidLoad {
    // Some table config
    [[self.mockTableView expect] setSeparatorColor:[UIColor darkGrayColor]];
    [[self.mockTableView expect] setTableHeaderView:self.profileEditValueViewController.tableHeaderView];
    [[self.mockTableView expect] setBackgroundColor:[UIColor colorWithRed:50/255.0f green:58/255.0f blue:67/255.0f alpha:1.0]];
    
    // Expect left is cancel
    [[self.mockNavigationItem expect] setLeftBarButtonItem:self.mockCancelButton];
    
    // Stub in a mock save button
    [[[self.mockNavigationItem stub] andReturn:self.mockSaveButton] rightBarButtonItem];

    // Expect right is save, and disabled
    [[self.mockNavigationItem expect] setRightBarButtonItem:self.mockSaveButton];
    [[self.mockSaveButton expect] setEnabled:NO];
    
    // didedit should be NO
    [[(id)self.profileEditValueViewController expect] setDidEdit:NO];
    
    [self.profileEditValueViewController viewDidLoad];
    
    [self.mockSaveButton verify];
}

- (void)testViewWillAppear {
    [[self.mockTableView expect] reloadData];
}

- (void)testNumberOfRowsInSection {
    NSInteger numRows = [self.profileEditValueViewController tableView:nil numberOfRowsInSection:0];
    GHAssertEquals(numRows, 1, @"bad row count");
}

- (void)testNumberOfSections {
    NSInteger numSections = [self.profileEditValueViewController numberOfSectionsInTableView:nil];
    GHAssertEquals(numSections, 1, @"bad section count");
}

- (void)testEditingOccured {
    // Stub in a mock save button
    id mockSaveButton = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [[[self.mockNavigationItem stub] andReturn:mockSaveButton] rightBarButtonItem];

    [[[(id)self.profileEditValueViewController expect] andForwardToRealObject] setDidEdit:YES];
    [[mockSaveButton expect] setEnabled:YES];
    [self.profileEditValueViewController editOccured];
}

- (void)testTypingCausesEdit {
    [[(id)self.profileEditValueViewController expect] editOccured];
    [self.profileEditValueViewController textField:nil shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:nil];
}

- (void)testClearingCausesEdit {
    [[(id)self.profileEditValueViewController expect] editOccured];
    [self.profileEditValueViewController textFieldShouldClear:nil];
}

- (void)testCellConfiguration {
    // textfield (strangely) set on files owner instead of cell in nib
    id mockTextField = [OCMockObject mockForClass:[UITextField class]];

    // Mock out the nib bundle loading process
    id mockCell = [OCMockObject mockForClass:[SocializeEditValueTableViewCell class]];
    [[[self.mockBundle expect] andDo:^(NSInvocation* inv) {
        self.profileEditValueViewController.editValueCell = mockCell;
        self.profileEditValueViewController.editValueField = mockTextField;
    }] loadNibNamed:@"SocializeEditValueTableViewCell" owner:OCMOCK_ANY options:nil];
    
    // Verify text field configuration
    NSString *title = @"A Title";
    self.profileEditValueViewController.title = title;
    NSString *valueToEdit = @"A Value";
    self.profileEditValueViewController.valueToEdit = valueToEdit;
    [[mockTextField expect] setPlaceholder:title];
    [[mockTextField expect] setAccessibilityLabel:title];
    [[mockTextField expect] setText:valueToEdit];
    [[mockTextField expect] becomeFirstResponder];
    
    UITableViewCell *cell = [self.profileEditValueViewController tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    GHAssertEquals(cell, mockCell, @"Bad cell");

}

- (void)testThatSaveButtonNotifiesDelegateOfCompletion {
    [self expectDelegateNotifiedOfCompletion];
    [self.profileEditValueViewController saveButtonPressed:nil];
}

@end
