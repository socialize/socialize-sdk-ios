//
//  SocializeBubbleTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/12/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeBubbleViewTests.h"

@interface SocializeBubbleView ()
- (void)animateInStepThree;
@end

@implementation SocializeBubbleViewTests
@synthesize socializeBubbleView = socializeBubbleView_;
@synthesize origSocializeBubbleView = origSocializeBubbleView_;
@synthesize testSize = testSize_;
@synthesize mockContentView = mockContentView_;

- (BOOL)shouldRunOnMainThread {
    return YES;
}

- (void)setUp {
    self.testSize = CGSizeMake(200, 100);
    self.origSocializeBubbleView = [[[SocializeBubbleView alloc] initWithSize:self.testSize] autorelease];
    self.socializeBubbleView = [OCMockObject partialMockForObject:self.origSocializeBubbleView];

    self.mockContentView = [OCMockObject niceMockForClass:[UIView class]];
    self.socializeBubbleView.contentView = self.mockContentView;
}

- (void)tearDown {
    [self.mockContentView verify];
    [(id)self.socializeBubbleView verify];    
    self.socializeBubbleView = nil;
    self.origSocializeBubbleView = nil;
}

- (void)testDrawRect {
    [self.socializeBubbleView drawRect:CGRectMake(0, 0, 20, 20)];
}

- (void)testShowFromRectAnimateInAndCompletesSequence {
    id mockView = [OCMockObject mockForClass:[UIView class]];
    [[mockView expect] addSubview:self.origSocializeBubbleView];
    [[[(id)self.socializeBubbleView expect] andDo:^(NSInvocation *inv) {
        [self notify:kGHUnitWaitStatusSuccess];
    }] animateInStepThree];
    
    [self prepare];
    [self.socializeBubbleView showFromRect:CGRectMake(10, 10, 20, 20) inView:mockView offset:CGPointMake(0, -10) animated:YES];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
}

- (void)testAnimateOutRemovesFromSuperview {
    [[[(id)self.socializeBubbleView expect] andDo:^(NSInvocation *inv) {
        [self notify:kGHUnitWaitStatusSuccess];
    }] removeFromSuperview];

    [self prepare];
    [self.socializeBubbleView animateOutAndRemoveFromSuperview];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
}

@end
