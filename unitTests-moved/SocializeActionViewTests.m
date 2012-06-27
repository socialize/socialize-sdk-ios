//
//  SocializeActionTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 8/17/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeActionViewTests.h"
#import "SocializeActionView.h"
#import "SocializeActionViewForTest.h"
#import "UIFontForTest.h"
#import <OCMock/OCMock.h>
#import "NSNumber+Additions.h"

@implementation SocializeActionViewTests

/*// Run at start of all tests in the class
- (void)setUpClass
{
    NSLog(@"setUpClass");
}

// Run at end of all tests in the class
- (void)tearDownClass
{
    NSLog(@"tearDownClass");
}
 */
/*

// Run before each test method
- (void)setUp
{
}

// Run after each test method
- (void)tearDown
{
}
*/
#pragma mark -

#define ORIGIN_X 0
#define ORIGIN_Y 0

#define HEIGHT 44 
#define WIDTH 320 


#pragma mark create more tests

// By default NO, but if you have a UI test or test dependent on running on the main thread return YES
- (BOOL)shouldRunOnMainThread
{
    return YES;
}


-(void)testImagesBeingSet{
    
    id likeButton = [OCMockObject niceMockForClass:[UIButton class]];
    id viewButton = [OCMockObject niceMockForClass:[UIButton class]];
    id commentButton = [OCMockObject niceMockForClass:[UIButton class]];

    //    UIFont * labelFont = [[UIFontForTest alloc] init];
    UIFont* labelFont = [UIFont boldSystemFontOfSize:11.0f];
    id activityIndicator = [OCMockObject niceMockForClass:[UIActivityIndicatorView class]];

    [[commentButton expect] setBackgroundImage:OCMOCK_ANY forState:UIControlStateNormal];
    [[likeButton expect] setBackgroundImage:OCMOCK_ANY forState:UIControlStateNormal];
    [[viewButton expect] setBackgroundImage:OCMOCK_ANY forState:UIControlStateNormal];

    SocializeActionViewForTest* actionView = [[SocializeActionViewForTest alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y, WIDTH, HEIGHT) labelButtonFont:labelFont likeButton:likeButton viewButton:viewButton commentButton:commentButton activityIndicator:activityIndicator];

    [likeButton verify];
    [viewButton verify];
    [commentButton verify];

    CGRect actionRect = CGRectMake(ORIGIN_X, ORIGIN_Y, WIDTH, HEIGHT);
    GHAssertEquals(actionRect, actionView.frame, @"the frame should be the same as we specififed");
    [actionView release];
}

-(void)testUpdateCounts{
    
    id likeButton = [OCMockObject niceMockForClass:[UIButton class]];
    id viewButton = [OCMockObject niceMockForClass:[UIButton class]];
    id commentButton = [OCMockObject niceMockForClass:[UIButton class]];
    
    UIFont* labelFont = [UIFont boldSystemFontOfSize:11.0f];
    id activityIndicator = [OCMockObject niceMockForClass:[UIActivityIndicatorView class]];
    
    SocializeActionViewForTest* actionView = [[SocializeActionViewForTest alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y, WIDTH, HEIGHT) labelButtonFont:labelFont likeButton:likeButton viewButton:viewButton commentButton:commentButton activityIndicator:activityIndicator];

    [[commentButton expect] setTitle:OCMOCK_ANY forState:UIControlStateNormal];
    [[likeButton expect] setTitle:OCMOCK_ANY forState:UIControlStateNormal];
    [[viewButton expect] setTitle:OCMOCK_ANY forState:UIControlStateNormal];
    
    NSNumber* viewsCount = [NSNumber numberWithInt:67];
    NSNumber* likesCount = [NSNumber numberWithInt:67];
    NSNumber* commentsCount = [NSNumber numberWithInt:67];
    
    [actionView updateCountsWithViewsCount: viewsCount withLikesCount: likesCount isLiked: YES withCommentsCount: commentsCount];
    
    [likeButton verify];
    [viewButton verify];
    [commentButton verify];
    
    [actionView release];
}

