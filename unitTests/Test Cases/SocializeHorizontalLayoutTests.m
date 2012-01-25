//
//  SocializeHorizontalLayoutTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/20/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeHorizontalLayoutTests.h"

@implementation SocializeHorizontalLayoutTests
@synthesize horizontalContainerView = horizontalContainerView_;

- (void)setUp {
    self.horizontalContainerView = [[[SocializeHorizontalContainerView alloc] init] autorelease];
    self.horizontalContainerView = [OCMockObject partialMockForObject:self.horizontalContainerView];
}

- (void)tearDown {
    self.horizontalContainerView = nil;
}

- (void)testLayoutForTwoViews {
    CGRect containerSize = CGRectMake(0, 0, 100, 40);
    self.horizontalContainerView.frame = containerSize;
    
    // Set up a test view
    id firstView = [OCMockObject mockForClass:[UIView class]];
    CGRect firstFrame = CGRectMake(0, 0, 20, 10);
    [[[firstView stub] andReturnValue:OCMOCK_VALUE(firstFrame)] frame];

    // Set up a second test view
    id secondView = [OCMockObject mockForClass:[UIView class]];
    CGRect secondFrame = CGRectMake(0, 0, 40, 30);
    [[[secondView stub] andReturnValue:OCMOCK_VALUE(secondFrame)] frame];
    
    // Second frame should be right justified in container, same size
    CGRect expectedSecondFrame = CGRectMake(60, 0, 40, 30);
    [[secondView expect] setFrame:expectedSecondFrame];
    
    // First frame should be just to the left of that
    CGRect expectedFirstFrame = CGRectMake(40, 0, 20, 10);
    [[firstView expect] setFrame:expectedFirstFrame];
    
    // Set up the columns as our test views
    self.horizontalContainerView.columns = [NSArray arrayWithObjects:firstView, secondView, nil];

    [[(id)self.horizontalContainerView expect] addSubview:secondView];
    [[(id)self.horizontalContainerView expect] addSubview:firstView];
    
    [self.horizontalContainerView layoutColumns];
}

@end
