//
//  SocializeActionTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 8/17/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeActionTests.h"
#import "SocializeActionView.h"
#import "SocializeActionViewForTest.h"
#import "UIFontForTest.h"
#import <OCMock/OCMock.h>


@implementation SocializeActionTests

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
    id labelFont = [UIFont systemFontOfSize:14];
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
    
    id labelFont = [OCMockObject niceMockForClass:[UIFont class]];
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
    
    id labelFont = [OCMockObject niceMockForClass:[UIFont class]];
    id activityIndicator = [OCMockObject niceMockForClass:[UIActivityIndicatorView class]];
    
    SocializeActionViewForTest* actionView = [[SocializeActionViewForTest alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y, WIDTH, HEIGHT) labelButtonFont:labelFont likeButton:likeButton viewButton:viewButton commentButton:commentButton activityIndicator:activityIndicator];
    
    [[likeButton expect] setImage:OCMOCK_ANY forState:UIControlStateNormal];
    [actionView updateIsLiked:NO];
    [actionView updateIsLiked:YES];
    
    [likeButton verify];
    [actionView release];
}

-(void)testLikeDelegate{
    
    id likeButton = [OCMockObject niceMockForClass:[UIButton class]];
    id viewButton = [OCMockObject niceMockForClass:[UIButton class]];
    id commentButton = [OCMockObject niceMockForClass:[UIButton class]];
    
    id labelFont = [OCMockObject niceMockForClass:[UIFont class]];
    id activityIndicator = [OCMockObject niceMockForClass:[UIActivityIndicatorView class]];
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(SocializeActionViewDelegate)];
    
    SocializeActionViewForTest* actionView = [[SocializeActionViewForTest alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y, WIDTH, HEIGHT) labelButtonFont:labelFont likeButton:likeButton viewButton:viewButton commentButton:commentButton activityIndicator:activityIndicator];
    
    actionView.delegate = mockDelegate;
    [[mockDelegate expect] likeButtonTouched:OCMOCK_ANY];
    
    [actionView likeButtonPressed:nil];
    [mockDelegate verify];
}

-(void)testCommentDelegate{
    id likeButton = [OCMockObject niceMockForClass:[UIButton class]];
    id viewButton = [OCMockObject niceMockForClass:[UIButton class]];
    id commentButton = [OCMockObject niceMockForClass:[UIButton class]];
    
    id labelFont = [OCMockObject niceMockForClass:[UIFont class]];
    id activityIndicator = [OCMockObject niceMockForClass:[UIActivityIndicatorView class]];
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(SocializeActionViewDelegate)];
    
    SocializeActionViewForTest* actionView = [[SocializeActionViewForTest alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y, WIDTH, HEIGHT) labelButtonFont:labelFont likeButton:likeButton viewButton:viewButton commentButton:commentButton activityIndicator:activityIndicator];
    
    actionView.delegate = mockDelegate;
    [[mockDelegate expect] commentButtonTouched:OCMOCK_ANY];
    
    [actionView commentButtonPressed:nil];
    [mockDelegate verify];

}
#pragma mark-

@end
