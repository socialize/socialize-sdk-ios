/*
 * SocializeActionBarTests.m
 * SocializeSDK
 *
 * Created on 10/10/11.
 * 
 * Copyright (c) 2011 Socialize, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * See Also: http://gabriel.github.com/gh-unit/
 */

#import "SocializeActionBarTests.h"
#import "SocializeActionBar.h"
#import <OCMock/OCMock.h>
#import "Socialize.h"
#import <MessageUI/MessageUI.h>
#import "MFMailComposeViewController+BlocksKit.h"
#import "SocializeAuthenticateService.h"
#import "SocializeLikeService.h"
#import "SocializeEntityService.h"

#define TEST_ENTITY_URL @"http://test.com"
#define TEST_ENTITY_NAME @"TEST_ENTITY_NAME"

@interface UIView (SocializeActionBarTests)
- (void)_setViewDelegate:(id)delegate;
@end

@implementation UIView (SocializeActionBarTests)
- (void)_setViewDelegate:(id)delegate {}
@end

@interface SocializeActionBar()
@property(nonatomic, retain) id<SocializeLike> entityLike;
@property(nonatomic, retain) id<SocializeView> entityView;

-(void) shareViaEmail;
-(void)launchMailAppOnDevice;
-(void)displayComposerSheet;

@end

@implementation SocializeActionBarTests
@synthesize actionBar = actionBar_;
@synthesize origActionBar = origActionBar_;
@synthesize mockParentController = mockParentController_;
@synthesize parentView = parentView_;
@synthesize mockSocialize = mockSocialize_;
@synthesize mockActionView = mockActionView_;
@synthesize mockEntity = mockEntity_;
@synthesize mockShareComposer = mockShareComposer_;

- (BOOL)shouldRunOnMainThread {
    return YES;
}

- (void)setUp {
    self.mockParentController = [OCMockObject mockForClass:[UIViewController class]];
    
    self.mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    [[[self.mockEntity stub] andReturn:TEST_ENTITY_URL] key];
    [[[self.mockEntity stub] andReturn:TEST_ENTITY_NAME] name];

    self.origActionBar = [[[SocializeActionBar alloc] initWithEntity:self.mockEntity presentModalInController:self.mockParentController] autorelease];
    self.actionBar = [OCMockObject partialMockForObject:self.origActionBar];
    
    self.mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    self.actionBar.socialize = self.mockSocialize;
    
    self.mockActionView = [OCMockObject mockForClass:[SocializeActionView class]];
    [[[(id)self.actionBar stub] andReturn:self.mockActionView] view];
    
    self.mockShareComposer = [OCMockObject mockForClass:[MFMailComposeViewController class]];
    self.actionBar.shareComposer = self.mockShareComposer;
}

-(void)tearDown
{
    [self.mockParentController verify];
    [self.mockEntity verify];
    [(id)self.actionBar verify];
    [self.mockSocialize verify];
    [self.mockActionView verify];
    [self.mockShareComposer verify];
    
    [[self.mockSocialize stub] setDelegate:nil];
    self.mockParentController = nil;
    self.mockEntity = nil;
    self.origActionBar = nil;
    self.actionBar = nil;
    self.mockSocialize = nil;
    self.mockActionView = nil;
    self.mockShareComposer = nil;
}

- (id)createMockForServiceClass:(Class)serviceClass {
    id mockService = [OCMockObject mockForClass:serviceClass];
    [[[mockService stub] andReturnBool:YES] isKindOfClass:serviceClass];
    [[[mockService stub] andReturnBool:NO] isKindOfClass:OCMOCK_ANY];
    
    return mockService;
}


- (void)testModalCommentDisplay {
    [[self.mockParentController expect] presentModalViewController:OCMOCK_ANY animated:YES];
    [self.actionBar commentButtonTouched:nil];
}

- (void)testLikeWhenNotLikedLocksAndCreatesLike {
    [[self.mockActionView expect] lockButtons];
    [[self.mockSocialize expect] likeEntityWithKey:TEST_ENTITY_URL longitude:nil latitude:nil];
    [self.actionBar likeButtonTouched:nil];
}

