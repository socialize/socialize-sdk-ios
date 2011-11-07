//
//  SocializeProfileEditViewControllerTest.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/3/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeProfileEditViewControllerTest.h"
#import "SocializeProfileEditViewController.h"
#import "SocializeProfileEditTableViewImageCell.h"
#import "SocializeProfileEditTableViewCell.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SocializeProfileEditViewController ()
- (void)cancelButtonPressed:(UIButton*)button;
- (void)saveButtonPressed:(UIButton*)button;
@end

@implementation SocializeProfileEditViewControllerTest
@synthesize origProfileEditViewController = origProfileEditViewController_;
@synthesize profileEditViewController = profileEditViewController_;
@synthesize mockDelegate = mockDelegate_;
@synthesize mockTableView = mockTableView_;
@synthesize mockBundle = mockBundle_;
- (void)setUp {
    self.origProfileEditViewController = [[[SocializeProfileEditViewController alloc] init] autorelease];
    self.profileEditViewController = [OCMockObject partialMockForObject:self.origProfileEditViewController];
    self.mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeProfileEditViewControllerDelegate)];
    self.profileEditViewController.delegate = self.mockDelegate;
    self.mockTableView = [OCMockObject mockForClass:[UITableView class]];
    [[[(id)self.profileEditViewController stub] andReturn:self.mockTableView] view];
    [[[(id)self.profileEditViewController stub] andReturn:self.mockTableView] tableView];
    self.mockBundle = [OCMockObject mockForClass:[NSBundle class]];
    self.profileEditViewController.bundle = self.mockBundle;
    
    // OCMock can not match primitives =(
    for (int section = 0; section < SocializeProfileEditViewControllerNumSections; section++) {
        [[[self.mockTableView stub] andDo:^(NSInvocation *inv) {
            NSInteger rows = [self.profileEditViewController tableView:self.mockTableView numberOfRowsInSection:section];
            [inv setReturnValue:&rows];
        }] numberOfRowsInSection:section];
    }
}

- (void)tearDown {
    self.profileEditViewController = nil;
    self.origProfileEditViewController = nil;
    self.mockDelegate = nil;
    [self.mockDelegate verify];
    [self.mockTableView verify];
    [self.mockBundle verify];
}

- (void)testCancelCallsSelector {
    UIButton *cancelButton = (UIButton*)self.profileEditViewController.cancelButton.customView;
    NSArray *actions = [cancelButton actionsForTarget:self.origProfileEditViewController forControlEvent:UIControlEventTouchUpInside];
    SEL s = NSSelectorFromString([actions objectAtIndex:0]);
    GHAssertEquals(@selector(cancelButtonPressed:), s, @"Selector incorrect");
}

- (void)testCancellingCallsDelegate {
    [[self.mockDelegate expect] profileEditViewControllerDidCancel:self.origProfileEditViewController];
    [self.profileEditViewController cancelButtonPressed:nil];
}

- (void)testSaveCallsSelector {
    UIButton *saveButton = (UIButton*)self.profileEditViewController.saveButton.customView;
    NSArray *actions = [saveButton actionsForTarget:self.origProfileEditViewController forControlEvent:UIControlEventTouchUpInside];
    SEL s = NSSelectorFromString([actions objectAtIndex:0]);
    GHAssertEquals(@selector(saveButtonPressed:), s, @"Selector incorrect");
}

- (void)testSavingCallsDelegate {
    [[self.mockDelegate expect] profileEditViewControllerDidSave:self.origProfileEditViewController];
    [self.profileEditViewController saveButtonPressed:nil];
}

- (void)testImageCellProperties {
    id mockCell = [OCMockObject mockForClass:[SocializeProfileEditTableViewImageCell class]];
    [[[self.mockBundle expect] andDo:^(NSInvocation* inv) {
        self.profileEditViewController.profileImageCell = mockCell;
    }] loadNibNamed:@"SocializeProfileEditTableViewImageCell" owner:OCMOCK_ANY options:nil];
    
    id mockSpinner = [OCMockObject mockForClass:[UIActivityIndicatorView class]];
    id mockImageView = [OCMockObject mockForClass:[UIImageView class]];
    id mockLayer = [OCMockObject mockForClass:[CALayer class]];
    [[[mockCell stub] andReturn:mockSpinner] spinner];
    [[[mockCell stub] andReturn:mockImageView] imageView];
    [[[mockImageView stub] andReturn:mockLayer] layer];
    [[mockLayer expect] setCornerRadius:4];
    [[mockLayer expect] setMasksToBounds:YES];
//    [[mockImageView expect] setImage:nil];
    [[mockSpinner expect] setHidesWhenStopped:YES];
    [[mockSpinner expect] startAnimating];
    [[mockCell expect] setBackgroundColor:[UIColor colorWithRed:35/255.0f green:43/255.0f blue:50/255.0f alpha:1.0]];
    UITableViewCell *cell = [self.profileEditViewController tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    GHAssertEquals(cell, mockCell, @"Bad cell");
}

- (void)testTextCellProperties {
    self.profileEditViewController.firstName = @"Mister";
    id mockCell = [OCMockObject mockForClass:[SocializeProfileEditTableViewCell class]];
    [[[self.mockBundle expect] andDo:^(NSInvocation* inv) {
        self.profileEditViewController.profileTextCell = mockCell;
    }] loadNibNamed:@"SocializeProfileEditTableViewCell" owner:OCMOCK_ANY options:nil];
    
    [[[self.mockTableView expect] andReturn:nil] dequeueReusableCellWithIdentifier:OCMOCK_ANY];
    id mockKeyLabel = [OCMockObject mockForClass:[UILabel class]];
    id mockValueLabel = [OCMockObject mockForClass:[UILabel class]];
    id mockArrowImageView = [OCMockObject mockForClass:[UIImageView class]];
    [[[mockCell expect] andReturn:mockKeyLabel] keyLabel];
    [[[mockCell expect] andReturn:mockValueLabel] valueLabel];
    [[[mockCell expect] andReturn:mockArrowImageView] arrowImageView];
    [[mockKeyLabel expect] setText:@"first name"];
    [[mockValueLabel expect] setText:@"Mister"];
    [[mockArrowImageView expect] setHidden:NO];
    [[mockCell expect] setBackgroundColor:[UIColor colorWithRed:44/255.0f green:54/255.0f blue:63/255.0f alpha:1.0]];
    UITableViewCell *cell = [self.profileEditViewController tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:SocializeProfileEditViewControllerPropertiesRowFirstName inSection:SocializeProfileEditViewControllerSectionProperties]];
    GHAssertEquals(cell, mockCell, @"Bad cell");
}

@end
