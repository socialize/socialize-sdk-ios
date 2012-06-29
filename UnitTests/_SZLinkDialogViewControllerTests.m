//
//  AuthViewControllerTests.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 11/9/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "_SZLinkDialogViewControllerTests.h"
#import "SocializeAuthenticateService.h"
#import "SocializeAuthTableViewCell.h"
#import "SocializeAuthInfoTableViewCell.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeThirdPartyTwitter.h"
#import "SocializeTestCase.h"

//THIS REDEFINES THE INTERFACES AS PUBLIC SO WE CAN TEST THEM
@interface  _SZLinkDialogViewController(public)
    -(SocializeAuthTableViewCell *)getAuthorizeTableViewCell;
    -(SocializeAuthInfoTableViewCell*)getAuthorizeInfoTableViewCell;
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
    -(UIBarButtonItem *) createSkipButton;
    -(void)skipButtonPressed:(id)button;
    -(void)profileViewDidFinish;
    -(id)getCellFromNibNamed:(NSString * )nibNamed withClass:(Class)klass;
    -(NSArray *) getTopLevelViewsFromNib:(NSString *)nibName;
    - (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
    @property (nonatomic, retain) id<_SZLinkDialogViewControllerDelegate> delegate;
    @property (nonatomic, retain) id<SocializeUser> user;
@end


BOOL isAuthenticatedWithFacebook = YES;
@implementation SocializeAuthenticateService (UnitTests)
//these are just methods that were static and need to be overriden
+ (BOOL)isAuthenticatedWithFacebook {
    return isAuthenticatedWithFacebook;
}
@end

@implementation AuthViewControllerTests

@synthesize authViewController = _authViewController;
@synthesize mockAuthTableViewCell = _mockAuthTableViewCell;
@synthesize mockTableView = _mockTableView;
@synthesize partialMockAuthViewController = _partialMockAuthViewController;
@synthesize mockSocialize = _mockSocialize;

- (void)setUp { 
    self.authViewController = [[_SZLinkDialogViewController alloc] initWithNibName:nil bundle:nil];
    //WE'LL CREATE A PARTIAL MOCK INCASE WE WANT TO SWIZZLE/STUB METHODS OUT IN ONE OF THE TESTS
    self.partialMockAuthViewController = [OCMockObject partialMockForObject:self.authViewController];
    self.mockAuthTableViewCell = [OCMockObject niceMockForClass:[SocializeAuthTableViewCell class]];
    self.mockTableView = [OCMockObject mockForClass:[UITableView class]];
    self.mockSocialize = [OCMockObject niceMockForClass:[Socialize class]];
    self.authViewController.socialize = self.mockSocialize;
    
    [SocializeThirdPartyFacebook startMockingClass];
    [SocializeThirdPartyTwitter startMockingClass];
}
// Run after each test method
- (void)tearDown { 
    [SocializeThirdPartyTwitter stopMockingClassAndVerify];
    [SocializeThirdPartyFacebook stopMockingClassAndVerify];
    
    [self.mockAuthTableViewCell verify];
    [self.partialMockAuthViewController verify];
    [self.mockAuthTableViewCell verify];
    [self.mockTableView verify];
    [self.mockSocialize verify];
    
    //release all the objects and cleanup memory
    self.authViewController = nil;
    self.partialMockAuthViewController = nil;
    self.mockAuthTableViewCell = nil;
    self.mockSocialize = nil;
}
-(void) testSkipButtonPressed {
    id mockButton = [OCMockObject mockForClass:[UIButton class]];
    //create and set mock delegate
    id delegate = [OCMockObject mockForProtocol:@protocol(_SZLinkDialogViewControllerDelegate)];
    [[delegate expect] authorizationSkipped];
    self.authViewController.delegate = delegate;
    [self.authViewController skipButtonPressed:mockButton];
    [delegate verify];
}
- (void) testInitWithDelegate {
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(_SZLinkDialogViewControllerDelegate)];
    _SZLinkDialogViewController *authController = [[_SZLinkDialogViewController alloc] initWithDelegate:mockDelegate];
    NSAssert( authController.delegate == mockDelegate, @"The delegate was not set on the init method" );
}


- (void)testCreateWithNavigationController {
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(_SZLinkDialogViewControllerDelegate)];
    NSObject *object = [_SZLinkDialogViewController authViewControllerInNavigationController:mockDelegate];
    NSAssert( [object isKindOfClass:[UINavigationController class]], @"static creation method did not create uinavigation controller" ) ;   
}
/*
- (void)testCreateSkipButton {
    [self.authViewController createSkipButton];
}
 */
