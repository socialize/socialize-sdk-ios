//
//  AuthViewControllerTests.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 11/9/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "AuthViewControllerTests.h"
#import "SocializeAuthenticateService.h"

//THIS REDEFINES THE INTERFACES AS PUBLIC SO WE CAN TEST THEM
@interface  SocializeAuthViewController(public)
-(SocializeAuthTableViewCell *)getAuthorizeTableViewCell;
-(SocializeAuthInfoTableViewCell*)getAuthorizeInfoTableViewCell;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(UIBarButtonItem *) createSkipButton;
-(void)skipButtonPressed:(id)button;
-(void)profileViewDidFinish;
@property (nonatomic, retain) id<SocializeAuthViewDelegate> delegate;
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
- (void)setUp { 
    self.authViewController = [[SocializeAuthViewController alloc] initWithNibName:nil bundle:nil];
    //WE'LL CREATE A PARTIAL MOCK INCASE WE WANT TO SWIZZLE/STUB METHODS OUT IN ONE OF THE TESTS
    self.partialMockAuthViewController = [OCMockObject partialMockForObject:self.authViewController];
    self.mockAuthTableViewCell = [OCMockObject niceMockForClass:[SocializeAuthTableViewCell class]];
    self.mockTableView = [OCMockObject mockForClass:[UITableView class]];

}
// Run after each test method
- (void)tearDown { 
    [self.mockAuthTableViewCell verify];
    [self.partialMockAuthViewController verify];
    [self.mockAuthTableViewCell verify];
    [self.mockTableView verify];
    
    //release all the objects and cleanup memory
    self.authViewController = nil;
    self.partialMockAuthViewController = nil;
    self.mockAuthTableViewCell = nil;
    self.mockTableView = [OCMockObject mockForClass:[UITableView class]];
}
-(void) testSkipButtonPressed {
    id mockButton = [OCMockObject mockForClass:[UIButton class]];
    //create and set mock delegate
    id delegate = [OCMockObject mockForProtocol:@protocol(SocializeAuthViewDelegate)];
    [[delegate expect] authorizationSkipped];
    self.authViewController.delegate = delegate;
    [self.authViewController skipButtonPressed:mockButton];
    [delegate verify];
}
- (void) testInitWithDelegate {
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeAuthViewDelegate)];
    SocializeAuthViewController *authController = [[SocializeAuthViewController alloc] initWithDelegate:mockDelegate];
    NSAssert( authController.delegate == mockDelegate, @"The delegate was not set on the init method" );
}


- (void)testCreateWithNavigationController {
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeAuthViewDelegate)];
    NSObject *object = [SocializeAuthViewController createNavigationControllerForAuthViewControllerWithDelegate:mockDelegate];
    NSAssert( [object isKindOfClass:[UINavigationController class]], @"static creation method did not create uinavigation controller" ) ;   
}

- (void)testCreateSkipButton {
    [self.authViewController createSkipButton];
}
- (void)testViewDidLoad {
    id barButtonMock = [OCMockObject niceMockForClass:[UIBarButtonItem class]];
    
    id mockView = [OCMockObject niceMockForClass:[UIView class]]; 
    
    [[[self.partialMockAuthViewController expect] andReturn:barButtonMock] createSkipButton];
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
- (void)setupSectionAuthTypes:(NSString *)authString  withType:(SocializeAuthViewControllerRows) authType  {
    //EXPECT getAuthorizeTableViewCell
    [[[self.partialMockAuthViewController expect] andReturn:self.mockAuthTableViewCell] getAuthorizeTableViewCell];
    id mockLabel = [OCMockObject mockForClass:[UILabel class]];
    [[mockLabel expect] setText:authString];
    [[[self.mockAuthTableViewCell expect] andReturn:mockLabel] cellLabel];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:authType inSection:SocializeAuthViewControllerSectionAuthTypes];
    [self.authViewController tableView:self.mockTableView cellForRowAtIndexPath:path];
    [self.partialMockAuthViewController verify];
}

- (void) testRowForTwitter{
    [self setupSectionAuthTypes:@"Twitter" withType:SocializeAuthViewControllerRowTwitter];
}
- (void) testRowForFacebook{
    [self setupSectionAuthTypes:@"facebook" withType:SocializeAuthViewControllerRowFacebook];
}
- (void) testRowForAuthInfo {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:SocializeAuthViewControllerSectionAuthInfo];
    //mock SocializeAuthInfoTableViewCell
    id mockAuthInfoCell = [OCMockObject niceMockForClass:[SocializeAuthInfoTableViewCell class]];
    //MOCK PARTIAL getAuthorizeInfoTableViewCell
    [[[self.partialMockAuthViewController expect] andReturn:mockAuthInfoCell] getAuthorizeInfoTableViewCell];
    
    [self.authViewController tableView:self.mockTableView cellForRowAtIndexPath:path];
}

- (void)profileViewDelegateWithSelector:(SEL)method {
    id mockProfileViewController = [OCMockObject mockForClass:[SocializeProfileViewController class]];
    [[self.partialMockAuthViewController expect] profileViewDidFinish];
    [self.authViewController performSelector:method withObject:mockProfileViewController];
}
- (void)testProfileViewDidCancel {
    [self profileViewDelegateWithSelector:@selector(profileViewControllerDidCancel:)];
}
- (void)testProfileViewDidSave {
    [self profileViewDelegateWithSelector:@selector(profileViewControllerDidSave:)];    
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
- (void)testDidAuthenticate {
    id mockUser = [OCMockObject mockForProtocol:@protocol(SocializeUser)];
    
    //create and set the mock navigation controller
    id mockNavigationController = [OCMockObject mockForClass:[UINavigationController class]];
    [[mockNavigationController expect] pushViewController:[OCMArg any] animated:YES];
    [[[self.partialMockAuthViewController expect] andReturn:mockNavigationController] navigationController];
     
    //execute the method that needs to be tested
    [self.authViewController didAuthenticate:mockUser];
    
     //verify mocks and responses
    [mockNavigationController verify];
    NSAssert( self.authViewController.user == mockUser, @"the user object was not set after auth");
}
- (void)testProfileViewDidFinish {
    self.authViewController.user = [OCMockObject mockForProtocol:@protocol(SocializeUser)];   
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeAuthViewDelegate)];
    [[[mockDelegate stub] andReturn:[NSNumber numberWithBool:TRUE]] respondsToSelector:@selector(didAuthenticate:)];
    [[mockDelegate expect] didAuthenticate:self.authViewController.user];
    self.authViewController.delegate = mockDelegate;
    [self.authViewController profileViewDidFinish];
    
    //verify mocks to make sure all is ok
    [mockDelegate verify];

}
@end