-(void)testUpdateisLiked{

    id likeButton = [OCMockObject niceMockForClass:[UIButton class]];
    id viewButton = [OCMockObject niceMockForClass:[UIButton class]];
    id commentButton = [OCMockObject niceMockForClass:[UIButton class]];
    
    UIFont* labelFont = [UIFont boldSystemFontOfSize:11.0f];
    id activityIndicator = [OCMockObject niceMockForClass:[UIActivityIndicatorView class]];
    
    SocializeActionViewForTest* actionView = [[SocializeActionViewForTest alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y, WIDTH, HEIGHT) labelButtonFont:labelFont likeButton:likeButton viewButton:viewButton commentButton:commentButton activityIndicator:activityIndicator];
    
    [[likeButton expect] setImage:OCMOCK_ANY forState:UIControlStateNormal];
    [actionView updateIsLiked:NO];
    [actionView updateIsLiked:YES];
    
    [likeButton verify];
    [actionView release];
}

-(void)testLikeDelegate{
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(SocializeActionViewDelegate)];
    
    SocializeActionView* actionView = [[SocializeActionView alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y, WIDTH, HEIGHT)];
    
    actionView.delegate = mockDelegate;
    [[mockDelegate expect] likeButtonTouched:OCMOCK_ANY];
    
    [actionView likeButtonPressed:nil];
    [mockDelegate verify];
}

-(void)testCommentDelegate{
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(SocializeActionViewDelegate)];
    
    SocializeActionView* actionView = [[SocializeActionView alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y, WIDTH, HEIGHT)];
    
    actionView.delegate = mockDelegate;
    [[mockDelegate expect] commentButtonTouched:OCMOCK_ANY];
    
    [actionView commentButtonPressed:nil];
    [mockDelegate verify];
}

- (void)testFormatting {
    NSString *kFormat = [NSNumber formatMyNumber:[NSNumber numberWithInt:1000] ceiling:[NSNumber numberWithInt:1000]];
    GHAssertEqualObjects(kFormat, @"1K+", @"bad format");

    NSString *mFormat = [NSNumber formatMyNumber:[NSNumber numberWithInt:1000000] ceiling:[NSNumber numberWithInt:1000000]];
    GHAssertEqualObjects(mFormat, @"1M+", @"bad format");

    NSString *gFormat = [NSNumber formatMyNumber:[NSNumber numberWithInt:1000000000] ceiling:[NSNumber numberWithInt:1000000000]];
    GHAssertEqualObjects(gFormat, @"1G+", @"bad format");
}

/*
-(void)testLayoutInSuperview
{
    GHAssertNotNil(self.actionBar.view, nil);
    GHAssertTrue(CGRectEqualToRect(self.actionBar.view.frame, CGRectMake(0,416,320,44)), nil);
    GHAssertTrue([self.actionBar.view isKindOfClass: [SocializeActionView class]] ,nil);
    GHAssertEqualStrings(self.actionBar.entity.key, TEST_ENTITY_URL, nil);
}
 */
-(void)testAutoresizeMask
{
    SocializeActionView* actionView = [[SocializeActionView alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y, WIDTH, HEIGHT)];
    GHAssertTrue(actionView.autoresizingMask == (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin), nil);
}

- (void)testNoAutoLayoutDoesNotAutoLayout {
    
    // Make an action view in a large subview with a strange location
    CGRect initialFrame = CGRectMake(1, 2, WIDTH, HEIGHT);
    SocializeActionView* actionView = [[SocializeActionView alloc] initWithFrame:initialFrame];
    UIView *mockView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
    [mockView addSubview:actionView];
    
    // Disable auto layout
    actionView.noAutoLayout = YES;
    
    // Initiate layout event
    [actionView layoutSubviews];
    
    // Frame should not change
    GHAssertTrue(CGRectEqualToRect(initialFrame, actionView.frame), @"Bad frame");
    
    [actionView release];
}

#pragma mark-


@end