- (void)testLikeWhenAlreadyLikedLocksAndDeletesLike {
    [[self.mockActionView expect] lockButtons];
    id mockLike = [OCMockObject mockForProtocol:@protocol(SocializeLike)];
    self.actionBar.entityLike = mockLike;
    [[self.mockSocialize expect] unlikeEntity:mockLike];
    [self.actionBar likeButtonTouched:nil];
}

- (id)createMockLikeWithLikes:(NSInteger)likes {
    id mockLike = [OCMockObject mockForProtocol:@protocol(SocializeLike)];
    id mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    [[[mockEntity stub] andReturnInteger:likes] likes];
    [[[mockLike stub] andReturn:mockEntity] entity];
    
    return mockLike;
}

- (void)testFinishCreatingLikeUpdatesLikesAndUpdatesFacebookAndReloadsEntity {
    NSInteger testLikes = 1234;
    id mockLike = [self createMockLikeWithLikes:testLikes];
    
    [[self.mockActionView expect] unlockButtons];
    [[self.mockActionView expect] updateLikesCount:[NSNumber numberWithInt:testLikes] liked:YES];
    [[[self.mockSocialize stub] andReturnBool:YES] isAuthenticatedWithFacebook];
//    [[(id)self.actionBar expect] sendActivityToFacebookFeed:mockLike];
    [[self.mockSocialize expect] getEntityByKey:TEST_ENTITY_URL];
    
    [self.actionBar service:nil didCreate:mockLike];
}

- (void)testFinishDeletingLikeUpdatesCountAndUnlocks {
    NSInteger testLikes = 1234;
    id mockLike = [self createMockLikeWithLikes:testLikes];
    self.actionBar.entityLike = mockLike;
    id mockService = [self createMockForServiceClass:[SocializeLikeService class]];
    [[self.mockActionView expect] unlockButtons];
    
    [[self.mockActionView expect] updateLikesCount:[NSNumber numberWithInteger:testLikes-1] liked:NO];
    [self.actionBar service:mockService didDelete:mockLike];
}

- (void)testGettingLikesUpdatesView {
    NSInteger testLikes = 10;
    
    [[self.mockActionView expect] updateLikesCount:[NSNumber numberWithInt:testLikes] liked:YES];
    
    id mockLike = [self createMockLikeWithLikes:testLikes];
    NSInteger testUserID = 555;
    id mockUser = [OCMockObject mockForProtocol:@protocol(SocializeUser)];
    [[[mockUser stub] andReturnInteger:testUserID] objectID];
    [[[self.mockSocialize expect] andReturn:mockUser] authenticatedUser];
    [[[mockLike stub] andReturn:mockUser] user];
    
    id mockService = [OCMockObject mockForClass:[SocializeLikeService class]];
    [[[mockService stub] andReturnBool:YES] isKindOfClass:[SocializeLikeService class]];
    
    [self.actionBar service:mockService didFetchElements:[NSArray arrayWithObject:mockLike]];
}

- (void)testFinishGettingEntityUpdatesCounts {
    NSInteger likes = 1;
    NSInteger comments = 2;
    NSInteger views = 3;
    
    // Assert like
    self.actionBar.entityLike = [OCMockObject mockForProtocol:@protocol(SocializeLike)];
    
    id mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    [[[mockEntity stub] andReturnInteger:likes] likes];
    [[[mockEntity stub] andReturnInteger:comments] comments];
    [[[mockEntity stub] andReturnInteger:views] views];
    [[self.mockActionView expect] updateCountsWithViewsCount:[NSNumber numberWithInteger:views]
                                              withLikesCount:[NSNumber numberWithInteger:likes]
                                                     isLiked:YES
                                           withCommentsCount:[NSNumber numberWithInteger:comments]];
    
    // =(
    id mockService = [self createMockForServiceClass:[SocializeEntityService class]];

    [self.actionBar service:mockService didFetchElements:[NSArray arrayWithObject:mockEntity]];
}

