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
    
    [[self.mockSocialize expect] setDelegate:nil];
    self.mockParentController = nil;
    self.mockEntity = nil;
    self.origActionBar = nil;
    self.actionBar = nil;
    self.mockSocialize = nil;
    self.mockActionView = nil;
    self.mockShareComposer = nil;
}

- (void)testModalCommentDisplay {
    [[self.mockParentController expect] presentModalViewController:OCMOCK_ANY animated:YES];
    [self.actionBar commentButtonTouched:nil];
    [self.mockParentController verify];
}

- (void)testLikeAndUnlike {
    GHAssertNil(self.actionBar.entityLike, @"Should be nil");
    
    id<SocializeLike> like = [[[SocializeLike alloc] init] autorelease];
    like.entity = [[[SocializeEntity alloc] init] autorelease];
    like.entity.likes = 111;
    
    [[[self.mockSocialize expect] andDo:^(NSInvocation* invocation) {
        [self.actionBar service:nil didCreate:like];
    }] likeEntityWithKey:TEST_ENTITY_URL longitude:nil latitude:nil];
    
    [[self.mockActionView expect] lockButtons];
    [[self.mockActionView expect] updateLikesCount:[NSNumber numberWithInteger:111] liked:YES];
    [[self.mockActionView expect] unlockButtons];
    [[self.mockSocialize expect] getEntityByKey:OCMOCK_ANY];
    [[self.mockSocialize expect] isAuthenticatedWithFacebook];
    [self.actionBar likeButtonTouched:nil];
    [self.mockSocialize verify];
    [self.mockActionView verify];
    
    GHAssertEquals(self.actionBar.entityLike, like, nil);
    [[[self.mockSocialize expect] andDo:^(NSInvocation* invocation) {
        [self.actionBar service:nil didDelete:like];
    }] unlikeEntity:like];
    [[self.mockActionView expect] lockButtons];
    [[self.mockActionView expect] updateLikesCount:[NSNumber numberWithInteger:110] liked:NO];
    [[self.mockActionView expect] unlockButtons];
    [self.actionBar likeButtonTouched:nil];
    GHAssertNil(self.actionBar.entityLike, nil);

    [self.mockSocialize verify];
    [self.mockActionView verify];
}

- (void)testShareShowsActionSheet {
    id mockSheet = [OCMockObject mockForClass:[UIActionSheet class]];
    self.actionBar.shareActionSheet = mockSheet;
    id mockWindow = [OCMockObject mockForClass:[UIWindow class]];
    [[[self.mockActionView expect] andReturn:mockWindow] window];
    [[mockSheet expect] showInView:mockWindow];
    [self.actionBar shareButtonTouched:nil];
    [self.mockActionView verify];
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
    [[self.mockActionView expect] startActivityForUpdateViewsCount];
    BOOL noValue = NO;
    [[[self.mockSocialize expect] andReturnValue:OCMOCK_VALUE(noValue)] isAuthenticated];
    [[(id)self.actionBar expect] performAutoAuth];
    [self.actionBar socializeActionViewWillAppear:self.mockActionView];
}

- (void)testInitialAuth {
    [[self.mockSocialize expect] viewEntity:self.mockEntity longitude:nil latitude:nil];
    [[self.mockSocialize expect] getLikesForEntityKey:TEST_ENTITY_URL first:nil last:nil];
    [self.actionBar afterAnonymouslyLoginAction];
}
    /*
- (void)testShowingViewCausesUpdates {
    id<SocializeUser> user = [[[SocializeUser alloc] init] autorelease];
    BOOL no = NO;
    
    // Immediately complete authentication
    [[[self.mockSocialize expect] andReturnValue:OCMOCK_VALUE(no)] isAuthenticated];
    [[[self.mockSocialize expect] andDo:^(NSInvocation *invocation) {
        [self.actionBar didAuthenticate:user];
    }] authenticateAnonymously];
    
    // Expect animation starts
    [[self.mockActionView expect] startActivityForUpdateViewsCount];
    
    // Force unliked on the view (pre-auth step before user is known)
    [[self.mockActionView expect] updateIsLiked:NO];
    
    // A view should immediately be created on the entity
    [[self.mockSocialize expect] viewEntity:self.actionBar.entity longitude:nil latitude:nil];
    
    // Likes should immediately be retrieved
    [[self.mockSocialize expect] getLikesForEntityKey:TEST_ENTITY_URL first:nil last:nil];
    
    // Kick things off by showing the view
    [self.actionBar socializeActionViewWillAppear:self.mockActionView];
    
    // Verify
    [self.mockSocialize verify];
    [self.mockActionView verify];
}
 */

- (void)testGettingLikesUpdatesView {
    id mockAuth = [OCMockObject mockForClass:[SocializeAuthenticateService class]];
    id<SocializeLike> like = [[[SocializeLike alloc] init] autorelease];
    like.entity = [[[SocializeEntity alloc] init] autorelease];
    like.entity.likes = 10;
    
    // Fake an authenticated user, and place this user in the like response
    id<SocializeUser> user = [[[SocializeUser alloc] init] autorelease];
    user.objectID = 555;
    [[[self.mockSocialize expect] andReturn:user] authenticatedUser];
    like.user = user;
    
    [[self.mockActionView expect] updateLikesCount:[NSNumber numberWithInt:10] liked:YES];
    [self.actionBar service:mockAuth didFetchElements:[NSArray arrayWithObject:like]];
    [self.mockSocialize verify];
    [mockAuth verify];
    [self.mockActionView verify];
    GHAssertEquals(self.actionBar.entityLike, like, nil);
}

@end