- (void)testViewDidLoad {
//    id barButtonMock = [OCMockObject niceMockForClass:[UIBarButtonItem class]];
    
    id mockView = [OCMockObject niceMockForClass:[UIView class]]; 
    
//    [[[self.partialMockAuthViewController expect] andReturn:barButtonMock] createSkipButton];
    [[[self.partialMockAuthViewController stub] andReturn:mockView] view];
    [self.authViewController viewDidLoad];
}

-(void)testAuthorizeTableViewCell {
    id mockTableCell = [OCMockObject mockForClass:[SocializeAuthTableViewCell class]];
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
    [[[mockTableView expect] andReturn:mockTableCell] dequeueReusableCellWithIdentifier:@"authorize_cell"];
    self.authViewController.tableView = mockTableView;
    [self.authViewController getAuthorizeTableViewCell];
    
    //VERIFY MOCKS
    [mockTableCell verify];
    [mockTableView verify];
}
- (void)setupSectionAuthTypes:(NSString *)authString  withType:(_SZLinkDialogViewControllerRows) authType  {
    [[[SocializeThirdPartyFacebook stub] andReturnBool:YES] available];
    [[[SocializeThirdPartyTwitter stub] andReturnBool:YES] available];

    //EXPECT getAuthorizeTableViewCell
    [[[self.partialMockAuthViewController expect] andReturn:self.mockAuthTableViewCell] getAuthorizeTableViewCell];
    id mockLabel = [OCMockObject mockForClass:[UILabel class]];
    [[mockLabel expect] setText:authString];
    [[[self.mockAuthTableViewCell expect] andReturn:mockLabel] cellLabel];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:authType inSection:_SZLinkDialogViewControllerSectionAuthTypes];
    [self.authViewController tableView:self.mockTableView cellForRowAtIndexPath:path];
    [self.partialMockAuthViewController verify];
}

- (void) testRowForTwitter{
    [self setupSectionAuthTypes:@"twitter" withType:_SZLinkDialogViewControllerRowTwitter];
}

- (void) testRowForFacebook{
    [self setupSectionAuthTypes:@"facebook" withType:_SZLinkDialogViewControllerRowFacebook];
}

- (void) testRowForAuthInfo {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:_SZLinkDialogViewControllerSectionAuthInfo];
    //mock SocializeAuthInfoTableViewCell
    id mockAuthInfoCell = [OCMockObject niceMockForClass:[SocializeAuthInfoTableViewCell class]];
    //MOCK PARTIAL getAuthorizeInfoTableViewCell
    [[[self.partialMockAuthViewController expect] andReturn:mockAuthInfoCell] getAuthorizeInfoTableViewCell];
    
    [self.authViewController tableView:self.mockTableView cellForRowAtIndexPath:path];
}

-(void) testDidSelectRowForFB {
    [[[SocializeThirdPartyFacebook stub] andReturnBool:YES] available];
    [[[SocializeThirdPartyTwitter stub] andReturnBool:YES] available];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
    [[mockTableView expect] deselectRowAtIndexPath:path animated:YES];
    [self.authViewController tableView:mockTableView didSelectRowAtIndexPath:path];
    [mockTableView verify];
}

-(void) testGetCellFromNib {
    NSMutableArray *topLevelViews = [[NSMutableArray alloc] init];
    id mockCell = [OCMockObject mockForClass:[SocializeAuthInfoTableViewCell class]];
    [[[mockCell expect] andReturnValue:[NSNumber numberWithBool:YES]] isKindOfClass:[OCMArg any]];
    [topLevelViews addObject:mockCell];
    [[[self.partialMockAuthViewController expect] andReturn:topLevelViews] getTopLevelViewsFromNib:@"testnib"];
    [self.authViewController getCellFromNibNamed:@"testnib" withClass:[SocializeAuthTableViewCell class]];
    
    //verify the mock
    [mockCell verify];
}

- (void) testGetAuthorizeInfoTableViewCell {

    //mock the table cell and expect methods
    id mockTableCell = [OCMockObject mockForClass:[UITableViewCell class]];
    [[mockTableCell expect] setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //mock out the table view
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
    [[[mockTableView expect] andReturn:mockTableCell] dequeueReusableCellWithIdentifier:@"authorize_info_cell"];
    
    self.authViewController.tableView = mockTableView;
    [self.authViewController getAuthorizeInfoTableViewCell];
    
    //call verify to make sure everything went as planned
    [mockTableCell verify];
    [mockTableView verify];
}

@end