- (void)testShareShowsActionSheet {
    id mockSheet = [OCMockObject mockForClass:[UIActionSheet class]];
    self.actionBar.shareActionSheet = mockSheet;
    id mockWindow = [OCMockObject mockForClass:[UIWindow class]];
    [[[self.mockActionView expect] andReturn:mockWindow] window];
    [[mockSheet expect] showInView:mockWindow];
    [self.actionBar shareButtonTouched:nil];
    [mockSheet verify];
}


- (void)testShareViaEmailShowsComposer {
    [[self.mockShareComposer expect] setSubject:TEST_ENTITY_NAME];
    [[self.mockShareComposer expect] setMessageBody:OCMOCK_ANY isHTML:NO];
    [[self.mockParentController expect] presentModalViewController:self.mockShareComposer animated:YES];

     [self.actionBar shareViaEmail];
}

- (void)testComposerCases {
    self.actionBar.shareComposer = nil;
    /* Tests we don't crash, anyway. Add additional testing if these ever have an effect */
    
    // Make sure it's created on the main thread (exception will be thrown if not)

    self.actionBar.shareComposer.completionBlock(MFMailComposeResultCancelled, nil); // currently noop
    self.actionBar.shareComposer.completionBlock(MFMailComposeResultFailed, nil); // currently noop
    self.actionBar.shareComposer.completionBlock(MFMailComposeResultSaved, nil); // currently noop
    self.actionBar.shareComposer.completionBlock(MFMailComposeResultSent, nil); // currently noop
}

- (void)testShowingViewWhenNotAuthenticated {
    BOOL noValue = NO;
    [[[self.mockSocialize expect] andReturnValue:OCMOCK_VALUE(noValue)] isAuthenticated];
    [[(id)self.actionBar expect] performAutoAuth];
    [self.actionBar socializeActionViewWillAppear:self.mockActionView];
}

- (void)testInitialAuth {
    [[self.mockSocialize expect] viewEntity:self.mockEntity longitude:nil latitude:nil];
    [[self.mockSocialize expect] getLikesForEntityKey:TEST_ENTITY_URL first:nil last:nil];
    [self.actionBar afterLoginAction];
}

- (void)testFailingLikeServiceUnlocksButtonsAndZerosCountsAndShowsError {
    id mockService = [self createMockForServiceClass:[SocializeLikeService class]];
    
    [[self.mockActionView expect] unlockButtons];
    NSNumber *zero = [NSNumber numberWithInteger:0];
    [[self.mockActionView expect] updateCountsWithViewsCount:zero withLikesCount:zero isLiked:NO withCommentsCount:zero];
    
    id mockError = [OCMockObject mockForClass:[NSError class]];
    [[[mockError stub] andReturn:@"ERROR"] localizedDescription];
    
    [[(id)self.actionBar expect] stopLoadAnimation];
    [[(id)self.actionBar expect] showAlertWithText:@"ERROR" andTitle:@"Error"];

    [self.actionBar service:mockService didFail:mockError];
}

- (void)testFailingServiceWithSpecialDoesNotExistStringErrorZeroesCountsAndDoesNotShowError {
    id mockService = [self createMockForServiceClass:[SocializeEntityService class]];
    
    NSNumber *zero = [NSNumber numberWithInteger:0];
    [[self.mockActionView expect] updateCountsWithViewsCount:zero withLikesCount:zero isLiked:NO withCommentsCount:zero];
    
    id mockError = [OCMockObject mockForClass:[NSError class]];
    [[[mockError stub] andReturn:@"Entity does not exist."] localizedDescription];
    
    [self.actionBar service:mockService didFail:mockError];

    // FIXME test that error is actually not shown
}

- (void)testSettingNoAutoLayoutUpdatesActionView {
    [[self.mockActionView expect] setNoAutoLayout:YES];
    self.actionBar.noAutoLayout = YES;
}

- (void)testUnsettingNoAutoLayoutUpdatesActionView {
    [[self.mockActionView expect] setNoAutoLayout:NO];
    self.actionBar.noAutoLayout = NO;
}


@end
