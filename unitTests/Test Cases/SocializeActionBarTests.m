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
@synthesize mockParentController = mockParentController_;
@synthesize parentView = parentView_;
@synthesize mockSocialize = mockSocialize_;
@synthesize mockActionView = mockActionView_;

- (void)reset {
    self.mockParentController = [OCMockObject mockForClass:[UIViewController class]];
    
    self.actionBar = [SocializeActionBar actionBarWithUrl:TEST_ENTITY_URL presentModalInController:self.mockParentController];
    self.actionBar = [OCMockObject partialMockForObject:self.actionBar];
    
    self.mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    self.actionBar.socialize = self.mockSocialize;
    
    // Having troubles expecting (_setViewDelegate:) in OCMock
//    self.mockActionView = [OCMockObject mockForClass:[SocializeActionView class]];
//    [[self.mockActionView expect] _setViewDelegate:OCMOCK_ANY];
    self.mockActionView = [OCMockObject mockForClass:[SocializeActionView class]];
    [[[(id)self.actionBar stub] andReturn:self.mockActionView] view];
}

- (void)setUp {
    [self reset];
}

-(void)tearDown
{
    self.mockParentController = nil;
    self.actionBar = nil;
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
    [[self.mockParentController expect]
      presentModalViewController:[OCMArg checkWithBlock:^(id value) {
        return [value isKindOfClass:[MFMailComposeViewController class]];
      }]
     animated:YES];
    [self.actionBar performSelectorOnMainThread:@selector(shareViaEmail) withObject:nil waitUntilDone:YES];
    [self.mockParentController verify];
}

- (void)testComposerCases {
    /* Tests we don't crash, anyway. Add additional testing if these ever have an effect */
    self.actionBar.shareComposer.completionBlock(MFMailComposeResultCancelled, nil); // currently noop
    self.actionBar.shareComposer.completionBlock(MFMailComposeResultFailed, nil); // currently noop
    self.actionBar.shareComposer.completionBlock(MFMailComposeResultSaved, nil); // currently noop
    self.actionBar.shareComposer.completionBlock(MFMailComposeResultSent, nil); // currently noop
}

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
